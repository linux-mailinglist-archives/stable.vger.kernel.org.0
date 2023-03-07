Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55BD96AF1D0
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbjCGSro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:47:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233171AbjCGSrR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:47:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2648391B62
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:36:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 408F661543
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D53C433D2;
        Tue,  7 Mar 2023 18:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214185;
        bh=+fVs9usZtIFnqGAOOm9jUMFZ7lqzeabQSEA/+2iYn+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQUjJ4CIDnwyvWBLx7gCWziZRx+ukrtvfznKi9b0E7s1B1Y5r7DnvBuP/Nw8mnlIr
         kUk3jzMcRyc08tX6JeqLFtz9/IM8MplT7xi6sIMjdQ9mx3/Da4aMGgFv+i4qSGHBx1
         nlu5RBTBXgMx+MynQvu3cULt4f95RBuvAcSDYfW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 733/885] x86/reboot: Disable SVM, not just VMX, when stopping CPUs
Date:   Tue,  7 Mar 2023 18:01:07 +0100
Message-Id: <20230307170033.835173607@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit a2b07fa7b93321c059af0c6d492cc9a4f1e390aa upstream.

Disable SVM and more importantly force GIF=1 when halting a CPU or
rebooting the machine.  Similar to VMX, SVM allows software to block
INITs via CLGI, and thus can be problematic for a crash/reboot.  The
window for failure is smaller with SVM as INIT is only blocked while
GIF=0, i.e. between CLGI and STGI, but the window does exist.

Fixes: fba4f472b33a ("x86/reboot: Turn off KVM when halting a CPU")
Cc: stable@vger.kernel.org
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20221130233650.1404148-5-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/smp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -32,7 +32,7 @@
 #include <asm/mce.h>
 #include <asm/trace/irq_vectors.h>
 #include <asm/kexec.h>
-#include <asm/virtext.h>
+#include <asm/reboot.h>
 
 /*
  *	Some notes on x86 processor bugs affecting SMP operation:
@@ -122,7 +122,7 @@ static int smp_stop_nmi_callback(unsigne
 	if (raw_smp_processor_id() == atomic_read(&stopping_cpu))
 		return NMI_HANDLED;
 
-	cpu_emergency_vmxoff();
+	cpu_emergency_disable_virtualization();
 	stop_this_cpu(NULL);
 
 	return NMI_HANDLED;
@@ -134,7 +134,7 @@ static int smp_stop_nmi_callback(unsigne
 DEFINE_IDTENTRY_SYSVEC(sysvec_reboot)
 {
 	ack_APIC_irq();
-	cpu_emergency_vmxoff();
+	cpu_emergency_disable_virtualization();
 	stop_this_cpu(NULL);
 }
 


