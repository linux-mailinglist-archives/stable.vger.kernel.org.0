Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9301545252C
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241731AbhKPBpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:45:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:60616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241089AbhKOSSR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:18:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93793633ED;
        Mon, 15 Nov 2021 17:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998644;
        bh=MIvsRRW1Usi1s1CbWNCiDAJ1x17XL7Jh/BfF4kTqiL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VUJh1cbVDeIHPwDXZBiIbWaAUPYsssFlrgLR3zmELilqam0SMDVf16eZUXuOK09xj
         vFk9wlZjM0HWxgawJyl69KbXiqIXSWSf2OhDz6yOBINdOIy4G+tgtM/iRyvNrD0a62
         bChJGBHhegqYU9BtsHU3hoixauQ9X1Zut95MyTKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 570/575] powerpc/powernv/prd: Unregister OPAL_MSG_PRD2 notifier during module unload
Date:   Mon, 15 Nov 2021 18:04:55 +0100
Message-Id: <20211115165403.419766497@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>

commit 52862ab33c5d97490f3fa345d6529829e6d6637b upstream.

Commit 587164cd, introduced new opal message type (OPAL_MSG_PRD2) and
added opal notifier. But I missed to unregister the notifier during
module unload path. This results in below call trace if you try to
unload and load opal_prd module.

Also add new notifier_block for OPAL_MSG_PRD2 message.

Sample calltrace (modprobe -r opal_prd; modprobe opal_prd)
  BUG: Unable to handle kernel data access on read at 0xc0080000192200e0
  Faulting instruction address: 0xc00000000018d1cc
  Oops: Kernel access of bad area, sig: 11 [#1]
  LE PAGE_SIZE=64K MMU=Radix SMP NR_CPUS=2048 NUMA PowerNV
  CPU: 66 PID: 7446 Comm: modprobe Kdump: loaded Tainted: G            E     5.14.0prd #759
  NIP:  c00000000018d1cc LR: c00000000018d2a8 CTR: c0000000000cde10
  REGS: c0000003c4c0f0a0 TRAP: 0300   Tainted: G            E      (5.14.0prd)
  MSR:  9000000002009033 <SF,HV,VEC,EE,ME,IR,DR,RI,LE>  CR: 24224824  XER: 20040000
  CFAR: c00000000018d2a4 DAR: c0080000192200e0 DSISR: 40000000 IRQMASK: 1
  ...
  NIP notifier_chain_register+0x2c/0xc0
  LR  atomic_notifier_chain_register+0x48/0x80
  Call Trace:
    0xc000000002090610 (unreliable)
    atomic_notifier_chain_register+0x58/0x80
    opal_message_notifier_register+0x7c/0x1e0
    opal_prd_probe+0x84/0x150 [opal_prd]
    platform_probe+0x78/0x130
    really_probe+0x110/0x5d0
    __driver_probe_device+0x17c/0x230
    driver_probe_device+0x60/0x130
    __driver_attach+0xfc/0x220
    bus_for_each_dev+0xa8/0x130
    driver_attach+0x34/0x50
    bus_add_driver+0x1b0/0x300
    driver_register+0x98/0x1a0
    __platform_driver_register+0x38/0x50
    opal_prd_driver_init+0x34/0x50 [opal_prd]
    do_one_initcall+0x60/0x2d0
    do_init_module+0x7c/0x320
    load_module+0x3394/0x3650
    __do_sys_finit_module+0xd4/0x160
    system_call_exception+0x140/0x290
    system_call_common+0xf4/0x258

Fixes: 587164cd593c ("powerpc/powernv: Add new opal message type")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211028165716.41300-1-hegdevasant@linux.vnet.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/powernv/opal-prd.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/arch/powerpc/platforms/powernv/opal-prd.c
+++ b/arch/powerpc/platforms/powernv/opal-prd.c
@@ -372,6 +372,12 @@ static struct notifier_block opal_prd_ev
 	.priority	= 0,
 };
 
+static struct notifier_block opal_prd_event_nb2 = {
+	.notifier_call	= opal_prd_msg_notifier,
+	.next		= NULL,
+	.priority	= 0,
+};
+
 static int opal_prd_probe(struct platform_device *pdev)
 {
 	int rc;
@@ -393,9 +399,10 @@ static int opal_prd_probe(struct platfor
 		return rc;
 	}
 
-	rc = opal_message_notifier_register(OPAL_MSG_PRD2, &opal_prd_event_nb);
+	rc = opal_message_notifier_register(OPAL_MSG_PRD2, &opal_prd_event_nb2);
 	if (rc) {
 		pr_err("Couldn't register PRD2 event notifier\n");
+		opal_message_notifier_unregister(OPAL_MSG_PRD, &opal_prd_event_nb);
 		return rc;
 	}
 
@@ -404,6 +411,8 @@ static int opal_prd_probe(struct platfor
 		pr_err("failed to register miscdev\n");
 		opal_message_notifier_unregister(OPAL_MSG_PRD,
 				&opal_prd_event_nb);
+		opal_message_notifier_unregister(OPAL_MSG_PRD2,
+				&opal_prd_event_nb2);
 		return rc;
 	}
 
@@ -414,6 +423,7 @@ static int opal_prd_remove(struct platfo
 {
 	misc_deregister(&opal_prd_dev);
 	opal_message_notifier_unregister(OPAL_MSG_PRD, &opal_prd_event_nb);
+	opal_message_notifier_unregister(OPAL_MSG_PRD2, &opal_prd_event_nb2);
 	return 0;
 }
 


