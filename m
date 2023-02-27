Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4850E6A3B24
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 07:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjB0GG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 01:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjB0GG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 01:06:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556F71ACD9;
        Sun, 26 Feb 2023 22:05:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 916AB60D37;
        Mon, 27 Feb 2023 06:05:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB735C433D2;
        Mon, 27 Feb 2023 06:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677477950;
        bh=icm2m5El5AGMcBFNrF6OIbUMMImdYobl9YWfSty+WDI=;
        h=From:To:Cc:Subject:Date:From;
        b=uiukTXf50Z10gMx0TfsLNkXq5c7BA7TcoIcZ4k2eG8KqMTZcsfJfksBh00ZHoiyX9
         jMWqCf4x5ovnNtJJSSWAOSPtMJnLG5pUuuPBGmNFbb02SvGAemHhIeBWhd65EY8bwt
         ew1xyy8esBj/sPHZoSmi7dSs3PwGY4oC4XXyjns/ctGJa8KI/eyrGONZ8vcCWuGW+o
         8pDGVgu/VaOKXaNCnl4L2eXnvYW9Z2hhxI/rYHEFcs6rfU9QcCq2gulTBQpPNZmlPr
         kMXhuZpkjWh0dDu3ImPAVs9jhP8nuvF3kSWImArjAJk+IU3mbi5uH25DZkcxkniRf8
         EsIXGbadCxNAg==
From:   KP Singh <kpsingh@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     pjt@google.com, evn@google.com, jpoimboe@kernel.org,
        tglx@linutronix.de, x86@kernel.org, hpa@zytor.com,
        peterz@infradead.org, pawan.kumar.gupta@linux.intel.com,
        kim.phillips@amd.com, alexandre.chartre@oracle.com,
        daniel.sneddon@linux.intel.com, corbet@lwn.net, bp@suse.de,
        linyujun809@huawei.com, kpsingh@kernel.org, jmattson@google.com,
        mingo@redhat.com, seanjc@google.com, andrew.cooper3@citrix.com,
        =?UTF-8?q?Jos=C3=A9=20Oliveira?= <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        stable@vger.kernel.org
Subject: [PATCH v3 1/2] x86/speculation: Allow enabling STIBP with legacy IBRS
Date:   Mon, 27 Feb 2023 07:05:40 +0100
Message-Id: <20230227060541.1939092-1-kpsingh@kernel.org>
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

When plain IBRS is enabled (not enhanced IBRS), the logic in
spectre_v2_user_select_mitigation() determines that STIBP is not needed.

The IBRS bit implicitly protects against cross-thread branch target
injection. However, with legacy IBRS, the IBRS bit is cleared on
returning to userspace for performance reasons which leaves userspace
threads vulnerable to cross-thread branch target injection against which
STIBP protects.

Exclude IBRS from the spectre_v2_in_ibrs_mode() check to allow for
enabling STIBP (through seccomp/prctl() by default or always-on, if
selected by spectre_v2_user kernel cmdline parameter).

Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS")
Reported-by: José Oliveira <joseloliveira11@gmail.com>
Reported-by: Rodrigo Branco <rodrigo@kernelhacking.com>
Cc: stable@vger.kernel.org
Signed-off-by: KP Singh <kpsingh@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index cf81848b72f4..44e22cda7fb3 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1133,14 +1133,18 @@ spectre_v2_parse_user_cmdline(void)
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
 static void __init
 spectre_v2_user_select_mitigation(void)
 {
@@ -1203,12 +1207,20 @@ spectre_v2_user_select_mitigation(void)
 	}
 
 	/*
-	 * If no STIBP, IBRS or enhanced IBRS is enabled, or SMT impossible,
-	 * STIBP is not required.
+	 * If no STIBP, enhanced IBRS is enabled, or SMT impossible, STIBP
+	 * is not required.
+	 *
+	 * Enhanced IBRS also protects against cross-thread branch target
+	 * injection in user-mode as the IBRS bit remains always set which
+	 * implicitly enables cross-thread protections.  However, in legacy IBRS
+	 * mode, the IBRS bit is set only on kernel entry and cleared on return
+	 * to userspace. This disables the implicit
+	 * cross-thread protection, so allow for STIBP to be selected in that
+	 * case.
 	 */
 	if (!boot_cpu_has(X86_FEATURE_STIBP) ||
 	    !smt_possible ||
-	    spectre_v2_in_ibrs_mode(spectre_v2_enabled))
+	    spectre_v2_in_eibrs_mode(spectre_v2_enabled))
 		return;
 
 	/*
@@ -2340,7 +2352,7 @@ static ssize_t mmio_stale_data_show_state(char *buf)
 
 static char *stibp_state(void)
 {
-	if (spectre_v2_in_ibrs_mode(spectre_v2_enabled))
+	if (spectre_v2_in_eibrs_mode(spectre_v2_enabled))
 		return "";
 
 	switch (spectre_v2_user_stibp) {
-- 
2.39.2.637.g21b0678d19-goog

