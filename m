Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 751831F2BB
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbfEOLKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:10:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729136AbfEOLKG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:10:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33C63216F4;
        Wed, 15 May 2019 11:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918604;
        bh=Z9vTtJmt6IZiKqhO4fLOOf2IbkRqFeSXn9VVvQdAheE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JfSRR0OK/Z8ofy7V4HpV9gVfatLIqJF/PJkG927BnthUByaMuF4OZ72cjtLB9/9dq
         DqPFK/oFTD/eAErFZMRDDGpUSF5U30zUpndZ7xpTbgE1nF07RfXfTKvlmhAeWc3A6H
         uZUq5ft1UBNLTFFHidOtRHlXyhz/cNAPRJeIoE3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        dave.hansen@linux.intel.com, len.brown@intel.com,
        Ingo Molnar <mingo@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 195/266] x86/cpu: Sanitize FAM6_ATOM naming
Date:   Wed, 15 May 2019 12:55:02 +0200
Message-Id: <20190515090729.540621917@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit f2c4db1bd80720cd8cb2a5aa220d9bc9f374f04e upstream.

Going primarily by:

  https://en.wikipedia.org/wiki/List_of_Intel_Atom_microprocessors

with additional information gleaned from other related pages; notably:

 - Bonnell shrink was called Saltwell
 - Moorefield is the Merriefield refresh which makes it Airmont

The general naming scheme is: FAM6_ATOM_UARCH_SOCTYPE

  for i in `git grep -l FAM6_ATOM` ; do
	sed -i  -e 's/ATOM_PINEVIEW/ATOM_BONNELL/g'		\
		-e 's/ATOM_LINCROFT/ATOM_BONNELL_MID/'		\
		-e 's/ATOM_PENWELL/ATOM_SALTWELL_MID/g'		\
		-e 's/ATOM_CLOVERVIEW/ATOM_SALTWELL_TABLET/g'	\
		-e 's/ATOM_CEDARVIEW/ATOM_SALTWELL/g'		\
		-e 's/ATOM_SILVERMONT1/ATOM_SILVERMONT/g'	\
		-e 's/ATOM_SILVERMONT2/ATOM_SILVERMONT_X/g'	\
		-e 's/ATOM_MERRIFIELD/ATOM_SILVERMONT_MID/g'	\
		-e 's/ATOM_MOOREFIELD/ATOM_AIRMONT_MID/g'	\
		-e 's/ATOM_DENVERTON/ATOM_GOLDMONT_X/g'		\
		-e 's/ATOM_GEMINI_LAKE/ATOM_GOLDMONT_PLUS/g' ${i}
  done

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: dave.hansen@linux.intel.com
Cc: len.brown@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 4.4:
 - Drop changes to CPU IDs that weren't already included
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/intel-family.h |   30 +++++++++++++++++-------------
 arch/x86/kernel/cpu/common.c        |   28 ++++++++++++++--------------
 2 files changed, 31 insertions(+), 27 deletions(-)

--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -50,19 +50,23 @@
 
 /* "Small Core" Processors (Atom) */
 
