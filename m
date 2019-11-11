Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24FC1F6E8D
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 07:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfKKGaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 01:30:11 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:39515 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726360AbfKKGaL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 01:30:11 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id D220A60E;
        Mon, 11 Nov 2019 01:30:09 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 11 Nov 2019 01:30:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Eh4Phe
        6GfyvUqxuBlnaxVqCUgp+t6RDNdg34HVoheeg=; b=d+SHQrEpGueHlylVVr043b
        ajaXlBVArHSlk0gv90j4gte5ECG0mt7nHigKqK+NjGcLtl7S+fa04ncyehaOYX91
        k05LWFhzBueU40Y85B5SEZ3b7z/ThxkwoJRP/gi74qQadJPRWsOZ0LUUyTQVd6K4
        G96r6AAICrsowt7Oj7O2P/VHGDcp2lc888LmZP3kv+Ajxrxx1h4sgMJvB8ey0RD2
        Cmhtvbub3gOsX8a7UWAY44dabLEnF3M5NmAibMCyMckFftDsbM9yegFRhkdgfxau
        wlnVESXBeygZdZNbHbgwO9Ta/lcTKBRT9U/Qs7cjUAWwvSFCTl+pojkk47G+hjFw
        ==
X-ME-Sender: <xms:8f_IXanOgTUD7YPyaV_VOnYh1Qf8mzLH9BHI7AITiwwbBgSanvgVWw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddviedgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:8f_IXYT1hoOv-HqwQUc-dkyF4SzKyxgDdCu7EbMlUTEU7Ly-NAJJ2g>
    <xmx:8f_IXWLVydicIve8IKKFQeukl3i-r3ArblCpxskWX7NCGNO8qEanOQ>
    <xmx:8f_IXW_0t9QJAIXeXvh0bc53r9sKViA7dmESU0tHphstL-Tzzz22Xg>
    <xmx:8f_IXYIg_Twz34T-JyrB8-YhYFayuQDVboQfHQ5JMBnzlHaR0XDpFA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EF8558006F;
        Mon, 11 Nov 2019 01:30:08 -0500 (EST)
Subject: FAILED: patch "[PATCH] x86/apic/32: Avoid bogus LDR warnings" failed to apply to 4.9-stable tree
To:     jbeulich@suse.com, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Nov 2019 07:29:59 +0100
Message-ID: <1573453799136159@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fe6f85ca121e9c74e7490fe66b0c5aae38e332c3 Mon Sep 17 00:00:00 2001
From: Jan Beulich <jbeulich@suse.com>
Date: Tue, 29 Oct 2019 10:34:19 +0100
Subject: [PATCH] x86/apic/32: Avoid bogus LDR warnings

The removal of the LDR initialization in the bigsmp_32 APIC code unearthed
a problem in setup_local_APIC().

The code checks unconditionally for a mismatch of the logical APIC id by
comparing the early APIC id which was initialized in get_smp_config() with
the actual LDR value in the APIC.

Due to the removal of the bogus LDR initialization the check now can
trigger on bigsmp_32 APIC systems emitting a warning for every booting
CPU. This is of course a false positive because the APIC is not using
logical destination mode.

Restrict the check and the possibly resulting fixup to systems which are
actually using the APIC in logical destination mode.

[ tglx: Massaged changelog and added Cc stable ]

Fixes: bae3a8d3308 ("x86/apic: Do not initialize LDR and DFR for bigsmp")
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/666d8f91-b5a8-1afd-7add-821e72a35f03@suse.com

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 9e2dd2b296cd..2b0faf86da1b 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1586,9 +1586,6 @@ static void setup_local_APIC(void)
 {
 	int cpu = smp_processor_id();
 	unsigned int value;
-#ifdef CONFIG_X86_32
-	int logical_apicid, ldr_apicid;
-#endif
 
 	if (disable_apic) {
 		disable_ioapic_support();
@@ -1626,16 +1623,21 @@ static void setup_local_APIC(void)
 	apic->init_apic_ldr();
 
 #ifdef CONFIG_X86_32
-	/*
-	 * APIC LDR is initialized.  If logical_apicid mapping was
-	 * initialized during get_smp_config(), make sure it matches the
-	 * actual value.
-	 */
-	logical_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
-	ldr_apicid = GET_APIC_LOGICAL_ID(apic_read(APIC_LDR));
-	WARN_ON(logical_apicid != BAD_APICID && logical_apicid != ldr_apicid);
-	/* always use the value from LDR */
-	early_per_cpu(x86_cpu_to_logical_apicid, cpu) = ldr_apicid;
+	if (apic->dest_logical) {
+		int logical_apicid, ldr_apicid;
+
+		/*
+		 * APIC LDR is initialized.  If logical_apicid mapping was
+		 * initialized during get_smp_config(), make sure it matches
+		 * the actual value.
+		 */
+		logical_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
+		ldr_apicid = GET_APIC_LOGICAL_ID(apic_read(APIC_LDR));
+		if (logical_apicid != BAD_APICID)
+			WARN_ON(logical_apicid != ldr_apicid);
+		/* Always use the value from LDR. */
+		early_per_cpu(x86_cpu_to_logical_apicid, cpu) = ldr_apicid;
+	}
 #endif
 
 	/*

