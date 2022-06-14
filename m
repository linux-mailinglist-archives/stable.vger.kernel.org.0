Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1899654B8F1
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 20:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357098AbiFNSlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356876AbiFNSlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:41:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1769149F2E;
        Tue, 14 Jun 2022 11:41:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52172617C1;
        Tue, 14 Jun 2022 18:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B02EC3411B;
        Tue, 14 Jun 2022 18:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655232083;
        bh=4QIHLAGFhjL/KiLp1O3/nEyF85lPAfW056oCA8WF/YQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=broF6pat2E3/X9987WU8eoHWqzrKI9kgaMbDvacjZrGdg7m/nVycQwXZdlvDISjAW
         NoNmM//b+8tvBiWKH6uVYwlV6cls4oZIrJRZJ1Qw8mo4H5T9DoGc90kcC1L0S8cUTY
         8k/Ib+9ealBqfTmnkIVZjJ0NbvFVlWmhQjrYeVBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.9 18/20] x86/speculation/mmio: Reuse SRBDS mitigation for SBDS
Date:   Tue, 14 Jun 2022 20:40:01 +0200
Message-Id: <20220614183726.418477518@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614183722.061550591@linuxfoundation.org>
References: <20220614183722.061550591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit a992b8a4682f119ae035a01b40d4d0665c4a2875 upstream

The Shared Buffers Data Sampling (SBDS) variant of Processor MMIO Stale
Data vulnerabilities may expose RDRAND, RDSEED and SGX EGETKEY data.
Mitigation for this is added by a microcode update.

As some of the implications of SBDS are similar to SRBDS, SRBDS mitigation
infrastructure can be leveraged by SBDS. Set X86_BUG_SRBDS and use SRBDS
mitigation.

Mitigation is enabled by default; use srbds=off to opt-out. Mitigation
status can be checked from below file:

  /sys/devices/system/cpu/vulnerabilities/srbds

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[cascardo: adjust for processor model names]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/common.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -964,6 +964,8 @@ static const __initconst struct x86_cpu_
 #define SRBDS		BIT(0)
 /* CPU is affected by X86_BUG_MMIO_STALE_DATA */
 #define MMIO		BIT(1)
+/* CPU is affected by Shared Buffers Data Sampling (SBDS), a variant of X86_BUG_MMIO_STALE_DATA */
+#define MMIO_SBDS	BIT(2)
 
 static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
 	VULNBL_INTEL_STEPPINGS(IVYBRIDGE,	X86_STEPPING_ANY,		SRBDS),
@@ -985,16 +987,17 @@ static const struct x86_cpu_id cpu_vuln_
 	VULNBL_INTEL_STEPPINGS(KABYLAKE_MOBILE,	X86_STEPPINGS(0x0, 0x8),	SRBDS),
 	VULNBL_INTEL_STEPPINGS(KABYLAKE_DESKTOP,X86_STEPPINGS(0x9, 0xD),	SRBDS | MMIO),
 	VULNBL_INTEL_STEPPINGS(KABYLAKE_DESKTOP,X86_STEPPINGS(0x0, 0x8),	SRBDS),
-	VULNBL_INTEL_STEPPINGS(ICELAKE_MOBILE,	X86_STEPPINGS(0x5, 0x5),	MMIO),
+	VULNBL_INTEL_STEPPINGS(ICELAKE_MOBILE,	X86_STEPPINGS(0x5, 0x5),	MMIO | MMIO_SBDS),
 	VULNBL_INTEL_STEPPINGS(ICELAKE_XEON_D,	X86_STEPPINGS(0x1, 0x1),	MMIO),
 	VULNBL_INTEL_STEPPINGS(ICELAKE_X,	X86_STEPPINGS(0x4, 0x6),	MMIO),
-	VULNBL_INTEL_STEPPINGS(COMETLAKE,	BIT(2) | BIT(3) | BIT(5),	MMIO),
-	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPINGS(0x0, 0x1),	MMIO),
-	VULNBL_INTEL_STEPPINGS(LAKEFIELD,	X86_STEPPINGS(0x1, 0x1),	MMIO),
+	VULNBL_INTEL_STEPPINGS(COMETLAKE,	BIT(2) | BIT(3) | BIT(5),	MMIO | MMIO_SBDS),
+	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS),
+	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPINGS(0x0, 0x0),	MMIO),
+	VULNBL_INTEL_STEPPINGS(LAKEFIELD,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS),
 	VULNBL_INTEL_STEPPINGS(ROCKETLAKE,	X86_STEPPINGS(0x1, 0x1),	MMIO),
-	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT,	X86_STEPPINGS(0x1, 0x1),	MMIO),
+	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS),
 	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_X,	X86_STEPPING_ANY,		MMIO),
-	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_L,	X86_STEPPINGS(0x0, 0x0),	MMIO),
+	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_L,	X86_STEPPINGS(0x0, 0x0),	MMIO | MMIO_SBDS),
 	{}
 };
 
@@ -1073,10 +1076,14 @@ static void __init cpu_set_bug_bits(stru
 	/*
 	 * SRBDS affects CPUs which support RDRAND or RDSEED and are listed
 	 * in the vulnerability blacklist.
+	 *
+	 * Some of the implications and mitigation of Shared Buffers Data
+	 * Sampling (SBDS) are similar to SRBDS. Give SBDS same treatment as
+	 * SRBDS.
 	 */
 	if ((cpu_has(c, X86_FEATURE_RDRAND) ||
 	     cpu_has(c, X86_FEATURE_RDSEED)) &&
-	    cpu_matches(cpu_vuln_blacklist, SRBDS))
+	    cpu_matches(cpu_vuln_blacklist, SRBDS | MMIO_SBDS))
 		    setup_force_cpu_bug(X86_BUG_SRBDS);
 
 	/*


