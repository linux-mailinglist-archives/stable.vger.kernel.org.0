Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C09664E943A
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240941AbiC1L0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241684AbiC1LYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:24:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DE455BC6;
        Mon, 28 Mar 2022 04:21:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55BC761126;
        Mon, 28 Mar 2022 11:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A216C340EC;
        Mon, 28 Mar 2022 11:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466495;
        bh=sZEnXnuUT62lvH/RkwXQFswK4qQRzNgKlBXG342at3g=;
        h=From:To:Cc:Subject:Date:From;
        b=PYqj15Zl8d7Q4a6zFuYE6TQUHyPugKlGfvSgWezffhuTwXnvaWFZDTnY949FM9NYb
         cVthpWMczw7ELgQTP00AAd5vgsm/XVT+vt9/yiJQ9KkA9ugnGezP/EIvNm+EPBEqyI
         VwRLuzx4s58iDh6+JsCMEWbFhUfqmO0EBrYtt00JLYTtrmIulD8+nNd1U7wdwOWJHX
         ERC0zGszsDcDxKp5Cdosupq8QWbbwD7ZWB74RkMaVL8lmOxmB52ESeiBVt00e29rzI
         oKnzQCP0I4OsEtpRzpBuTCPsjw6FXS3XoQx7Wo1BNWWYajV1lep8pqmC9mET0W28jQ
         UDtq9cDBXKmMQ==
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
Subject: [PATCH AUTOSEL 5.15 01/29] LSM: general protection fault in legacy_parse_param
Date:   Mon, 28 Mar 2022 07:21:03 -0400
Message-Id: <20220328112132.1555683-1-sashal@kernel.org>
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
index 67264cb08fb3..da631339e969 100644
--- a/security/security.c
+++ b/security/security.c
@@ -884,9 +884,22 @@ int security_fs_context_dup(struct fs_context *fc, struct fs_context *src_fc)
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
index baa12d1007c7..cb938890f40b 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2908,10 +2908,9 @@ static int selinux_fs_context_parse_param(struct fs_context *fc,
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

