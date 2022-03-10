Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D55B4D49CC
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243424AbiCJOVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:21:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243846AbiCJOS0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:18:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8E415678B;
        Thu, 10 Mar 2022 06:14:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32F2EB8254A;
        Thu, 10 Mar 2022 14:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF86C340E8;
        Thu, 10 Mar 2022 14:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646921667;
        bh=qJAPxXZ2TadZ/iowuZN6KPA8DnNseQ8gqYjoNpsfbrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0uPdECukME8PYKeYHrkFTlWo7wKeKscDydMClB5DriqZsSkZzvLbU8KXqQAISx8Cd
         VKgrf/0CoIA23gSPm7vC2zQTx1IAKBH0bBZ8bbrPNEsVec2xvc4lqGjdrS5z1ppEst
         K7WzcVKcOkggHs4XF0ULmQ/UdIakNs2StZP1G7+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 16/38] x86/speculation: Warn about eIBRS + LFENCE + Unprivileged eBPF + SMT
Date:   Thu, 10 Mar 2022 15:13:29 +0100
Message-Id: <20220310140808.611131688@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140808.136149678@linuxfoundation.org>
References: <20220310140808.136149678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit 0de05d056afdb00eca8c7bbb0c79a3438daf700c upstream.

The commit

   44a3918c8245 ("x86/speculation: Include unprivileged eBPF status in Spectre v2 mitigation reporting")

added a warning for the "eIBRS + unprivileged eBPF" combination, which
has been shown to be vulnerable against Spectre v2 BHB-based attacks.

However, there's no warning about the "eIBRS + LFENCE retpoline +
unprivileged eBPF" combo. The LFENCE adds more protection by shortening
the speculation window after a mispredicted branch. That makes an attack
significantly more difficult, even with unprivileged eBPF. So at least
for now the logic doesn't warn about that combination.

But if you then add SMT into the mix, the SMT attack angle weakens the
effectiveness of the LFENCE considerably.

So extend the "eIBRS + unprivileged eBPF" warning to also include the
"eIBRS + LFENCE + unprivileged eBPF + SMT" case.

  [ bp: Massage commit message. ]

Suggested-by: Alyssa Milburn <alyssa.milburn@linux.intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -609,12 +609,27 @@ static inline const char *spectre_v2_mod
 
 #define SPECTRE_V2_LFENCE_MSG "WARNING: LFENCE mitigation is not recommended for this CPU, data leaks possible!\n"
 #define SPECTRE_V2_EIBRS_EBPF_MSG "WARNING: Unprivileged eBPF is enabled with eIBRS on, data leaks possible via Spectre v2 BHB attacks!\n"
+#define SPECTRE_V2_EIBRS_LFENCE_EBPF_SMT_MSG "WARNING: Unprivileged eBPF is enabled with eIBRS+LFENCE mitigation and SMT, data leaks possible via Spectre v2 BHB attacks!\n"
 
 #ifdef CONFIG_BPF_SYSCALL
 void unpriv_ebpf_notify(int new_state)
 {
-	if (spectre_v2_enabled == SPECTRE_V2_EIBRS && !new_state)
+	if (new_state)
+		return;
+
+	/* Unprivileged eBPF is enabled */
+
+	switch (spectre_v2_enabled) {
+	case SPECTRE_V2_EIBRS:
 		pr_err(SPECTRE_V2_EIBRS_EBPF_MSG);
+		break;
+	case SPECTRE_V2_EIBRS_LFENCE:
+		if (sched_smt_active())
+			pr_err(SPECTRE_V2_EIBRS_LFENCE_EBPF_SMT_MSG);
+		break;
+	default:
+		break;
+	}
 }
 #endif
 
@@ -1074,6 +1089,10 @@ void arch_smt_update(void)
 {
 	mutex_lock(&spec_ctrl_mutex);
 
+	if (sched_smt_active() && unprivileged_ebpf_enabled() &&
+	    spectre_v2_enabled == SPECTRE_V2_EIBRS_LFENCE)
+		pr_warn_once(SPECTRE_V2_EIBRS_LFENCE_EBPF_SMT_MSG);
+
 	switch (spectre_v2_user_stibp) {
 	case SPECTRE_V2_USER_NONE:
 		break;
@@ -1700,7 +1719,11 @@ static ssize_t spectre_v2_show_state(cha
 		return sprintf(buf, "Vulnerable: LFENCE\n");
 
 	if (spectre_v2_enabled == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
-		return sprintf(buf, "Vulnerable: Unprivileged eBPF enabled\n");
+		return sprintf(buf, "Vulnerable: eIBRS with unprivileged eBPF\n");
+
+	if (sched_smt_active() && unprivileged_ebpf_enabled() &&
+	    spectre_v2_enabled == SPECTRE_V2_EIBRS_LFENCE)
+		return sprintf(buf, "Vulnerable: eIBRS+LFENCE with unprivileged eBPF and SMT\n");
 
 	return sprintf(buf, "%s%s%s%s%s%s\n",
 		       spectre_v2_strings[spectre_v2_enabled],


