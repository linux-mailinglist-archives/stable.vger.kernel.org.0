Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0294D48BF
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242819AbiCJOLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:11:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242776AbiCJOLV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:11:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24079D4F9;
        Thu, 10 Mar 2022 06:10:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90BEEB824C7;
        Thu, 10 Mar 2022 14:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19BDC340E8;
        Thu, 10 Mar 2022 14:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646921414;
        bh=QwlJvWOkklMTHykH22gZQn+3XT4PMhG8ZaiKF4jVX/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BjO1BV0p/Ns1pCQ2mUT87ok39Xygvd+gdb3KwqLg/OjTUwociIzbvPmylFPynKQ6c
         LZ6bsu949RTItkHYu5DapYq5KTT0QdTEFFYR7OeQs/NK+DlpRf/d4pKxD3RFi8trcg
         lfFaR4cuI/nQukjRbNTXKiRoDViPxlUPVQsvdDJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.16 03/53] Documentation/hw-vuln: Update spectre doc
Date:   Thu, 10 Mar 2022 15:09:08 +0100
Message-Id: <20220310140811.935340298@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140811.832630727@linuxfoundation.org>
References: <20220310140811.832630727@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit 5ad3eb1132453b9795ce5fd4572b1c18b292cca9 upstream.

Update the doc with the new fun.

  [ bp: Massage commit message. ]

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/hw-vuln/spectre.rst   |   44 ++++++++++++++++--------
 Documentation/admin-guide/kernel-parameters.txt |    8 +++-
 2 files changed, 36 insertions(+), 16 deletions(-)

--- a/Documentation/admin-guide/hw-vuln/spectre.rst
+++ b/Documentation/admin-guide/hw-vuln/spectre.rst
@@ -131,6 +131,19 @@ steer its indirect branch speculations t
 speculative execution's side effects left in level 1 cache to infer the
 victim's data.
 
+Yet another variant 2 attack vector is for the attacker to poison the
+Branch History Buffer (BHB) to speculatively steer an indirect branch
+to a specific Branch Target Buffer (BTB) entry, even if the entry isn't
+associated with the source address of the indirect branch. Specifically,
+the BHB might be shared across privilege levels even in the presence of
+Enhanced IBRS.
+
+Currently the only known real-world BHB attack vector is via
+unprivileged eBPF. Therefore, it's highly recommended to not enable
+unprivileged eBPF, especially when eIBRS is used (without retpolines).
+For a full mitigation against BHB attacks, it's recommended to use
+retpolines (or eIBRS combined with retpolines).
+
 Attack scenarios
 ----------------
 
@@ -364,13 +377,15 @@ The possible values in this file are:
 
   - Kernel status:
 
-  ====================================  =================================
-  'Not affected'                        The processor is not vulnerable
-  'Vulnerable'                          Vulnerable, no mitigation
-  'Mitigation: Full generic retpoline'  Software-focused mitigation
-  'Mitigation: Full AMD retpoline'      AMD-specific software mitigation
-  'Mitigation: Enhanced IBRS'           Hardware-focused mitigation
-  ====================================  =================================
+  ========================================  =================================
+  'Not affected'                            The processor is not vulnerable
+  'Mitigation: None'                        Vulnerable, no mitigation
+  'Mitigation: Retpolines'                  Use Retpoline thunks
+  'Mitigation: LFENCE'                      Use LFENCE instructions
+  'Mitigation: Enhanced IBRS'               Hardware-focused mitigation
+  'Mitigation: Enhanced IBRS + Retpolines'  Hardware-focused + Retpolines
+  'Mitigation: Enhanced IBRS + LFENCE'      Hardware-focused + LFENCE
+  ========================================  =================================
 
   - Firmware status: Show if Indirect Branch Restricted Speculation (IBRS) is
     used to protect against Spectre variant 2 attacks when calling firmware (x86 only).
@@ -583,12 +598,13 @@ kernel command line.
 
 		Specific mitigations can also be selected manually:
 
-		retpoline
-					replace indirect branches
-		retpoline,generic
-					google's original retpoline
-		retpoline,amd
-					AMD-specific minimal thunk
+                retpoline               auto pick between generic,lfence
+                retpoline,generic       Retpolines
+                retpoline,lfence        LFENCE; indirect branch
+                retpoline,amd           alias for retpoline,lfence
+                eibrs                   enhanced IBRS
+                eibrs,retpoline         enhanced IBRS + Retpolines
+                eibrs,lfence            enhanced IBRS + LFENCE
 
 		Not specifying this option is equivalent to
 		spectre_v2=auto.
@@ -599,7 +615,7 @@ kernel command line.
 		spectre_v2=off. Spectre variant 1 mitigations
 		cannot be disabled.
 
-For spectre_v2_user see :doc:`/admin-guide/kernel-parameters`.
+For spectre_v2_user see Documentation/admin-guide/kernel-parameters.txt
 
 Mitigation selection guide
 --------------------------
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5303,8 +5303,12 @@
 			Specific mitigations can also be selected manually:
 
 			retpoline	  - replace indirect branches
-			retpoline,generic - google's original retpoline
-			retpoline,amd     - AMD-specific minimal thunk
+			retpoline,generic - Retpolines
+			retpoline,lfence  - LFENCE; indirect branch
+			retpoline,amd     - alias for retpoline,lfence
+			eibrs		  - enhanced IBRS
+			eibrs,retpoline   - enhanced IBRS + Retpolines
+			eibrs,lfence      - enhanced IBRS + LFENCE
 
 			Not specifying this option is equivalent to
 			spectre_v2=auto.


