Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3D6412C4FB
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbfL2RcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:32:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:60112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729234AbfL2RcB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:32:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6E1A21D7E;
        Sun, 29 Dec 2019 17:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640721;
        bh=b2lAYCsdQxVm++sV8rB0j0PrTWG0XRnBQ7ixlh3Ihrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jl7pYeCMzbDfZODgx4uHRlFOJZmHTKqfkRzubDsDP4Mb4p1yDPM+vcVVpMRIX49F7
         PoX60Tgf6bGTmFMZElIDBhXjCUrIcxjbkZJpHd67AkW7jXRwtM+vkvUlQdActGpvot
         V7d4CygIo94gFSvt+VjbbdzU8UQLN+ovg+mY8bos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 111/219] libbpf: Fix error handling in bpf_map__reuse_fd()
Date:   Sun, 29 Dec 2019 18:18:33 +0100
Message-Id: <20191229162525.365128942@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit d1b4574a4b86565325ef2e545eda8dfc9aa07c60 ]

bpf_map__reuse_fd() was calling close() in the error path before returning
an error value based on errno. However, close can change errno, so that can
lead to potentially misleading error messages. Instead, explicitly store
errno in the err variable before each goto.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/157269297769.394725.12634985106772698611.stgit@toke.dk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a62be78fc07b..249fa8d7376e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1073,16 +1073,22 @@ int bpf_map__reuse_fd(struct bpf_map *map, int fd)
 		return -errno;
 
 	new_fd = open("/", O_RDONLY | O_CLOEXEC);
-	if (new_fd < 0)
+	if (new_fd < 0) {
+		err = -errno;
 		goto err_free_new_name;
+	}
 
 	new_fd = dup3(fd, new_fd, O_CLOEXEC);
-	if (new_fd < 0)
+	if (new_fd < 0) {
+		err = -errno;
 		goto err_close_new_fd;
+	}
 
 	err = zclose(map->fd);
-	if (err)
+	if (err) {
+		err = -errno;
 		goto err_close_new_fd;
+	}
 	free(map->name);
 
 	map->fd = new_fd;
@@ -1101,7 +1107,7 @@ err_close_new_fd:
 	close(new_fd);
 err_free_new_name:
 	free(new_name);
-	return -errno;
+	return err;
 }
 
 static int
-- 
2.20.1



