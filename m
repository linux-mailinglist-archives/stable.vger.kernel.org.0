Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BB756CF3C
	for <lists+stable@lfdr.de>; Sun, 10 Jul 2022 15:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiGJNLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jul 2022 09:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGJNLc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jul 2022 09:11:32 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F9010FC8
        for <stable@vger.kernel.org>; Sun, 10 Jul 2022 06:11:28 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id e15so3467239edj.2
        for <stable@vger.kernel.org>; Sun, 10 Jul 2022 06:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v8A42bFnP8PDJ6oqLgxb+pydr5GSE8P6Tlv7SdCq3Ao=;
        b=Pibho/tyv+nOI9f8RbeOsEGYUct8P7o9xV4yLi92YUuH+MTksafgiK/UFsHYIhrlmt
         A1ivRPI62fJ9G33t4zyWwZRBnYBrKTMg1tbt1ymYR5hwT9/bJxse8HlEn5RTW9BOvb6Q
         nmY+lC5cTxJz3PPi60o1Cfy662h0agF5qxtnptxr0O+OhjTrhE2dbRzSJOMnuoIc1hce
         et7VW0IcfK+yzytSgIJ6W/CEMXke0BL2MpEwd42k/7bRcwajqAHj/xhQrde9q7DXCwzv
         6l/Q2sjIErBi9ulExFuM0waUEq1HLpEylC20VX+OJnk5PIdwQXCoadyFRSBa3PzT+SiH
         BE7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v8A42bFnP8PDJ6oqLgxb+pydr5GSE8P6Tlv7SdCq3Ao=;
        b=nRY6US4XYKN8zAkHkC3dAQjIffTwA0a3/imh/1M2ZKBy31qHqBTmDQrbcfvbAawUkh
         ivUd1oRO4Wl66NmtKBTXBhgHpol+lcJ5btDHSZXeRh1YZmF+LyU7H9JTWVpxXlDSHvXP
         lZC00M0aCz9UjR1BntjwSkZeJmuXWR1UChfThBBG9ashXtgHhkAWjuFZPxwgjsG11Bhd
         pbaW8YyuBoQJcT5PPpyd+Ce8zbof4zu1ifBzudSuMTAyvv6nrNhKA3naaNr3gwxtUs3n
         +agioYmqOAjGwE8xxFX2kuXV3Ym6FSqV3gqsNYkEVwFbUwKhKD9bD/VsZVRiW/Wx1s75
         Uy+w==
X-Gm-Message-State: AJIora/8ENaT6NkxbGkfPWj+dtPmdjfq9MV89fDe2tqrZEm0icUjHH9M
        2KeeiiLBL1VgaB1nAR5yl9aZA70PEMwrAQ==
X-Google-Smtp-Source: AGRyM1tH6VQlSpcRCj+iyZZZl3cP56WAtoh4SzUETOFXxVbmlxEQi7qoh9ApYlvhj/ljnanD3L6q/w==
X-Received: by 2002:a05:6402:194d:b0:43a:82da:b0f3 with SMTP id f13-20020a056402194d00b0043a82dab0f3mr18477535edz.104.1657458686282;
        Sun, 10 Jul 2022 06:11:26 -0700 (PDT)
Received: from alex-Mint.fritz.box (p200300f6af42a000bd655b56da6a0a3d.dip0.t-ipconnect.de. [2003:f6:af42:a000:bd65:5b56:da6a:a3d])
        by smtp.googlemail.com with ESMTPSA id i19-20020a170906115300b007262b9f7120sm1565763eja.167.2022.07.10.06.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jul 2022 06:11:25 -0700 (PDT)
From:   theflamefire89@gmail.com
To:     stable@vger.kernel.org
Cc:     James Morris <jmorris@namei.org>
Subject: [PATCH 2/2] security: mark LSM hooks as __ro_after_init
Date:   Sun, 10 Jul 2022 15:10:55 +0200
Message-Id: <20220710131055.12934-2-theflamefire89@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220710131055.12934-1-theflamefire89@gmail.com>
References: <20220710131055.12934-1-theflamefire89@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morris <jmorris@namei.org>

commit ca97d939db114c8d1619e10a3b82af8615372dae upstream.

Mark all of the registration hooks as __ro_after_init (via the
__lsm_ro_after_init macro).

