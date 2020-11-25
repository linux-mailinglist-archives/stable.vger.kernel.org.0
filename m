Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EB62C4825
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 20:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbgKYTYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 14:24:20 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51854 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgKYTYT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 14:24:19 -0500
Date:   Wed, 25 Nov 2020 19:24:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606332256;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iKKiuUxwD/+n02zCddiNL92k5p2H5uFP3za0swJggAk=;
        b=zV6qq2xGOpkb8AiesUyL4fpVrY5INVds8byVfcc2fxdld6bn5nQ60OgS7htFAHW7piSfpG
        y4kNJnWTAFY75d9ZEMd47nVtv08j/cg0v0Fol7gPiWAJs3IBNiLWZIsuMaya6D9Xpnhqt1
        tjNgnrETRyuN514r9qbmF3U5xTuGqTNTAl3ydiNZEUXw88x1eqza3kLFsZ95xd4V60AJSV
        0HMI2VuYInE6WT5N33Nn1CT82Img7T6iMcFAxTWMOG3ir+0dVC2IWp5zqWp818hnwRYxnu
        shQknpS8fE4QswXtnmc/8JULKzSkaOFQaBTTq1TgL0oeyIIpvJcM+QSP8INhjQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606332256;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iKKiuUxwD/+n02zCddiNL92k5p2H5uFP3za0swJggAk=;
        b=GyRv0ancUfN9MbXGiQV8zvduYddFx/2zeKSOXUVOUkkOo69NsLDtOi0hDAybWvaxhPfgEe
        DM6nTeez3o/TYbDQ==
From:   "tip-bot2 for Anand K Mistry" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/speculation: Fix prctl() when
 spectre_v2_user={seccomp,prctl},ibpb
Cc:     Anand K Mistry <amistry@google.com>, Borislav Petkov <bp@suse.de>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20201110123349.1.Id0cbf996d2151f4c143c90f9028651a5b49a5908@changeid>
References: <20201110123349.1.Id0cbf996d2151f4c143c90f9028651a5b49a5908@changeid>
MIME-Version: 1.0
Message-ID: <160633225579.3364.12052138578908275403.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     33fc379df76b4991e5ae312f07bcd6820811971e
Gitweb:        https://git.kernel.org/tip/33fc379df76b4991e5ae312f07bcd6820811971e
Author:        Anand K Mistry <amistry@google.com>
AuthorDate:    Tue, 10 Nov 2020 12:33:53 +11:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 25 Nov 2020 20:17:09 +01:00

x86/speculation: Fix prctl() when spectre_v2_user={seccomp,prctl},ibpb

When spectre_v2_user={seccomp,prctl},ibpb is specified on the command
line, IBPB is force-enabled and STIPB is conditionally-enabled (or not
available).

However, since

  21998a351512 ("x86/speculation: Avoid force-disabling IBPB based on STIBP and enhanced IBRS.")

the spectre_v2_user_ibpb variable is set to SPECTRE_V2_USER_{PRCTL,SECCOMP}
instead of SPECTRE_V2_USER_STRICT, which is the actual behaviour.
Because the issuing of IBPB relies on the switch_mm_*_ibpb static
branches, the mitigations behave as expected.

Since

  1978b3a53a74 ("x86/speculation: Allow IBPB to be conditionally enabled on CPUs with always-on STIBP")

this discrepency caused the misreporting of IB speculation via prctl().

On CPUs with STIBP always-on and spectre_v2_user=seccomp,ibpb,
prctl(PR_GET_SPECULATION_CTRL) would return PR_SPEC_PRCTL |
PR_SPEC_ENABLE instead of PR_SPEC_DISABLE since both IBPB and STIPB are
always on. It also allowed prctl(PR_SET_SPECULATION_CTRL) to set the IB
speculation mode, even though the flag is ignored.

Similarly, for CPUs without SMT, prctl(PR_GET_SPECULATION_CTRL) should
also return PR_SPEC_DISABLE since IBPB is always on and STIBP is not
available.

 [ bp: Massage commit message. ]

Fixes: 21998a351512 ("x86/speculation: Avoid force-disabling IBPB based on STIBP and enhanced IBRS.")
Fixes: 1978b3a53a74 ("x86/speculation: Allow IBPB to be conditionally enabled on CPUs with always-on STIBP")
Signed-off-by: Anand K Mistry <amistry@google.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20201110123349.1.Id0cbf996d2151f4c143c90f9028651a5b49a5908@changeid
---
 arch/x86/kernel/cpu/bugs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 581fb72..d41b70f 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -739,11 +739,13 @@ spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
 	if (boot_cpu_has(X86_FEATURE_IBPB)) {
 		setup_force_cpu_cap(X86_FEATURE_USE_IBPB);
 
+		spectre_v2_user_ibpb = mode;
 		switch (cmd) {
 		case SPECTRE_V2_USER_CMD_FORCE:
 		case SPECTRE_V2_USER_CMD_PRCTL_IBPB:
 		case SPECTRE_V2_USER_CMD_SECCOMP_IBPB:
 			static_branch_enable(&switch_mm_always_ibpb);
+			spectre_v2_user_ibpb = SPECTRE_V2_USER_STRICT;
 			break;
 		case SPECTRE_V2_USER_CMD_PRCTL:
 		case SPECTRE_V2_USER_CMD_AUTO:
@@ -757,8 +759,6 @@ spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
 		pr_info("mitigation: Enabling %s Indirect Branch Prediction Barrier\n",
 			static_key_enabled(&switch_mm_always_ibpb) ?
 			"always-on" : "conditional");
-
-		spectre_v2_user_ibpb = mode;
 	}
 
 	/*
