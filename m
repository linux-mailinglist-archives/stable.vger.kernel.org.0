Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D66320141A
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389810AbgFSQIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:08:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391197AbgFSPHz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:07:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C886321852;
        Fri, 19 Jun 2020 15:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579274;
        bh=jYkCu1hBCnJrUV8iVaC1T+sZsEv9uVaPU2WsbjJeBdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e5H68TBJytfcZaiM7lAGXB084r3dZdLsFeSa+tvXTt4OMOtb9CGFq1Rk/tiE/NCqK
         zqMjQ/y/kHgqqWgjlVtRNmMLq/Aprg42++1fhrXlF7ebpavcx5zewggdaieEFWImPF
         CItI+cc5fsKOe4K4leVVKuvtWtKNz4j3T0GRDawo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/261] Drivers: hv: vmbus: Always handle the VMBus messages on CPU0
Date:   Fri, 19 Jun 2020 16:31:25 +0200
Message-Id: <20200619141653.442322436@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Parri (Microsoft) <parri.andrea@gmail.com>

[ Upstream commit 8a857c55420f29da4fc131adc22b12d474c48f4c ]

A Linux guest have to pick a "connect CPU" to communicate with the
Hyper-V host.  This CPU can not be taken offline because Hyper-V does
not provide a way to change that CPU assignment.

Current code sets the connect CPU to whatever CPU ends up running the
function vmbus_negotiate_version(), and this will generate problems if
that CPU is taken offine.

Establish CPU0 as the connect CPU, and add logics to prevents the
connect CPU from being taken offline.   We could pick some other CPU,
and we could pick that "other CPU" dynamically if there was a reason to
do so at some point in the future.  But for now, #defining the connect
CPU to 0 is the most straightforward and least complex solution.

While on this, add inline comments explaining "why" offer and rescind
messages should not be handled by a same serialized work queue.

Suggested-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Link: https://lore.kernel.org/r/20200406001514.19876-2-parri.andrea@gmail.com
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/connection.c   | 20 +-------------------
 drivers/hv/hv.c           |  7 +++++++
 drivers/hv/hyperv_vmbus.h | 11 ++++++-----
 drivers/hv/vmbus_drv.c    | 20 +++++++++++++++++---
 4 files changed, 31 insertions(+), 27 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 6e4c015783ff..c90d79096e8c 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -67,7 +67,6 @@ static __u32 vmbus_get_next_version(__u32 current_version)
 int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo, u32 version)
 {
 	int ret = 0;
-	unsigned int cur_cpu;
 	struct vmbus_channel_initiate_contact *msg;
 	unsigned long flags;
 
@@ -100,24 +99,7 @@ int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo, u32 version)
 
 	msg->monitor_page1 = virt_to_phys(vmbus_connection.monitor_pages[0]);
 	msg->monitor_page2 = virt_to_phys(vmbus_connection.monitor_pages[1]);
-	/*
-	 * We want all channel messages to be delivered on CPU 0.
-	 * This has been the behavior pre-win8. This is not
-	 * perf issue and having all channel messages delivered on CPU 0
-	 * would be ok.
-	 * For post win8 hosts, we support receiving channel messagges on
-	 * all the CPUs. This is needed for kexec to work correctly where
-	 * the CPU attempting to connect may not be CPU 0.
-	 */
-	if (version >= VERSION_WIN8_1) {
-		cur_cpu = get_cpu();
-		msg->target_vcpu = hv_cpu_number_to_vp_number(cur_cpu);
-		vmbus_connection.connect_cpu = cur_cpu;
-		put_cpu();
-	} else {
-		msg->target_vcpu = 0;
-		vmbus_connection.connect_cpu = 0;
-	}
+	msg->target_vcpu = hv_cpu_number_to_vp_number(VMBUS_CONNECT_CPU);
 
 	/*
 	 * Add to list before we send the request since we may
diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index fcc52797c169..d6320022af15 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -249,6 +249,13 @@ int hv_synic_cleanup(unsigned int cpu)
 	bool channel_found = false;
 	unsigned long flags;
 
+	/*
+	 * Hyper-V does not provide a way to change the connect CPU once
+	 * it is set; we must prevent the connect CPU from going offline.
+	 */
+	if (cpu == VMBUS_CONNECT_CPU)
+		return -EBUSY;
+
 	/*
 	 * Search for channels which are bound to the CPU we're about to
 	 * cleanup. In case we find one and vmbus is still connected we need to
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index af9379a3bf89..cabcb66e7c5e 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -212,12 +212,13 @@ enum vmbus_connect_state {
 
 #define MAX_SIZE_CHANNEL_MESSAGE	HV_MESSAGE_PAYLOAD_BYTE_COUNT
 
-struct vmbus_connection {
-	/*
-	 * CPU on which the initial host contact was made.
-	 */
-	int connect_cpu;
+/*
+ * The CPU that Hyper-V will interrupt for VMBUS messages, such as
+ * CHANNELMSG_OFFERCHANNEL and CHANNELMSG_RESCIND_CHANNELOFFER.
+ */
+#define VMBUS_CONNECT_CPU	0
 
+struct vmbus_connection {
 	u32 msg_conn_id;
 
 	atomic_t offer_in_progress;
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 9cdd434bb340..160ff640485b 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1092,14 +1092,28 @@ void vmbus_on_msg_dpc(unsigned long data)
 			/*
 			 * If we are handling the rescind message;
 			 * schedule the work on the global work queue.
+			 *
+			 * The OFFER message and the RESCIND message should
+			 * not be handled by the same serialized work queue,
+			 * because the OFFER handler may call vmbus_open(),
+			 * which tries to open the channel by sending an
+			 * OPEN_CHANNEL message to the host and waits for
+			 * the host's response; however, if the host has
+			 * rescinded the channel before it receives the
+			 * OPEN_CHANNEL message, the host just silently
+			 * ignores the OPEN_CHANNEL message; as a result,
+			 * the guest's OFFER handler hangs for ever, if we
+			 * handle the RESCIND message in the same serialized
+			 * work queue: the RESCIND handler can not start to
+			 * run before the OFFER handler finishes.
 			 */
-			schedule_work_on(vmbus_connection.connect_cpu,
+			schedule_work_on(VMBUS_CONNECT_CPU,
 					 &ctx->work);
 			break;
 
 		case CHANNELMSG_OFFERCHANNEL:
 			atomic_inc(&vmbus_connection.offer_in_progress);
-			queue_work_on(vmbus_connection.connect_cpu,
+			queue_work_on(VMBUS_CONNECT_CPU,
 				      vmbus_connection.work_queue,
 				      &ctx->work);
 			break;
@@ -1146,7 +1160,7 @@ static void vmbus_force_channel_rescinded(struct vmbus_channel *channel)
 
 	INIT_WORK(&ctx->work, vmbus_onmessage_work);
 
-	queue_work_on(vmbus_connection.connect_cpu,
+	queue_work_on(VMBUS_CONNECT_CPU,
 		      vmbus_connection.work_queue,
 		      &ctx->work);
 }
-- 
2.25.1



