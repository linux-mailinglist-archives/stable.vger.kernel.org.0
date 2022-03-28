Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334244E938A
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240783AbiC1LY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241163AbiC1LXU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:23:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A195A55BF2;
        Mon, 28 Mar 2022 04:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DA0AB80E01;
        Mon, 28 Mar 2022 11:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87243C340EC;
        Mon, 28 Mar 2022 11:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466414;
        bh=0W2ORTtK48q70ycAulC0xB7KmNVK84oomaBhMqHvMFU=;
        h=From:To:Cc:Subject:Date:From;
        b=I/q3GHjOxXbkvIggu4Lfq+v8UtwJmnIx7QS0yXTA/y3uzVYQiiPyEZOvmDla8reqU
         A36XD7pmd1zLqrbe7PnsoTKrF8RustUPepAnikxIbKtGtca97Zstp+xYrFqq6caWcY
         SGfMpqLZGx/xW6Sy/yzl4VuIFZ6fqqCsjUU9SpAHQXBdOrnpWgto09ZnRMifjkJn9r
         x35QWOv/xdHCBXK5bhbpztWhASIp2/tSHBSMk3N0grxorAlGZte85WI/+22wyWHI2Y
         KyKP9Xsz/PXcXvogoIVmjRsKhqMXh+54dHcmoB+E+i6Up2AkP3rYSZxPcbgBLo3rL/
         EnlNhmIbqMq4g==
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
Subject: [PATCH AUTOSEL 5.16 01/35] LSM: general protection fault in legacy_parse_param
Date:   Mon, 28 Mar 2022 07:19:37 -0400
Message-Id: <20220328112011.1555169-1-sashal@kernel.org>
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
index 64abdfb20bc2..8a1b26be08dd 100644
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
index 49b4f59db35e..d582479dfd62 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2909,10 +2909,9 @@ static int selinux_fs_context_parse_param(struct fs_context *fc,
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

