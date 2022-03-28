Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020994E948F
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241296AbiC1Lag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241334AbiC1LaJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:30:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA9E62D6;
        Mon, 28 Mar 2022 04:23:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8ACF6114A;
        Mon, 28 Mar 2022 11:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0178C340ED;
        Mon, 28 Mar 2022 11:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466629;
        bh=69LG3LRf0yfNZTzLYNNB0TPVKM9hryNAVfUJeGF9CKM=;
        h=From:To:Cc:Subject:Date:From;
        b=JyvfzHUpR3iUjJbmRBs9j/RhZWGw1aWol/USV5/MDaCFWLViqqWipPAX6G1Yp2HUq
         9jyDzDlW0dlnQw2K47oL/v5xsjfkVxb3+sxn+ySbzv0JGQj43u0Iq8xv32nkQsyPxJ
         nrEefGSoVJAU1HcTO+imWyT2WqajeUWzEj+ax4n9XA7MY1eAWuQ7aH5JWwTEyLzAJS
         6Tdu6weTR1nI9tJMsPvrCA8CxlCsJ2Y89L3QjiP8OsR3fFykYwOQU7S8s/UpyeN22o
         AP/pVFEJcAbDxKZYtm14ryUtiAfvnIoSXucEfWaU1vCU7SY+vhlMppdaQmclJkLQuF
         IaH89rKrCjq8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        syzbot+d1e3b1d92d25abf97943@syzkaller.appspotmail.com,
        James Morris <jamorris@linux.microsoft.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>, jmorris@namei.org,
        serge@hallyn.com, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/16] LSM: general protection fault in legacy_parse_param
Date:   Mon, 28 Mar 2022 07:23:30 -0400
Message-Id: <20220328112345.1556601-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>

[ Upstream commit ecff30575b5ad0eda149aadad247b7f75411fd47 ]

The usual LSM hook "bail on fail" scheme doesn't work for cases where
a security module may return an error code indicating that it does not
recognize an input.  In this particular case Smack sees a mount option
that it recognizes, and returns 0. A call to a BPF hook follows, which
returns -ENOPARAM, which confuses the caller because Smack has processed
its data.

The SELinux hook incorrectly returns 1 on success. There was a time
when this was correct, however the current expectation is that it
return 0 on success. This is repaired.

Reported-by: syzbot+d1e3b1d92d25abf97943@syzkaller.appspotmail.com
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Acked-by: James Morris <jamorris@linux.microsoft.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/security.c      | 17 +++++++++++++++--
 security/selinux/hooks.c |  5 ++---
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/security/security.c b/security/security.c
index c34ec4c7d98c..f633717311a3 100644
--- a/security/security.c
+++ b/security/security.c
@@ -802,9 +802,22 @@ int security_fs_context_dup(struct fs_context *fc, struct fs_context *src_fc)
 	return call_int_hook(fs_context_dup, 0, fc, src_fc);
 }
 
-int security_fs_context_parse_param(struct fs_context *fc, struct fs_parameter *param)
+int security_fs_context_parse_param(struct fs_context *fc,
+				    struct fs_parameter *param)
 {
-	return call_int_hook(fs_context_parse_param, -ENOPARAM, fc, param);
+	struct security_hook_list *hp;
+	int trc;
+	int rc = -ENOPARAM;
+
+	hlist_for_each_entry(hp, &security_hook_heads.fs_context_parse_param,
+			     list) {
+		trc = hp->hook.fs_context_parse_param(fc, param);
+		if (trc == 0)
+			rc = 0;
+		else if (trc != -ENOPARAM)
+			return trc;
+	}
+	return rc;
 }
 
 int security_sb_alloc(struct super_block *sb)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 56418cf72069..d9f15c84aab7 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2855,10 +2855,9 @@ static int selinux_fs_context_parse_param(struct fs_context *fc,
 		return opt;
 
 	rc = selinux_add_opt(opt, param->string, &fc->security);
-	if (!rc) {
+	if (!rc)
 		param->string = NULL;
-		rc = 1;
-	}
+
 	return rc;
 }
 
-- 
2.34.1

