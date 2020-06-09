Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F101F443A
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbgFIRwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:52:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731611AbgFIRwn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:52:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7FCF20801;
        Tue,  9 Jun 2020 17:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725163;
        bh=hOmNoff9bwoQAs+mY1OICGkI+7xRGt2c2lk5BdXv4rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LUyKuR3vOL4olONq1+4a7k3Bw/FXRuDntlYlXNCNbLwnaLVsVp9jesbEsd/PKqRn3
         8ei9h3XiKEryZZGjz0qh15Hx9vk+XNrA5/lz5kOmlNA++B74+9iNJq/nc+96GOAuVA
         WlWvGMqmu+eB4KUh4tfm9Qt2cCuxjjhKul55LkLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.4 27/34] x86/speculation/spectre_v2: Exclude Zhaoxin CPUs from SPECTRE_V2
Date:   Tue,  9 Jun 2020 19:45:23 +0200
Message-Id: <20200609174056.885099252@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174052.628006868@linuxfoundation.org>
References: <20200609174052.628006868@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>

commit 1e41a766c98b481400ab8c5a7aa8ea63a1bb03de upstream.

New Zhaoxin family 7 CPUs are not affected by SPECTRE_V2. So define a
separate cpu_vuln_whitelist bit NO_SPECTRE_V2 and add these CPUs to the cpu
vulnerability whitelist.

Signed-off-by: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/1579227872-26972-2-git-send-email-TonyWWang-oc@zhaoxin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/common.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1024,6 +1024,7 @@ static void identify_cpu_without_cpuid(s
 #define MSBDS_ONLY		BIT(5)
 #define NO_SWAPGS		BIT(6)
 #define NO_ITLB_MULTIHIT	BIT(7)
+#define NO_SPECTRE_V2		BIT(8)
 
 #define VULNWL(_vendor, _family, _model, _whitelist)	\
 	{ X86_VENDOR_##_vendor, _family, _model, X86_FEATURE_ANY, _whitelist }
@@ -1085,6 +1086,10 @@ static const __initconst struct x86_cpu_
 	/* FAMILY_ANY must be last, otherwise 0x0f - 0x12 matches won't work */
 	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
 	VULNWL_HYGON(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
+
+	/* Zhaoxin Family 7 */
+	VULNWL(CENTAUR,	7, X86_MODEL_ANY,	NO_SPECTRE_V2),
+	VULNWL(ZHAOXIN,	7, X86_MODEL_ANY,	NO_SPECTRE_V2),
 	{}
 };
 
@@ -1117,7 +1122,9 @@ static void __init cpu_set_bug_bits(stru
 		return;
 
 	setup_force_cpu_bug(X86_BUG_SPECTRE_V1);
-	setup_force_cpu_bug(X86_BUG_SPECTRE_V2);
+
+	if (!cpu_matches(NO_SPECTRE_V2))
+		setup_force_cpu_bug(X86_BUG_SPECTRE_V2);
 
 	if (!cpu_matches(NO_SSB) && !(ia32_cap & ARCH_CAP_SSB_NO) &&
 	   !cpu_has(c, X86_FEATURE_AMD_SSB_NO))


