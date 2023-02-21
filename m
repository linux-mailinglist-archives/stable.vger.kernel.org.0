Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A6769E7DD
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 19:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjBUStZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 13:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjBUStY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 13:49:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4557629E34;
        Tue, 21 Feb 2023 10:49:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9693B81098;
        Tue, 21 Feb 2023 18:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9355FC433EF;
        Tue, 21 Feb 2023 18:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677005360;
        bh=L82aBSe/Z4BrUN9rIqknCi+Y2l3Bh6nIrbf77fJYo5o=;
        h=From:To:Cc:Subject:Date:From;
        b=fwLUgot0ePaiegmkRWsuc1IuMo5D8YJt99abSN2mdDeGb+g+WhQSQP1oqh6UQP8k/
         Fe4mMtXhHFEPvE2m3CJvS43gn9IlCu2YVxJQi6FzVm2UVzvKbSPOBol7KgJdkxEDqR
         Ijk2qigX+AYHz5QqD3Pz++4mBJoeNtrSgE/sDWZIMBRznbNIFlvAJLCcMMtjV91GpP
         C1g9qot37KqmnIdsm0Spg46X6r3pOWFj2/bbUE6axTi0G59VnSt2Kq1JrZrIStZSMG
         tqLJdq3iAj5ijjJIY2TtukILuzyIzd0FyxMPjv0Cpiw8pyb+WKlaDaR1GiAF82XmPp
         gOCbuTWTyw6Fw==
From:   KP Singh <kpsingh@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     pjt@google.com, evn@google.com, jpoimboe@kernel.org,
        tglx@linutronix.de, x86@kernel.org, hpa@zytor.com,
        peterz@infradead.org, pawan.kumar.gupta@linux.intel.com,
        kim.phillips@amd.com, alexandre.chartre@oracle.com,
        daniel.sneddon@linux.intel.com, corbet@lwn.net, bp@suse.de,
        linyujun809@huawei.com, kpsingh@kernel.org, jmattson@google.com,
        =?UTF-8?q?Jos=C3=A9=20Oliveira?= <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>, stable@vger.kernel.org
Subject: [PATCH v2 1/2] x86/speculation: Allow enabling STIBP with legacy IBRS
Date:   Tue, 21 Feb 2023 19:49:07 +0100
Message-Id: <20230221184908.2349578-1-kpsingh@kernel.org>
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

Setting the IBRS bit implicitly enables STIBP to protect against
cross-thread branch target injection. With enhanced IBRS, the bit it set
once and is not cleared again. However, on CPUs with just legacy IBRS,
IBRS bit set on user -> kernel and cleared on kernel -> user (a.k.a
KERNEL_IBRS). Clearing this bit also disables the implicitly enabled
STIBP, thus requiring some form of cross-thread protection in userspace.

Enable STIBP, either opt-in via prctl or seccomp, or always on depending
on the choice of mitigation selected via spectre_v2_user.

Reported-by: José Oliveira <joseloliveira11@gmail.com>
Reported-by: Rodrigo Branco <rodrigo@kernelhacking.com>
Reviewed-by: Alexandra Sandulescu <aesa@google.com>
Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS")
Cc: stable@vger.kernel.org
Signed-off-by: KP Singh <kpsingh@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 85168740f76a..5be6075d8e36 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1124,14 +1124,30 @@ spectre_v2_parse_user_cmdline(void)
 	return SPECTRE_V2_USER_CMD_AUTO;
 }
 
-static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mode)
+static inline bool spectre_v2_in_eibrs_mode(enum spectre_v2_mitigation mode)
 {
-	return mode == SPECTRE_V2_IBRS ||
-	       mode == SPECTRE_V2_EIBRS ||
+	return mode == SPECTRE_V2_EIBRS ||
 	       mode == SPECTRE_V2_EIBRS_RETPOLINE ||
 	       mode == SPECTRE_V2_EIBRS_LFENCE;
 }
 
+static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mode)
+{
+	return spectre_v2_in_eibrs_mode(mode) || mode == SPECTRE_V2_IBRS;
+}
+
+static inline bool spectre_v2_user_needs_stibp(enum spectre_v2_mitigation mode)
+{
+	/*
+	 * enhanced IBRS also protects against user-mode attacks as the IBRS bit
+	 * remains always set which implicitly enables cross-thread protections.
+	 * However, In legacy IBRS mode, the IBRS bit is set only in kernel
+	 * and cleared on return to userspace. This disables the implicit
+	 * cross-thread protections and STIBP is needed.
+	 */
+	return !spectre_v2_in_eibrs_mode(mode);
+}
+
 static void __init
 spectre_v2_user_select_mitigation(void)
 {
@@ -1193,13 +1209,8 @@ spectre_v2_user_select_mitigation(void)
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
+	    !spectre_v2_user_needs_stibp(spectre_v2_enabled))
 		return;
 
 	/*
@@ -2327,7 +2338,7 @@ static ssize_t mmio_stale_data_show_state(char *buf)
 
 static char *stibp_state(void)
 {
-	if (spectre_v2_in_ibrs_mode(spectre_v2_enabled))
+	if (!spectre_v2_user_needs_stibp(spectre_v2_enabled))
 		return "";
 
 	switch (spectre_v2_user_stibp) {
-- 
2.39.2.637.g21b0678d19-goog

