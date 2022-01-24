Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE4649A042
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1843589AbiAXXFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382474AbiAXW4C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:56:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA4EC055AA0;
        Mon, 24 Jan 2022 13:10:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CD006141C;
        Mon, 24 Jan 2022 21:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC78C340E5;
        Mon, 24 Jan 2022 21:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058633;
        bh=1sxxLQIPWRG6aWSNdg8Rs1aLFGBqVedpdVrcpjRSgSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dWlCZEk4OmQgk1laMwEUiMQ0BDnklTLeJXYWMQAOMATGv6MD9Ru0l0Boj9Y+WowtM
         AYZNNcnm/dpxOL5Le41aEQzbWqLkr4jRLbTDPaIEO5Rhf2PVwV7CXcidDongP3pKsu
         /YJfgrJQci4JMNLDa+6IEzINPNb+Kvj11B8lLBMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bernard Zhao <bernard@vivo.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0335/1039] selinux: fix potential memleak in selinux_add_opt()
Date:   Mon, 24 Jan 2022 19:35:24 +0100
Message-Id: <20220124184136.568570374@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bernard Zhao <bernard@vivo.com>

[ Upstream commit 2e08df3c7c4e4e74e3dd5104c100f0bf6288aaa8 ]

This patch try to fix potential memleak in error branch.

Fixes: ba6418623385 ("selinux: new helper - selinux_add_opt()")
Signed-off-by: Bernard Zhao <bernard@vivo.com>
[PM: tweak the subject line, add Fixes tag]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/hooks.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index dde4ecc0cd186..49b4f59db35e7 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -988,18 +988,22 @@ out:
 static int selinux_add_opt(int token, const char *s, void **mnt_opts)
 {
 	struct selinux_mnt_opts *opts = *mnt_opts;
+	bool is_alloc_opts = false;
 
 	if (token == Opt_seclabel)	/* eaten and completely ignored */
 		return 0;
 
+	if (!s)
+		return -ENOMEM;
+
 	if (!opts) {
 		opts = kzalloc(sizeof(struct selinux_mnt_opts), GFP_KERNEL);
 		if (!opts)
 			return -ENOMEM;
 		*mnt_opts = opts;
+		is_alloc_opts = true;
 	}
-	if (!s)
-		return -ENOMEM;
+
 	switch (token) {
 	case Opt_context:
 		if (opts->context || opts->defcontext)
@@ -1024,6 +1028,10 @@ static int selinux_add_opt(int token, const char *s, void **mnt_opts)
 	}
 	return 0;
 Einval:
+	if (is_alloc_opts) {
+		kfree(opts);
+		*mnt_opts = NULL;
+	}
 	pr_warn(SEL_MOUNT_FAIL_MSG);
 	return -EINVAL;
 }
-- 
2.34.1



