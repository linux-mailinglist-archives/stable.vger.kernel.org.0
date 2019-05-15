Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9EE81F2B1
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729055AbfEOLJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:09:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729263AbfEOLJ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:09:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91D9E20843;
        Wed, 15 May 2019 11:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918569;
        bh=0romyWTBFUYbeSjBFCYeTB6M9EA7wEz8HCJSZqFhoOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=InYCE8qvKLtnJyz7EZDmumo3bqLcmonf+o6Ak8Q4I/6oxBhhgSrvbsrAjpVNU0VQ1
         WF5a9BCEwSasGLgoJ+5NxqY25o7wxkqdeknd/hGcB/oWdSNOvZFZtsvHKPSFculjAr
         pdoGYH3hPEkeHC8NZzJhNHZc2MuHCCouaXVb5Q1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ashok Raj <ashok.raj@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Arjan Van De Ven <arjan.van.de.ven@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 182/266] x86/microcode/intel: Check microcode revision before updating sibling threads
Date:   Wed, 15 May 2019 12:54:49 +0200
Message-Id: <20190515090729.085096103@linuxfoundation.org>
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

From: Ashok Raj <ashok.raj@intel.com>

commit c182d2b7d0ca48e0d6ff16f7d883161238c447ed upstream.

After updating microcode on one of the threads of a core, the other
thread sibling automatically gets the update since the microcode
resources on a hyperthreaded core are shared between the two threads.

Check the microcode revision on the CPU before performing a microcode
update and thus save us the WRMSR 0x79 because it is a particularly
expensive operation.

[ Borislav: Massage changelog and coding style. ]

Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Ashok Raj <ashok.raj@intel.com>
Cc: Arjan Van De Ven <arjan.van.de.ven@intel.com>
Link: http://lkml.kernel.org/r/1519352533-15992-2-git-send-email-ashok.raj@intel.com
Link: https://lkml.kernel.org/r/20180228102846.13447-3-bp@alien8.de
[bwh: Backported to 4.4:
 - s/mc->/mc_intel->/
 - Return 0 in this case
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/intel.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -653,6 +653,17 @@ static int apply_microcode_early(struct
 	if (mc_intel == NULL)
 		return 0;
 
+	/*
+	 * Save us the MSR write below - which is a particular expensive
+	 * operation - when the other hyperthread has updated the microcode
+	 * already.
+	 */
+	rev = intel_get_microcode_revision();
+	if (rev >= mc_intel->hdr.rev) {
+		uci->cpu_sig.rev = rev;
+		return 0;
+	}
+
 	/* write microcode via MSR 0x79 */
 	native_wrmsr(MSR_IA32_UCODE_WRITE,
 	      (unsigned long) mc_intel->bits,
@@ -861,6 +872,18 @@ static int apply_microcode_intel(int cpu
 	if (get_matching_mc(mc_intel, cpu) == 0)
 		return 0;
 
+	/*
+	 * Save us the MSR write below - which is a particular expensive
+	 * operation - when the other hyperthread has updated the microcode
+	 * already.
+	 */
+	rev = intel_get_microcode_revision();
+	if (rev >= mc_intel->hdr.rev) {
+		uci->cpu_sig.rev = rev;
+		c->microcode = rev;
+		return 0;
+	}
+
 	/* write microcode via MSR 0x79 */
 	wrmsr(MSR_IA32_UCODE_WRITE,
 	      (unsigned long) mc_intel->bits,


