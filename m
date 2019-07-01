Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B146C20C1D
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfEPQCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:02:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42816 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726940AbfEPP6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:46 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0006zU-6n; Thu, 16 May 2019 16:58:38 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0001Ol-DY; Thu, 16 May 2019 16:58:37 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        dave.hansen@linux.intel.com,
        "Vince Weaver" <vincent.weaver@maine.edu>,
        "Stephane Eranian" <eranian@google.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, len.brown@intel.com,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Alexander Shishkin" <alexander.shishkin@linux.intel.com>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        "Jiri Olsa" <jolsa@redhat.com>, "Ingo Molnar" <mingo@kernel.org>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.901333999@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 30/86] x86/cpu: Sanitize FAM6_ATOM naming
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
[bwh: Backported to 3.16:
 - Drop changes to CPU IDs that weren't already included
 - Adjust filenames, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
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
-#define INTEL_FAM6_ATOM_MOOREFIELD	0x5A /* Anniedale */
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
@@ -808,11 +808,11 @@ static void identify_cpu_without_cpuid(s
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
@@ -827,10 +827,10 @@ static const __initconst struct x86_cpu_
 
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
@@ -843,14 +843,14 @@ static const __initconst struct x86_cpu_
 
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

