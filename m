Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998081B3D9E
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729775AbgDVKQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:16:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729772AbgDVKQo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:16:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D47102076B;
        Wed, 22 Apr 2020 10:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550603;
        bh=5kB55+Q5g37dANj2uahwxtaTN4x+h1sIiK9+c6nIWog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tkzKucF9SLOAhWtuCI6F6Ty5B8+WHcBDajUzeuVFmelk5CKhPt46OZLWc0J6FN7M/
         cF0mV+lmmznt89TKZCOVbQ0+3z+ZemAQWacc8qFSu0MG30JRdaDzcdmpQyBeNiab4b
         y7WA9/U6D8LIP+MHmhQA9aQUAW7dYE9ZywoCH304=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 5.4 019/118] x86/Hyper-V: Unload vmbus channel in hv panic callback
Date:   Wed, 22 Apr 2020 11:56:20 +0200
Message-Id: <20200422095034.726540343@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

commit 74347a99e73ae00b8385f1209aaea193c670f901 upstream.

When kdump is not configured, a Hyper-V VM might still respond to
network traffic after a kernel panic when kernel parameter panic=0.
The panic CPU goes into an infinite loop with interrupts enabled,
and the VMbus driver interrupt handler still works because the
VMbus connection is unloaded only in the kdump path.  The network
responses make the other end of the connection think the VM is
still functional even though it has panic'ed, which could affect any
failover actions that should be taken.

Fix this by unloading the VMbus connection during the panic process.
vmbus_initiate_unload() could then be called twice (e.g., by
hyperv_panic_event() and hv_crash_handler(), so reset the connection
state in vmbus_initiate_unload() to ensure the unload is done only
once.

Fixes: 81b18bce48af ("Drivers: HV: Send one page worth of kmsg dump over Hyper-V during panic")
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
Link: https://lore.kernel.org/r/20200406155331.2105-2-Tianyu.Lan@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hv/channel_mgmt.c |    3 +++
 drivers/hv/vmbus_drv.c    |   21 +++++++++++++--------
 2 files changed, 16 insertions(+), 8 deletions(-)

--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -839,6 +839,9 @@ void vmbus_initiate_unload(bool crash)
 {
 	struct vmbus_channel_message_header hdr;
 
+	if (xchg(&vmbus_connection.conn_state, DISCONNECTED) == DISCONNECTED)
+		return;
+
 	/* Pre-Win2012R2 hosts don't support reconnect */
 	if (vmbus_proto_version < VERSION_WIN8_1)
 		return;
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -53,9 +53,12 @@ static int hyperv_panic_event(struct not
 {
 	struct pt_regs *regs;
 
-	regs = current_pt_regs();
+	vmbus_initiate_unload(true);
 
-	hyperv_report_panic(regs, val);
+	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE) {
+		regs = current_pt_regs();
+		hyperv_report_panic(regs, val);
+	}
 	return NOTIFY_DONE;
 }
 
@@ -1389,10 +1392,16 @@ static int vmbus_bus_init(void)
 		}
 
 		register_die_notifier(&hyperv_die_block);
-		atomic_notifier_chain_register(&panic_notifier_list,
-					       &hyperv_panic_block);
 	}
 
+	/*
+	 * Always register the panic notifier because we need to unload
+	 * the VMbus channel connection to prevent any VMbus
+	 * activity after the VM panics.
+	 */
+	atomic_notifier_chain_register(&panic_notifier_list,
+			       &hyperv_panic_block);
+
 	vmbus_request_offers();
 
 	return 0;
@@ -2202,8 +2211,6 @@ static int vmbus_bus_suspend(struct devi
 
 	vmbus_initiate_unload(false);
 
-	vmbus_connection.conn_state = DISCONNECTED;
-
 	/* Reset the event for the next resume. */
 	reinit_completion(&vmbus_connection.ready_for_resume_event);
 
@@ -2288,7 +2295,6 @@ static void hv_kexec_handler(void)
 {
 	hv_stimer_global_cleanup();
 	vmbus_initiate_unload(false);
-	vmbus_connection.conn_state = DISCONNECTED;
 	/* Make sure conn_state is set as hv_synic_cleanup checks for it */
 	mb();
 	cpuhp_remove_state(hyperv_cpuhp_online);
@@ -2305,7 +2311,6 @@ static void hv_crash_handler(struct pt_r
 	 * doing the cleanup for current CPU only. This should be sufficient
 	 * for kdump.
 	 */
-	vmbus_connection.conn_state = DISCONNECTED;
 	cpu = smp_processor_id();
 	hv_stimer_cleanup(cpu);
 	hv_synic_disable_regs(cpu);