Signed-off-by: James Morris <james.l.morris@oracle.com>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Alexander Grund <git@grundis.de>
---
 security/apparmor/lsm.c    | 2 +-
 security/commoncap.c       | 2 +-
 security/security.c        | 2 +-
 security/selinux/hooks.c   | 2 +-
 security/smack/smack_lsm.c | 2 +-
 security/tomoyo/tomoyo.c   | 2 +-
 security/yama/yama_lsm.c   | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 02cc952b86aa..7b527c44857c 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -584,7 +584,7 @@ static int apparmor_task_setrlimit(struct task_struct *task,
 	return error;
 }
 
-static struct security_hook_list apparmor_hooks[] = {
+static struct security_hook_list apparmor_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(ptrace_access_check, apparmor_ptrace_access_check),
 	LSM_HOOK_INIT(ptrace_traceme, apparmor_ptrace_traceme),
 	LSM_HOOK_INIT(capget, apparmor_capget),
diff --git a/security/commoncap.c b/security/commoncap.c
index b86aca8d6798..0708c7f4df5f 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -1071,7 +1071,7 @@ int cap_mmap_file(struct file *file, unsigned long reqprot,
 
 #ifdef CONFIG_SECURITY
 
-struct security_hook_list capability_hooks[] = {
+struct security_hook_list capability_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(capable, cap_capable),
 	LSM_HOOK_INIT(settime, cap_settime),
 	LSM_HOOK_INIT(ptrace_access_check, cap_ptrace_access_check),
diff --git a/security/security.c b/security/security.c
index 9a13d72a6446..b53c802c384b 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1596,7 +1596,7 @@ int security_audit_rule_match(u32 secid, u32 field, u32 op, void *lsmrule,
 }
 #endif /* CONFIG_AUDIT */
 
-struct security_hook_heads security_hook_heads = {
+struct security_hook_heads security_hook_heads __lsm_ro_after_init = {
 	.binder_set_context_mgr =
 		LIST_HEAD_INIT(security_hook_heads.binder_set_context_mgr),
 	.binder_transaction =
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index b456c8630608..f60dfac48a99 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6118,7 +6118,7 @@ static int selinux_key_getsecurity(struct key *key, char **_buffer)
 
 #endif
 
-static struct security_hook_list selinux_hooks[] = {
+static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(binder_set_context_mgr, selinux_binder_set_context_mgr),
 	LSM_HOOK_INIT(binder_transaction, selinux_binder_transaction),
 	LSM_HOOK_INIT(binder_transfer_binder, selinux_binder_transfer_binder),
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 84ed47195cdd..7926a374a567 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -4620,7 +4620,7 @@ static int smack_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
 	return 0;
 }
 
-static struct security_hook_list smack_hooks[] = {
+static struct security_hook_list smack_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(ptrace_access_check, smack_ptrace_access_check),
 	LSM_HOOK_INIT(ptrace_traceme, smack_ptrace_traceme),
 	LSM_HOOK_INIT(syslog, smack_syslog),
diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
index 75c998700190..f1dce33d9542 100644
--- a/security/tomoyo/tomoyo.c
+++ b/security/tomoyo/tomoyo.c
@@ -496,7 +496,7 @@ static int tomoyo_socket_sendmsg(struct socket *sock, struct msghdr *msg,
  * tomoyo_security_ops is a "struct security_operations" which is used for
  * registering TOMOYO.
  */
-static struct security_hook_list tomoyo_hooks[] = {
+static struct security_hook_list tomoyo_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(cred_alloc_blank, tomoyo_cred_alloc_blank),
 	LSM_HOOK_INIT(cred_prepare, tomoyo_cred_prepare),
 	LSM_HOOK_INIT(cred_transfer, tomoyo_cred_transfer),
diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index 5367f854fadc..be7e40c7e552 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -416,7 +416,7 @@ int yama_ptrace_traceme(struct task_struct *parent)
 	return rc;
 }
 
-static struct security_hook_list yama_hooks[] = {
+static struct security_hook_list yama_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(ptrace_access_check, yama_ptrace_access_check),
 	LSM_HOOK_INIT(ptrace_traceme, yama_ptrace_traceme),
 	LSM_HOOK_INIT(task_prctl, yama_task_prctl),
-- 
2.25.1

