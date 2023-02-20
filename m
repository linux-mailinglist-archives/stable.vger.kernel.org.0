Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7670369D2BB
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 19:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbjBTS1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 13:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjBTS1W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 13:27:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343A71C31A;
        Mon, 20 Feb 2023 10:27:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A781860F00;
        Mon, 20 Feb 2023 18:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFABC4339B;
        Mon, 20 Feb 2023 18:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676917640;
        bh=T7ZxLDOEHL5a48unqqdISt58VJOeJ4E3/WLn0nVRKCc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uqE9+1R/bBNbWjA+oKlDucXB7DEGP9lhZkLY/MFrrjkLOemujnpYEywdzT2fT3Vxs
         bsbanDWV6wca2uXqpo5RtprA1GqJW91apcJeFNcL/5K6srwBSa1MxMuYXA02Y+dq79
         mZxBvzDa9WbpU0AXUqn0TmmsbpXJA3SJhUAcyay5T7Zf9cAP6HfBTyQ+hzXhYpssgx
         exT1bItyrpzsWmCuZjz8luhWCeNiBFc/6/UwBIoctZ+P5fS32pz0VkHkegg6mOZW5/
         JgA9M+MXtfFRdiM/uX0+QPLKY8+rt3qSR5witakoCgmE5YSyONhR78CcOunQnRMuzZ
         aC0vt5DD6alBw==
Date:   Mon, 20 Feb 2023 10:27:17 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     KP Singh <kpsingh@kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        pjt@google.com, evn@google.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, peterz@infradead.org,
        pawan.kumar.gupta@linux.intel.com, kim.phillips@amd.com,
        alexandre.chartre@oracle.com, daniel.sneddon@linux.intel.com,
        =?utf-8?B?Sm9zw6k=?= Oliveira <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>,
        Jim Mattson <jmattson@google.com>, stable@vger.kernel.org
Subject: [PATCH] x86/bugs: Allow STIBP with IBRS
Message-ID: <20230220182717.uzrym2gtavlbjbxo@treble>
References: <20230220120127.1975241-1-kpsingh@kernel.org>
 <20230220121350.aidsipw3kd4rsyss@treble>
 <CACYkzJ5L9MLuE5Jz+z5-NJCCrUqTbgKQkXSqnQnCfTD_WNA7_Q@mail.gmail.com>
 <CACYkzJ6n=-tobhX0ONQhjHSgmnNjWnNe_dZnEOGtD8Y6S3RHbA@mail.gmail.com>
 <20230220163442.7fmaeef3oqci4ee3@treble>
 <Y/Ox3MJZF1Yb7b6y@zn.tnic>
 <20230220175929.2laflfb2met6y3kc@treble>
 <CACYkzJ71xqzY6-wL+YShcL+d6ugzcdFHr6tbYWWE_ep52+RBZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACYkzJ71xqzY6-wL+YShcL+d6ugzcdFHr6tbYWWE_ep52+RBZQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

IBRS is only enabled in kernel space.  Since it's not enabled in user
space, user space isn't protected from indirect branch prediction
attacks from a sibling CPU thread.

Allow STIBP to be enabled to protect against such attacks.

Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS")
Reported-by: José Oliveira <joseloliveira11@gmail.com>
Reported-by: Rodrigo Branco <rodrigo@kernelhacking.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 85168740f76a..b97c0d28e573 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1124,14 +1124,19 @@ spectre_v2_parse_user_cmdline(void)
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
+	return spectre_v2_in_eibrs_mode(mode) ||
+	       mode == SPECTRE_V2_IBRS;
+}
+
 static void __init
 spectre_v2_user_select_mitigation(void)
 {
@@ -1194,12 +1199,12 @@ spectre_v2_user_select_mitigation(void)
 	}
 
 	/*
-	 * If no STIBP, IBRS or enhanced IBRS is enabled, or SMT impossible,
+	 * If no STIBP, enhanced IBRS is enabled, or SMT impossible,
 	 * STIBP is not required.
 	 */
 	if (!boot_cpu_has(X86_FEATURE_STIBP) ||
 	    !smt_possible ||
-	    spectre_v2_in_ibrs_mode(spectre_v2_enabled))
+	    spectre_v2_in_eibrs_mode(spectre_v2_enabled))
 		return;
 
 	/*
@@ -2327,9 +2332,6 @@ static ssize_t mmio_stale_data_show_state(char *buf)
 
 static char *stibp_state(void)
 {
-	if (spectre_v2_in_ibrs_mode(spectre_v2_enabled))
-		return "";
-
 	switch (spectre_v2_user_stibp) {
 	case SPECTRE_V2_USER_NONE:
 		return ", STIBP: disabled";
-- 
2.39.1

