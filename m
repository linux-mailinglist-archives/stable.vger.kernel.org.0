Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54FDA424B55
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 02:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240136AbhJGAsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 20:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240127AbhJGAsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 20:48:31 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58176C061764
        for <stable@vger.kernel.org>; Wed,  6 Oct 2021 17:46:38 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id 90-20020aed3163000000b002a6bd958077so3787219qtg.6
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 17:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CH/DW8RotmHfFuCbYoHpP62hkgIiMJ06u9s6VjSYC3s=;
        b=LYTioxtci52jcphCHe8u1eoYv8kmpvwPXGYh1Uwm8AyktnJEWy1v3mFruvAYtAjn/Q
         EDHeLfY1iPVnDnivL3Upw6ev+O6/tMPhIBx5fWWGXLpSbTLnd75JRyfeyM9HfKVDrM8S
         iiYfpH+8BwtyYgPllJRfaYYSFUHw0cdfdS4H2S6iR1BXaG03UGQ0VEX9hxzii5TNIvqt
         vCbzEgSmb227NEoG+nhMpQhyQX+QrfSPWZu/C4QNW/7v4Ww43bKzkNCkwv+6uAWwZYRi
         gtswe0KxRCcpP5JmR0encJ5FMEyMWyhl0HJDjzzG7/4/9Klnx3hJL7wNarFLuE9Ma9xl
         U0Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CH/DW8RotmHfFuCbYoHpP62hkgIiMJ06u9s6VjSYC3s=;
        b=md6PuaZhCnEhMq8u+UwunHlWB8B7UQxzgB2ENYM5WwC/DfISSKx/LbAFsMR/ToF6dY
         slxB4tk+P6xvassEUqUfQhKBeLhEYjGrokyyVxoVbn+9zrM2+Lr3CEFogi8nFmZfd8LT
         KnWQo/6QNO647wLbivYulKwmdYm+2obYcA4LFQy+sRantXs1q04L1ysQRpaIC7zOK60l
         VDDeJ32+8hgfGW/02WXExrHtAonUaoD+JbJebhLjjE0Nf2S7UKn4SKkihWLfFkChHR55
         IvuznyVs43AQBPBBFQJuluYHTuu1btlAN724yOs22u5UmQTvOWQ7nI4bbl1LvJDqmQqH
         fYjA==
X-Gm-Message-State: AOAM531jShKJtmFsKPBRdglhx66vX1Q5mjsKmKMUQe8mZkhM+aAscJ9L
        3HDitupZ6r/+k0ef5p6s98ELwdtoxw==
X-Google-Smtp-Source: ABdhPJwMqLn/cAh17Y37uR0h1Q2rnNT1/CHPF8cLO2zOiQpjODuYunYRg5mcCdS5tsK+bwE+XPkH/q8wag==
X-Received: from ava-linux2.mtv.corp.google.com ([2620:15c:211:200:6ff2:347f:ac4a:8a04])
 (user=tkjos job=sendgmr) by 2002:ac8:615c:: with SMTP id d28mr1528098qtm.103.1633567597415;
 Wed, 06 Oct 2021 17:46:37 -0700 (PDT)
Date:   Wed,  6 Oct 2021 17:46:28 -0700
In-Reply-To: <20211007004629.1113572-1-tkjos@google.com>
Message-Id: <20211007004629.1113572-3-tkjos@google.com>
Mime-Version: 1.0
References: <20211007004629.1113572-1-tkjos@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v4 2/3] binder: use cred instead of task for getsecid
From:   Todd Kjos <tkjos@google.com>
To:     gregkh@linuxfoundation.org, arve@android.com, tkjos@android.com,
        maco@android.com, christian@brauner.io, jmorris@namei.org,
        serge@hallyn.com, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        keescook@chromium.org, jannh@google.com, jeffv@google.com,
        zohar@linux.ibm.com, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc:     joel@joelfernandes.org, kernel-team@android.com,
        Todd Kjos <tkjos@google.com>,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use the 'struct cred' saved at binder_open() to lookup
the security ID via security_cred_getsecid(). This
ensures that the security context that opened binder
is the one used to generate the secctx.

Fixes: ec74136ded79 ("binder: create node flag to request sender's
security context")
Signed-off-by: Todd Kjos <tkjos@google.com>
Suggested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: stable@vger.kernel.org # 5.4+
---
v3: added this patch to series
v4: fix build-break for !CONFIG_SECURITY

 drivers/android/binder.c | 11 +----------
 include/linux/security.h |  4 ++++
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index ca599ebdea4a..989afd0804ca 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2722,16 +2722,7 @@ static void binder_transaction(struct binder_proc *proc,
 		u32 secid;
 		size_t added_size;
 
-		/*
-		 * Arguably this should be the task's subjective LSM secid but
-		 * we can't reliably access the subjective creds of a task
-		 * other than our own so we must use the objective creds, which
-		 * are safe to access.  The downside is that if a task is
-		 * temporarily overriding it's creds it will not be reflected
-		 * here; however, it isn't clear that binder would handle that
-		 * case well anyway.
-		 */
-		security_task_getsecid_obj(proc->tsk, &secid);
+		security_cred_getsecid(proc->cred, &secid);
 		ret = security_secid_to_secctx(secid, &secctx, &secctx_sz);
 		if (ret) {
 			return_error = BR_FAILED_REPLY;
diff --git a/include/linux/security.h b/include/linux/security.h
index 6344d3362df7..f02cc0211b10 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1041,6 +1041,10 @@ static inline void security_transfer_creds(struct cred *new,
 {
 }
 
+static inline void security_cred_getsecid(const struct cred *c, u32 *secid)
+{
+}
+
 static inline int security_kernel_act_as(struct cred *cred, u32 secid)
 {
 	return 0;
-- 
2.33.0.800.g4c38ced690-goog

