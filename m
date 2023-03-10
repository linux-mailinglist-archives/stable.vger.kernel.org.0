Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 190026B4126
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbjCJNuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:50:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbjCJNuA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:50:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CF5EB8AC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:49:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA0B4616F0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDDC4C433EF;
        Fri, 10 Mar 2023 13:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456194;
        bh=3ESICwBBXTPzePQ57qR1TG39JF5H3fr/JWZ32Y25Y3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A0MFidAj2Z5D35sXFIhg5GHBA52z4pT8t1aHIHVKIpW8Ctt4k/VQRp/0wBCvK/o3U
         0lCR0Ja85QYwUqnkTpdTbtbpjCu8lPiDXTwHJsRCo3AS6mktLg0FLPZrB/+IAxnagc
         neWK1GpMWDpJCItAoNEYClvqJUfnr+RkzTE3pKpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 4.14 113/193] x86/reboot: Disable virtualization in an emergency if SVM is supported
Date:   Fri, 10 Mar 2023 14:38:15 +0100
Message-Id: <20230310133715.046347424@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit d81f952aa657b76cea381384bef1fea35c5fd266 upstream.

Disable SVM on all CPUs via NMI shootdown during an emergency reboot.
Like VMX, SVM can block INIT, e.g. if the emergency reboot is triggered
between CLGI and STGI, and thus can prevent bringing up other CPUs via
INIT-SIPI-SIPI.

Cc: stable@vger.kernel.org
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20221130233650.1404148-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/reboot.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -538,27 +538,26 @@ static inline void kb_wait(void)
 
 static inline void nmi_shootdown_cpus_on_restart(void);
 
-/* Use NMIs as IPIs to tell all CPUs to disable virtualization */
-static void emergency_vmx_disable_all(void)
+static void emergency_reboot_disable_virtualization(void)
 {
 	/* Just make sure we won't change CPUs while doing this */
 	local_irq_disable();
 
 	/*
-	 * Disable VMX on all CPUs before rebooting, otherwise we risk hanging
-	 * the machine, because the CPU blocks INIT when it's in VMX root.
+	 * Disable virtualization on all CPUs before rebooting to avoid hanging
+	 * the system, as VMX and SVM block INIT when running in the host.
 	 *
 	 * We can't take any locks and we may be on an inconsistent state, so
-	 * use NMIs as IPIs to tell the other CPUs to exit VMX root and halt.
+	 * use NMIs as IPIs to tell the other CPUs to disable VMX/SVM and halt.
 	 *
-	 * Do the NMI shootdown even if VMX if off on _this_ CPU, as that
-	 * doesn't prevent a different CPU from being in VMX root operation.
+	 * Do the NMI shootdown even if virtualization is off on _this_ CPU, as
+	 * other CPUs may have virtualization enabled.
 	 */
-	if (cpu_has_vmx()) {
-		/* Safely force _this_ CPU out of VMX root operation. */
-		__cpu_emergency_vmxoff();
+	if (cpu_has_vmx() || cpu_has_svm(NULL)) {
+		/* Safely force _this_ CPU out of VMX/SVM operation. */
+		cpu_emergency_disable_virtualization();
 
-		/* Halt and exit VMX root operation on the other CPUs. */
+		/* Disable VMX/SVM and halt on other CPUs. */
 		nmi_shootdown_cpus_on_restart();
 
 	}
@@ -596,7 +595,7 @@ static void native_machine_emergency_res
 	unsigned short mode;
 
 	if (reboot_emergency)
-		emergency_vmx_disable_all();
+		emergency_reboot_disable_virtualization();
 
 	tboot_shutdown(TB_SHUTDOWN_REBOOT);
 


