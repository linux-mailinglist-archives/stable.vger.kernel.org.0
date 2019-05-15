Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 956711ED78
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbfEOLJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:09:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728592AbfEOLJk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:09:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33E4220862;
        Wed, 15 May 2019 11:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918579;
        bh=hwU7ROo4iJ4uFzUDHdtol5b7+BsVPEeHgoSStVOeZ5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xxtyPlJWySZjyKskOduvm6suTwLjZ/YoLlHyrja+zQoUqDwMSi3TYDy1H/pRAqRst
         eCbOn+DSNVwhRKrKQCgkBWdNvdWQQbrw7X+JCSJCFmD2TW75bQ9Trx+135x7tjN5Hr
         iGiQmaGjmXjRrKOXL5SlKi7d05g0RjvZg307pt3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Thomas Gleixner <tglx@linutronix.de>, bp@suse.de,
        konrad.wilk@oracle.com, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 186/266] x86/speculation: Simplify the CPU bug detection logic
Date:   Wed, 15 May 2019 12:54:53 +0200
Message-Id: <20190515090729.222562052@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dominik Brodowski <linux@dominikbrodowski.net>

commit 8ecc4979b1bd9c94168e6fc92960033b7a951336 upstream.

Only CPUs which speculate can speculate. Therefore, it seems prudent
to test for cpu_no_speculation first and only then determine whether
a specific speculating CPU is susceptible to store bypass speculation.
This is underlined by all CPUs currently listed in cpu_no_speculation
were present in cpu_no_spec_store_bypass as well.

Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: bp@suse.de
Cc: konrad.wilk@oracle.com
Link: https://lkml.kernel.org/r/20180522090539.GA24668@light.dominikbrodowski.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/common.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -859,12 +859,8 @@ static const __initconst struct x86_cpu_
 	{}
 };
 
+/* Only list CPUs which speculate but are non susceptible to SSB */
 static const __initconst struct x86_cpu_id cpu_no_spec_store_bypass[] = {
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_PINEVIEW	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_LINCROFT	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_PENWELL		},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_CLOVERVIEW	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_CEDARVIEW	},
 	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_SILVERMONT1	},
 	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_AIRMONT		},
 	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_SILVERMONT2	},
@@ -872,14 +868,10 @@ static const __initconst struct x86_cpu_
 	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_CORE_YONAH		},
 	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_XEON_PHI_KNL		},
 	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_XEON_PHI_KNM		},
-	{ X86_VENDOR_CENTAUR,	5,					},
-	{ X86_VENDOR_INTEL,	5,					},
-	{ X86_VENDOR_NSC,	5,					},
 	{ X86_VENDOR_AMD,	0x12,					},
 	{ X86_VENDOR_AMD,	0x11,					},
 	{ X86_VENDOR_AMD,	0x10,					},
 	{ X86_VENDOR_AMD,	0xf,					},
-	{ X86_VENDOR_ANY,	4,					},
 	{}
 };
 
@@ -902,6 +894,12 @@ static void __init cpu_set_bug_bits(stru
 {
 	u64 ia32_cap = 0;
 
+	if (x86_match_cpu(cpu_no_speculation))
+		return;
+
+	setup_force_cpu_bug(X86_BUG_SPECTRE_V1);
+	setup_force_cpu_bug(X86_BUG_SPECTRE_V2);
+
 	if (cpu_has(c, X86_FEATURE_ARCH_CAPABILITIES))
 		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, ia32_cap);
 
@@ -909,12 +907,6 @@ static void __init cpu_set_bug_bits(stru
 	   !(ia32_cap & ARCH_CAP_SSB_NO))
 		setup_force_cpu_bug(X86_BUG_SPEC_STORE_BYPASS);
 
-	if (x86_match_cpu(cpu_no_speculation))
-		return;
-
-	setup_force_cpu_bug(X86_BUG_SPECTRE_V1);
-	setup_force_cpu_bug(X86_BUG_SPECTRE_V2);
-
 	if (ia32_cap & ARCH_CAP_IBRS_ALL)
 		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
 


