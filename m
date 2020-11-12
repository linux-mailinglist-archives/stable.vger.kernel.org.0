Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52FCD2AFCB7
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 02:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgKLBdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 20:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728036AbgKLAQL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 19:16:11 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A14BC0613D1
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 16:16:11 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id g129so4031675ybf.20
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 16:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=6pmCKrMJEtPjaQQ2OwR8+BznrbO5d1qyd8VE0IMy9+A=;
        b=vo8YdjcWm+tQHPdIXgr+wlaI9e0IYYs8u42g9LK73TlNXtC5siqobumPv+U0wQ0u+z
         X57KFWNeTRomFqhCcCwMo5vJEm5v0lBEeTNwTDsEp9ZJzrZqBzArPpO19QBC158Q2tN6
         ZZcAV08GP6dbBnFmmk+GAOrxn+1pgWvYcXSmj3JjweZsUDs8zvLnHbNWpQkL6TMtbPt+
         wcorBj7yBQMwFv62L1yn3h5mglsLfxkX04JariQjV2YrVK5hHWznon3YD+AsrXTZBF4Z
         pyQOWQgzN8zwOcOAXIPmxx6xbuCk+Nj1WtiMvaFwbov4fJu6gi/HXZPvqS0tlqc6sOQc
         YxJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=6pmCKrMJEtPjaQQ2OwR8+BznrbO5d1qyd8VE0IMy9+A=;
        b=fdKZYHDLEHgXDiMp2LSFpIIUo0FbTrX9QhI3Z+thUumcAAnAR569xUAF6BR7EaZZke
         KDoPiJ6Gh9reSF4b8X2q7DlV53ZRYtemZtX3KDzj05urLVHlcap2QG2vFbFgkXFMH87M
         Q/nPpPr057zRITe9lAFxAEykhvOZLxTimnDRda9NTjGI5LBulXSikHRbHQuJ7e8wWugI
         C+RQ/KuD1lrrtJVbbHbzm3Vo8N1t03E2+UiWKMxi2quCMqeSd8KvzWDj45n8xJkUYXyc
         7DcUsDok+k8ZB2FmIAjk8upXFKy7E1t2+NSjM8VCmD1m0oSw9Ra4KSQ8kwzchDaq2Dyk
         hKxg==
X-Gm-Message-State: AOAM530eXWVv4dZbwerrd/eFoQf8rYXOK2HWFkcgGIPk7MtCERq3jUas
        pYnP4HqGCclT5AXoJFlMgAErvGOARkSWrM0v3Rb7ebPCSGyp3BAxSEBhyqTQ6iDikE/9TRN+2xF
        6k4fyPDP1UzlqTb3lCDzoWyUGd60WmqAkcGtOECr5q49YN0k3cU9S+8dSzkTdQhJN
X-Google-Smtp-Source: ABdhPJxP2PO7gSxLk7Lk4Ww6vuL3vBfXZaIBpnasLcU5fEu0nSm2Mro59DrKmsgm4Bykom0Xj/AZnFHpFIFc
Sender: "amistry via sendgmr" <amistry@nandos.syd.corp.google.com>
X-Received: from nandos.syd.corp.google.com ([2401:fa00:9:14:725a:fff:fe46:72ab])
 (user=amistry job=sendgmr) by 2002:a25:38d5:: with SMTP id
 f204mr33195039yba.88.1605140170155; Wed, 11 Nov 2020 16:16:10 -0800 (PST)
Date:   Thu, 12 Nov 2020 11:15:34 +1100
Message-Id: <20201112001535.2960453-1-amistry@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
Subject: [PATCH] x86/speculation: Allow IBPB to be conditionally enabled on
 CPUs with always-on STIBP
From:   Anand K Mistry <amistry@google.com>
To:     stable@vger.kernel.org
Cc:     Anand K Mistry <amistry@google.com>, Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 1978b3a53a74e3230cd46932b149c6e62e832e9a upstream.

On AMD CPUs which have the feature X86_FEATURE_AMD_STIBP_ALWAYS_ON,
STIBP is set to on and

  spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED

At the same time, IBPB can be set to conditional.

However, this leads to the case where it's impossible to turn on IBPB
for a process because in the PR_SPEC_DISABLE case in ib_prctl_set() the

  spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED

condition leads to a return before the task flag is set. Similarly,
ib_prctl_get() will return PR_SPEC_DISABLE even though IBPB is set to
conditional.

More generally, the following cases are possible:

1. STIBP = conditional && IBPB = on for spectre_v2_user=seccomp,ibpb
2. STIBP = on && IBPB = conditional for AMD CPUs with
   X86_FEATURE_AMD_STIBP_ALWAYS_ON

The first case functions correctly today, but only because
spectre_v2_user_ibpb isn't updated to reflect the IBPB mode.

At a high level, this change does one thing. If either STIBP or IBPB
is set to conditional, allow the prctl to change the task flag.
Also, reflect that capability when querying the state. This isn't
perfect since it doesn't take into account if only STIBP or IBPB is
unconditionally on. But it allows the conditional feature to work as
expected, without affecting the unconditional one.

 [ bp: Massage commit message and comment; space out statements for
   better readability. ]

Fixes: 21998a351512 ("x86/speculation: Avoid force-disabling IBPB based on STIBP and enhanced IBRS.")
Signed-off-by: Anand K Mistry <amistry@google.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lkml.kernel.org/r/20201105163246.v2.1.Ifd7243cd3e2c2206a893ad0a5b9a4f19549e22c6@changeid

