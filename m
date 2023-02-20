Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68BD69CA6D
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 13:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbjBTMBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 07:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjBTMBp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 07:01:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC43618AA6;
        Mon, 20 Feb 2023 04:01:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57B3AB80CC1;
        Mon, 20 Feb 2023 12:01:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D958C4339C;
        Mon, 20 Feb 2023 12:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676894501;
        bh=HwyHQ7NQBcqaXNyFW9VwpWmiK2D8pynDQ1Zmxgolbyo=;
        h=From:To:Cc:Subject:Date:From;
        b=Or96XlR1Zu/02ftjvTDBtcGGvKIzBAgt0S4oSUoEhqB40Q0aVGzJHcRo+5wUKXhPy
         ooXr2McEBkoCq42D41ivZnS2k66fw+vPOXbK8VoUPKkP9mknWq1vq/kD45VkHD2hys
         VRfNmnSTrXSZzfTZrO64VKScLKmkP2nuWOFP4TptZhd2aqsdkePCrqt8TUlbBtKFqq
         /NtxDa10TMasLzlj4oJZq7N1NQHHvvemPZ7/P7jNfFcMaHJF6YAD6Fn7c2U6n2htjF
         mXF3zH4qlzo7apKpY25EGU56sH9wojFxh04BWmR+nTpTBKURjwy87y7WsYrrB+Fr5y
         4jEdvzrZFS3eA==
From:   KP Singh <kpsingh@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     pjt@google.com, evn@google.com, jpoimboe@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        peterz@infradead.org, pawan.kumar.gupta@linux.intel.com,
        kim.phillips@amd.com, alexandre.chartre@oracle.com,
        daniel.sneddon@linux.intel.com,
        =?UTF-8?q?Jos=C3=A9=20Oliveira?= <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>,
        Jim Mattson <jmattson@google.com>, stable@vger.kernel.org,
        KP Singh <kpsingh@kernel.org>
Subject: [PATCH RESEND] x86/speculation: Fix user-mode spectre-v2 protection with KERNEL_IBRS
Date:   Mon, 20 Feb 2023 13:01:27 +0100
Message-Id: <20230220120127.1975241-1-kpsingh@kernel.org>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With the introduction of KERNEL_IBRS, STIBP is no longer needed
to prevent cross thread training in the kernel space. When KERNEL_IBRS
was added, it also disabled the user-mode protections for spectre_v2.
KERNEL_IBRS does not mitigate cross thread training in the userspace.

In order to demonstrate the issue, one needs to avoid syscalls in the
victim as syscalls can shorten the window size due to
a user -> kernel -> user transition which sets the
IBRS bit when entering kernel space and clearing any training the
attacker may have done.

Allow users to select a spectre_v2_user mitigation (STIBP always on,
opt-in via prctl) when KERNEL_IBRS is enabled.

Reported-by: José Oliveira <joseloliveira11@gmail.com>
Reported-by: Rodrigo Branco <rodrigo@kernelhacking.com>
Reviewed-by: Alexandra Sandulescu <aesa@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS")
Cc: stable@vger.kernel.org
Signed-off-by: KP Singh <kpsingh@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index bca0bd8f4846..b05ca1575d81 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1132,6 +1132,19 @@ static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mode)
 	       mode == SPECTRE_V2_EIBRS_LFENCE;
 }
 
+static inline bool spectre_v2_user_no_stibp(enum spectre_v2_mitigation mode)
+{
+	/* When IBRS or enhanced IBRS is enabled, STIBP is not needed.
+	 *
+	 * However, With KERNEL_IBRS, the IBRS bit is cleared on return
+	 * to user and the user-mode code needs to be able to enable protection
+	 * from cross-thread training, either by always enabling STIBP or
+	 * by enabling it via prctl.
+	 */
+	return (spectre_v2_in_ibrs_mode(mode) &&
+		!cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS));
+}
+
 static void __init
 spectre_v2_user_select_mitigation(void)
 {
@@ -1193,13 +1206,8 @@ spectre_v2_user_select_mitigation(void)
 			"always-on" : "conditional");
 	}
 
-	/*
-	 * If no STIBP, IBRS or enhanced IBRS is enabled, or SMT impossible,
-	 * STIBP is not required.
-	 */
-	if (!boot_cpu_has(X86_FEATURE_STIBP) ||
-	    !smt_possible ||
-	    spectre_v2_in_ibrs_mode(spectre_v2_enabled))
+	if (!boot_cpu_has(X86_FEATURE_STIBP) || !smt_possible ||
+	    spectre_v2_user_no_stibp(spectre_v2_enabled))
 		return;
 
 	/*
@@ -1496,6 +1504,7 @@ static void __init spectre_v2_select_mitigation(void)
 		break;
 
 	case SPECTRE_V2_IBRS:
+		pr_err("enabling KERNEL_IBRS");
 		setup_force_cpu_cap(X86_FEATURE_KERNEL_IBRS);
 		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED))
 			pr_warn(SPECTRE_V2_IBRS_PERF_MSG);
@@ -2327,7 +2336,7 @@ static ssize_t mmio_stale_data_show_state(char *buf)
 
 static char *stibp_state(void)
 {
-	if (spectre_v2_in_ibrs_mode(spectre_v2_enabled))
+	if (spectre_v2_user_no_stibp(spectre_v2_enabled))
 		return "";
 
 	switch (spectre_v2_user_stibp) {
-- 
2.39.2.637.g21b0678d19-goog

