Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885943D6191
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbhGZPcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231621AbhGZPaD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:30:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 493FB60C41;
        Mon, 26 Jul 2021 16:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315831;
        bh=Sc56Wvur+m4tgvpLaqa2M+Ju5Pax3tCaPpkNx+96MAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZeDrV4u3Dj/rGO54dI9wTe1nX9ydjiTULt+zs+OKw2RQT2g9dVGxthMAdrOsW48pz
         +8eje0/WxEH9B2ThFmbHQOYBh3I/r+3GGY0fFj3ajJwwGGATMnXGCzM1S6dKL2rsV6
         2/lYIKA3ElSpBjgNdyXazKCI94ectrPnoym6BcI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Klauser <tklauser@distanz.ch>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Quentin Monnet <quentin@isovalent.com>,
        Roman Gushchin <guro@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 085/223] bpftool: Check malloc return value in mount_bpffs_for_pin
Date:   Mon, 26 Jul 2021 17:37:57 +0200
Message-Id: <20210726153849.021436007@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tobias Klauser <tklauser@distanz.ch>

[ Upstream commit d444b06e40855219ef38b5e9286db16d435f06dc ]

Fix and add a missing NULL check for the prior malloc() call.

Fixes: 49a086c201a9 ("bpftool: implement prog load command")
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Acked-by: Roman Gushchin <guro@fb.com>
Link: https://lore.kernel.org/bpf/20210715110609.29364-1-tklauser@distanz.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/common.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index 1828bba19020..dc6daa193557 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -222,6 +222,11 @@ int mount_bpffs_for_pin(const char *name)
 	int err = 0;
 
 	file = malloc(strlen(name) + 1);
+	if (!file) {
+		p_err("mem alloc failed");
+		return -1;
+	}
+
 	strcpy(file, name);
 	dir = dirname(file);
 
-- 
2.30.2



