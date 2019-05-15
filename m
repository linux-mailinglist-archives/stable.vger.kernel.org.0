Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18D551ED7F
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729341AbfEOLKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:10:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729332AbfEOLKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:10:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0CCC20862;
        Wed, 15 May 2019 11:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918602;
        bh=P2QEaSwC3bIke+FNdEZ2gq1ChB/rtACKClvcz5ePcTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uaj7QCmWRMEiE0oeOFAFyTxfjNrUU9r5JuRbjseEPP4KoSApDRjp/u7TO8lj3ieQH
         AMGmil70GOnkhxgO18bMxBt7JzVdL9kxATIfbh0agpkwoSS3TduWbadc1MJcnh5Evn
         qUa4A0/0Jp6dmvQJZNVVJk2nms0gJnT7SE5PeuFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filippo Sironi <sironi@amazon.de>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>, prarit@redhat.com,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 194/266] x86/microcode: Update the new microcode revision unconditionally
Date:   Wed, 15 May 2019 12:55:01 +0200
Message-Id: <20190515090729.504958175@linuxfoundation.org>
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

From: Filippo Sironi <sironi@amazon.de>

commit 8da38ebaad23fe1b0c4a205438676f6356607cfc upstream.

Handle the case where microcode gets loaded on the BSP's hyperthread
sibling first and the boot_cpu_data's microcode revision doesn't get
updated because of early exit due to the siblings sharing a microcode
engine.

For that, simply write the updated revision on all CPUs unconditionally.

Signed-off-by: Filippo Sironi <sironi@amazon.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: prarit@redhat.com
Link: http://lkml.kernel.org/r/1533050970-14385-1-git-send-email-sironi@amazon.de
[bwh: Backported to 4.4:
 - Keep returning 0 on success
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c   |   20 ++++++++++----------
 arch/x86/kernel/cpu/microcode/intel.c |   10 ++++------
 2 files changed, 14 insertions(+), 16 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -695,26 +695,26 @@ int apply_microcode_amd(int cpu)
 		return -1;
 
 	/* need to apply patch? */
-	if (rev >= mc_amd->hdr.patch_id) {
-		c->microcode = rev;
-		uci->cpu_sig.rev = rev;
-		return 0;
-	}
+	if (rev >= mc_amd->hdr.patch_id)
+		goto out;
 
 	if (__apply_microcode_amd(mc_amd)) {
 		pr_err("CPU%d: update failed for patch_level=0x%08x\n",
 			cpu, mc_amd->hdr.patch_id);
 		return -1;
 	}
-	pr_info("CPU%d: new patch_level=0x%08x\n", cpu,
-		mc_amd->hdr.patch_id);
 
-	uci->cpu_sig.rev = mc_amd->hdr.patch_id;
-	c->microcode = mc_amd->hdr.patch_id;
+	rev = mc_amd->hdr.patch_id;
+
+	pr_info("CPU%d: new patch_level=0x%08x\n", cpu, rev);
+
+out:
+	uci->cpu_sig.rev = rev;
+	c->microcode	 = rev;
 
 	/* Update boot_cpu_data's revision too, if we're on the BSP: */
 	if (c->cpu_index == boot_cpu_data.cpu_index)
-		boot_cpu_data.microcode = mc_amd->hdr.patch_id;
+		boot_cpu_data.microcode = rev;
 
 	return 0;
 }
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -878,11 +878,8 @@ static int apply_microcode_intel(int cpu
 	 * already.
 	 */
 	rev = intel_get_microcode_revision();
-	if (rev >= mc_intel->hdr.rev) {
-		uci->cpu_sig.rev = rev;
-		c->microcode = rev;
-		return 0;
-	}
+	if (rev >= mc_intel->hdr.rev)
+		goto out;
 
 	/* write microcode via MSR 0x79 */
 	wrmsr(MSR_IA32_UCODE_WRITE,
@@ -902,8 +899,9 @@ static int apply_microcode_intel(int cpu
 		mc_intel->hdr.date >> 24,
 		(mc_intel->hdr.date >> 16) & 0xff);
 
+out:
 	uci->cpu_sig.rev = rev;
-	c->microcode = rev;
+	c->microcode	 = rev;
 
 	/* Update boot_cpu_data's revision too, if we're on the BSP: */
 	if (c->cpu_index == boot_cpu_data.cpu_index)