-#define INTEL_FAM6_ATOM_PINEVIEW	0x1C
-#define INTEL_FAM6_ATOM_LINCROFT	0x26
-#define INTEL_FAM6_ATOM_PENWELL		0x27
-#define INTEL_FAM6_ATOM_CLOVERVIEW	0x35
-#define INTEL_FAM6_ATOM_CEDARVIEW	0x36
-#define INTEL_FAM6_ATOM_SILVERMONT1	0x37 /* BayTrail/BYT / Valleyview */
-#define INTEL_FAM6_ATOM_SILVERMONT2	0x4D /* Avaton/Rangely */
-#define INTEL_FAM6_ATOM_AIRMONT		0x4C /* CherryTrail / Braswell */
-#define INTEL_FAM6_ATOM_MERRIFIELD	0x4A /* Tangier */
-#define INTEL_FAM6_ATOM_MOOREFIELD	0x5A /* Annidale */
-#define INTEL_FAM6_ATOM_GOLDMONT	0x5C
-#define INTEL_FAM6_ATOM_DENVERTON	0x5F /* Goldmont Microserver */
-#define INTEL_FAM6_ATOM_GEMINI_LAKE	0x7A
+#define INTEL_FAM6_ATOM_BONNELL		0x1C /* Diamondville, Pineview */
+#define INTEL_FAM6_ATOM_BONNELL_MID	0x26 /* Silverthorne, Lincroft */
+
+#define INTEL_FAM6_ATOM_SALTWELL	0x36 /* Cedarview */
+#define INTEL_FAM6_ATOM_SALTWELL_MID	0x27 /* Penwell */
+#define INTEL_FAM6_ATOM_SALTWELL_TABLET	0x35 /* Cloverview */
+
+#define INTEL_FAM6_ATOM_SILVERMONT	0x37 /* Bay Trail, Valleyview */
+#define INTEL_FAM6_ATOM_SILVERMONT_X	0x4D /* Avaton, Rangely */
+#define INTEL_FAM6_ATOM_SILVERMONT_MID	0x4A /* Merriefield */
+
+#define INTEL_FAM6_ATOM_AIRMONT		0x4C /* Cherry Trail, Braswell */
+#define INTEL_FAM6_ATOM_AIRMONT_MID	0x5A /* Moorefield */
+
+#define INTEL_FAM6_ATOM_GOLDMONT	0x5C /* Apollo Lake */
+#define INTEL_FAM6_ATOM_GOLDMONT_X	0x5F /* Denverton */
+#define INTEL_FAM6_ATOM_GOLDMONT_PLUS	0x7A /* Gemini Lake */
 
 /* Xeon Phi */
 
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -848,11 +848,11 @@ static void identify_cpu_without_cpuid(s
 }
 
 static const __initconst struct x86_cpu_id cpu_no_speculation[] = {
-	{ X86_VENDOR_INTEL,	6, INTEL_FAM6_ATOM_CEDARVIEW,	X86_FEATURE_ANY },
-	{ X86_VENDOR_INTEL,	6, INTEL_FAM6_ATOM_CLOVERVIEW,	X86_FEATURE_ANY },
-	{ X86_VENDOR_INTEL,	6, INTEL_FAM6_ATOM_LINCROFT,	X86_FEATURE_ANY },
-	{ X86_VENDOR_INTEL,	6, INTEL_FAM6_ATOM_PENWELL,	X86_FEATURE_ANY },
-	{ X86_VENDOR_INTEL,	6, INTEL_FAM6_ATOM_PINEVIEW,	X86_FEATURE_ANY },
+	{ X86_VENDOR_INTEL,	6, INTEL_FAM6_ATOM_SALTWELL,	X86_FEATURE_ANY },
+	{ X86_VENDOR_INTEL,	6, INTEL_FAM6_ATOM_SALTWELL_TABLET,	X86_FEATURE_ANY },
+	{ X86_VENDOR_INTEL,	6, INTEL_FAM6_ATOM_BONNELL_MID,	X86_FEATURE_ANY },
+	{ X86_VENDOR_INTEL,	6, INTEL_FAM6_ATOM_SALTWELL_MID,	X86_FEATURE_ANY },
+	{ X86_VENDOR_INTEL,	6, INTEL_FAM6_ATOM_BONNELL,	X86_FEATURE_ANY },
 	{ X86_VENDOR_CENTAUR,	5 },
 	{ X86_VENDOR_INTEL,	5 },
 	{ X86_VENDOR_NSC,	5 },
@@ -867,10 +867,10 @@ static const __initconst struct x86_cpu_
 
 /* Only list CPUs which speculate but are non susceptible to SSB */
 static const __initconst struct x86_cpu_id cpu_no_spec_store_bypass[] = {
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_SILVERMONT1	},
+	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_SILVERMONT	},
 	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_AIRMONT		},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_SILVERMONT2	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_MERRIFIELD	},
+	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_SILVERMONT_X	},
+	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_SILVERMONT_MID	},
 	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_CORE_YONAH		},
 	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_XEON_PHI_KNL		},
 	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_XEON_PHI_KNM		},
@@ -883,14 +883,14 @@ static const __initconst struct x86_cpu_
 
 static const __initconst struct x86_cpu_id cpu_no_l1tf[] = {
 	/* in addition to cpu_no_speculation */
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_SILVERMONT1	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_SILVERMONT2	},
+	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_SILVERMONT	},
+	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_SILVERMONT_X	},
 	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_AIRMONT		},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_MERRIFIELD	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_MOOREFIELD	},
+	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_SILVERMONT_MID	},
+	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_AIRMONT_MID	},
 	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_GOLDMONT	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_DENVERTON	},
-	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_GEMINI_LAKE	},
+	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_GOLDMONT_X	},
+	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ATOM_GOLDMONT_PLUS	},
 	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_XEON_PHI_KNL		},
 	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_XEON_PHI_KNM		},
 	{}


