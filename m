Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3C120C48
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfEPQDb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:03:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42606 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726812AbfEPP6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:43 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImH-0006zd-9z; Thu, 16 May 2019 16:58:41 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0001RD-DZ; Thu, 16 May 2019 16:58:38 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Borislav Petkov" <bp@suse.de>,
        "Frederic Weisbecker" <frederic@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Jon Masters" <jcm@redhat.com>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.115038243@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 61/86] x86/msr-index: Cleanup bit defines
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

From: Thomas Gleixner <tglx@linutronix.de>

commit d8eabc37310a92df40d07c5a8afc53cebf996716 upstream.

Greg pointed out that speculation related bit defines are using (1 << N)
format instead of BIT(N). Aside of that (1 << N) is wrong as it should use
1UL at least.

Clean it up.

[ Josh Poimboeuf: Fix tools build ]

Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Jon Masters <jcm@redhat.com>
Tested-by: Jon Masters <jcm@redhat.com>
[bwh: Backported to 3.16:
 - Since <asm/msr-index.h> is a UAPI header here, open-code BIT() and drop
   changes under tools/
 - Drop changes to flush MSRs which we haven't defined]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -33,14 +33,14 @@
 
 /* Intel MSRs. Some also available on other CPUs */
 #define MSR_IA32_SPEC_CTRL		0x00000048 /* Speculation Control */
-#define SPEC_CTRL_IBRS			(1 << 0)   /* Indirect Branch Restricted Speculation */
+#define SPEC_CTRL_IBRS			(1UL << 0) /* Indirect Branch Restricted Speculation */
 #define SPEC_CTRL_STIBP_SHIFT		1	   /* Single Thread Indirect Branch Predictor (STIBP) bit */
-#define SPEC_CTRL_STIBP			(1 << SPEC_CTRL_STIBP_SHIFT)	/* STIBP mask */
+#define SPEC_CTRL_STIBP			(1UL << SPEC_CTRL_STIBP_SHIFT)	/* STIBP mask */
 #define SPEC_CTRL_SSBD_SHIFT		2	   /* Speculative Store Bypass Disable bit */
-#define SPEC_CTRL_SSBD			(1 << SPEC_CTRL_SSBD_SHIFT)	/* Speculative Store Bypass Disable */
+#define SPEC_CTRL_SSBD			(1UL << SPEC_CTRL_SSBD_SHIFT) /* Speculative Store Bypass Disable */
 
 #define MSR_IA32_PRED_CMD		0x00000049 /* Prediction Command */
-#define PRED_CMD_IBPB			(1 << 0)   /* Indirect Branch Prediction Barrier */
+#define PRED_CMD_IBPB			(1UL << 0) /* Indirect Branch Prediction Barrier */
 
 #define MSR_IA32_PERFCTR0		0x000000c1
 #define MSR_IA32_PERFCTR1		0x000000c2
@@ -58,9 +58,9 @@
 #define MSR_MTRRcap			0x000000fe
 
 #define MSR_IA32_ARCH_CAPABILITIES	0x0000010a
-#define ARCH_CAP_RDCL_NO		(1 << 0)   /* Not susceptible to Meltdown */
-#define ARCH_CAP_IBRS_ALL		(1 << 1)   /* Enhanced IBRS support */
-#define ARCH_CAP_SSB_NO			(1 << 4)   /*
+#define ARCH_CAP_RDCL_NO		(1UL << 0) /* Not susceptible to Meltdown */
+#define ARCH_CAP_IBRS_ALL		(1UL << 1) /* Enhanced IBRS support */
+#define ARCH_CAP_SSB_NO			(1UL << 4) /*
 						    * Not susceptible to Speculative Store Bypass
 						    * attack, so no Speculative Store Bypass
 						    * control required.