Conflicts:
	arch/x86/kernel/cpu/bugs.c

Superfluous newline which was removed in upstream commit a5ce9f2bb665

---
The one conflict is a newline in a comment which was removed in upstream
commit a5ce9f2bb665, but was not merged into the stable trees.

This patch applies cleanly on the stable trees 5.4, 4.19, 4.14, 4.9, and
4.4, which are affected by this bug.

 arch/x86/kernel/cpu/bugs.c | 52 ++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index acbf3dbb8bf2..bdc1ed7ff669 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1252,6 +1252,14 @@ static int ssb_prctl_set(struct task_struct *task, unsigned long ctrl)
 	return 0;
 }
 
+static bool is_spec_ib_user_controlled(void)
+{
+	return spectre_v2_user_ibpb == SPECTRE_V2_USER_PRCTL ||
+		spectre_v2_user_ibpb == SPECTRE_V2_USER_SECCOMP ||
+		spectre_v2_user_stibp == SPECTRE_V2_USER_PRCTL ||
+		spectre_v2_user_stibp == SPECTRE_V2_USER_SECCOMP;
+}
+
 static int ib_prctl_set(struct task_struct *task, unsigned long ctrl)
 {
 	switch (ctrl) {
@@ -1259,17 +1267,26 @@ static int ib_prctl_set(struct task_struct *task, unsigned long ctrl)
 		if (spectre_v2_user_ibpb == SPECTRE_V2_USER_NONE &&
 		    spectre_v2_user_stibp == SPECTRE_V2_USER_NONE)
 			return 0;
-		/*
-		 * Indirect branch speculation is always disabled in strict
-		 * mode. It can neither be enabled if it was force-disabled
-		 * by a  previous prctl call.
 
+		/*
+		 * With strict mode for both IBPB and STIBP, the instruction
+		 * code paths avoid checking this task flag and instead,
+		 * unconditionally run the instruction. However, STIBP and IBPB
+		 * are independent and either can be set to conditionally
+		 * enabled regardless of the mode of the other.
+		 *
+		 * If either is set to conditional, allow the task flag to be
+		 * updated, unless it was force-disabled by a previous prctl
+		 * call. Currently, this is possible on an AMD CPU which has the
+		 * feature X86_FEATURE_AMD_STIBP_ALWAYS_ON. In this case, if the
+		 * kernel is booted with 'spectre_v2_user=seccomp', then
+		 * spectre_v2_user_ibpb == SPECTRE_V2_USER_SECCOMP and
+		 * spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED.
 		 */
-		if (spectre_v2_user_ibpb == SPECTRE_V2_USER_STRICT ||
-		    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT ||
-		    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED ||
+		if (!is_spec_ib_user_controlled() ||
 		    task_spec_ib_force_disable(task))
 			return -EPERM;
+
 		task_clear_spec_ib_disable(task);
 		task_update_spec_tif(task);
 		break;
@@ -1282,10 +1299,10 @@ static int ib_prctl_set(struct task_struct *task, unsigned long ctrl)
 		if (spectre_v2_user_ibpb == SPECTRE_V2_USER_NONE &&
 		    spectre_v2_user_stibp == SPECTRE_V2_USER_NONE)
 			return -EPERM;
-		if (spectre_v2_user_ibpb == SPECTRE_V2_USER_STRICT ||
-		    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT ||
-		    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED)
+
+		if (!is_spec_ib_user_controlled())
 			return 0;
+
 		task_set_spec_ib_disable(task);
 		if (ctrl == PR_SPEC_FORCE_DISABLE)
 			task_set_spec_ib_force_disable(task);
@@ -1350,20 +1367,17 @@ static int ib_prctl_get(struct task_struct *task)
 	if (spectre_v2_user_ibpb == SPECTRE_V2_USER_NONE &&
 	    spectre_v2_user_stibp == SPECTRE_V2_USER_NONE)
 		return PR_SPEC_ENABLE;
-	else if (spectre_v2_user_ibpb == SPECTRE_V2_USER_STRICT ||
-	    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT ||
-	    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED)
-		return PR_SPEC_DISABLE;
-	else if (spectre_v2_user_ibpb == SPECTRE_V2_USER_PRCTL ||
-	    spectre_v2_user_ibpb == SPECTRE_V2_USER_SECCOMP ||
-	    spectre_v2_user_stibp == SPECTRE_V2_USER_PRCTL ||
-	    spectre_v2_user_stibp == SPECTRE_V2_USER_SECCOMP) {
+	else if (is_spec_ib_user_controlled()) {
 		if (task_spec_ib_force_disable(task))
 			return PR_SPEC_PRCTL | PR_SPEC_FORCE_DISABLE;
 		if (task_spec_ib_disable(task))
 			return PR_SPEC_PRCTL | PR_SPEC_DISABLE;
 		return PR_SPEC_PRCTL | PR_SPEC_ENABLE;
-	} else
+	} else if (spectre_v2_user_ibpb == SPECTRE_V2_USER_STRICT ||
+	    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT ||
+	    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED)
+		return PR_SPEC_DISABLE;
+	else
 		return PR_SPEC_NOT_AFFECTED;
 }
 
-- 
2.29.2.222.g5d2a92d10f8-goog

