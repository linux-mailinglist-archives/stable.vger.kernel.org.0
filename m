Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476072C9DCF
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388788AbgLAJ1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:27:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:39486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729298AbgLAJCe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:02:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1D9E20770;
        Tue,  1 Dec 2020 09:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813313;
        bh=Fqd08q6ULXgk8oeFymIU9Q5qSM6g/VApXQdxsacXWFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PBQSR5D20OKCMBmYyJGTrJ7RgMWJjwUltAkXmKygt5K6+HO1QObVtxcKcWwpenodF
         PU+VFIuVeQ9paqO98MgTNGLHbvhyRztA/KZHF9s8SUk0Dm1atFoRpKReGMNboC2+hR
         jwSJgt649armY5eo2bYJno+kIHBZSLDMCuErRKlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand K Mistry <amistry@google.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 4.19 54/57] x86/speculation: Fix prctl() when spectre_v2_user={seccomp,prctl},ibpb
Date:   Tue,  1 Dec 2020 09:53:59 +0100
Message-Id: <20201201084651.760469216@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084647.751612010@linuxfoundation.org>
References: <20201201084647.751612010@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand K Mistry <amistry@google.com>

commit 33fc379df76b4991e5ae312f07bcd6820811971e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/bugs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -733,11 +733,13 @@ spectre_v2_user_select_mitigation(enum s
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
@@ -751,8 +753,6 @@ spectre_v2_user_select_mitigation(enum s
 		pr_info("mitigation: Enabling %s Indirect Branch Prediction Barrier\n",
 			static_key_enabled(&switch_mm_always_ibpb) ?
 			"always-on" : "conditional");
-
-		spectre_v2_user_ibpb = mode;
 	}
 
 	/*


