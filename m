Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3912C0838
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732762AbgKWMqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:46:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:60200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732758AbgKWMqg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:46:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50ADB20857;
        Mon, 23 Nov 2020 12:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135596;
        bh=bF7j7kc1wI4juKfZsy39iL2//mp5XAyUOFzNMc18fuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=19d3Fr7I+e+7pV4Fdsp6A/kVcfjoKEvfZDt9dacxLGZ2F4u19AU+ZDkeXOi5BZJNT
         OYDSpfonwK93xOUXFuHK8RNy6WgpmbDb4A+D013Sjv7OB81lXdUKTB4ppwAKoaLjh3
         tJW3NEAPldRMLqakV1uSDEXf5MPe7GcfW/8sq1LM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Hai <wanghai38@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 126/252] tools, bpftool: Add missing close before bpftool net attach exit
Date:   Mon, 23 Nov 2020 13:21:16 +0100
Message-Id: <20201123121841.669972251@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 50431b45685b600fc2851a3f2b53e24643efe6d3 ]

progfd is created by prog_parse_fd() in do_attach() and before the latter
returns in case of success, the file descriptor should be closed.

Fixes: 04949ccc273e ("tools: bpftool: add net attach command to attach XDP on interface")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20201113115152.53178-1-wanghai38@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/net.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index 56c3a2bae3ef2..029c8188a2f90 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -313,8 +313,8 @@ static int do_attach(int argc, char **argv)
 
 	ifindex = net_parse_dev(&argc, &argv);
 	if (ifindex < 1) {
-		close(progfd);
-		return -EINVAL;
+		err = -EINVAL;
+		goto cleanup;
 	}
 
 	if (argc) {
@@ -322,8 +322,8 @@ static int do_attach(int argc, char **argv)
 			overwrite = true;
 		} else {
 			p_err("expected 'overwrite', got: '%s'?", *argv);
-			close(progfd);
-			return -EINVAL;
+			err = -EINVAL;
+			goto cleanup;
 		}
 	}
 
@@ -331,17 +331,17 @@ static int do_attach(int argc, char **argv)
 	if (is_prefix("xdp", attach_type_strings[attach_type]))
 		err = do_attach_detach_xdp(progfd, attach_type, ifindex,
 					   overwrite);
-
-	if (err < 0) {
+	if (err) {
 		p_err("interface %s attach failed: %s",
 		      attach_type_strings[attach_type], strerror(-err));
-		return err;
+		goto cleanup;
 	}
 
 	if (json_output)
 		jsonw_null(json_wtr);
-
-	return 0;
+cleanup:
+	close(progfd);
+	return err;
 }
 
 static int do_detach(int argc, char **argv)
-- 
2.27.0



