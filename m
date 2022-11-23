Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFD2F6357CD
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237886AbiKWJqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:46:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238164AbiKWJqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:46:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9C111605E
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:43:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF1E6B81E5E
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F40C433C1;
        Wed, 23 Nov 2022 09:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196590;
        bh=XftK5Rixi91U4cekeEHnOe5MKZc5P9HJgqAoaONtGkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=POZBoIMIN8RaWpzPKcGlxS4kTzzT+NLkjRLNVH+tz7W7XoBNDzaWl3hq5o1mq4guX
         Z06FSrI19nr7MuEibRoJDsUYFs9AtC1UaRmMFy72MVC9E12xS0Yfw9kLiebzhyZwP3
         Yh5AInOGRRJDgmnLoPO/HmqD8o46IKgvhKUfFDWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, YaxiongTian <iambestgod@outlook.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Etienne Carriere <etienne.carriere@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 044/314] firmware: arm_scmi: Make tx_prepare time out eventually
Date:   Wed, 23 Nov 2022 09:48:09 +0100
Message-Id: <20221123084627.523413259@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 59172b212ec0dbb97ceb5671d912e6e61fa802d5 ]

SCMI transports based on shared memory, at start of transmissions, have
to wait for the shared Tx channel area to be eventually freed by the
SCMI platform before accessing the channel. In fact the channel is owned
by the SCMI platform until marked as free by the platform itself and,
as such, cannot be used by the agent until relinquished.

As a consequence a badly misbehaving SCMI platform firmware could lock
the channel indefinitely and make the kernel side SCMI stack loop
forever waiting for such channel to be freed, possibly hanging the
whole boot sequence.

Add a timeout to the existent Tx waiting spin-loop so that, when the
system ends up in this situation, the SCMI stack can at least bail-out,
nosily warn the user, and abort the transmission.

Reported-by: YaxiongTian <iambestgod@outlook.com>
Suggested-by: YaxiongTian <iambestgod@outlook.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Etienne Carriere <etienne.carriere@linaro.org>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20221028140833.280091-3-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/common.h  |  4 +++-
 drivers/firmware/arm_scmi/driver.c  |  1 +
 drivers/firmware/arm_scmi/mailbox.c |  2 +-
 drivers/firmware/arm_scmi/optee.c   |  2 +-
 drivers/firmware/arm_scmi/shmem.c   | 31 +++++++++++++++++++++++++----
 drivers/firmware/arm_scmi/smc.c     |  2 +-
 6 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index 9b87b5b69535..a1c0154c31c6 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -118,6 +118,7 @@ void scmi_protocol_release(const struct scmi_handle *handle, u8 protocol_id);
  *
  * @dev: Reference to device in the SCMI hierarchy corresponding to this
  *	 channel
+ * @rx_timeout_ms: The configured RX timeout in milliseconds.
  * @handle: Pointer to SCMI entity handle
  * @no_completion_irq: Flag to indicate that this channel has no completion
  *		       interrupt mechanism for synchronous commands.
@@ -127,6 +128,7 @@ void scmi_protocol_release(const struct scmi_handle *handle, u8 protocol_id);
  */
 struct scmi_chan_info {
 	struct device *dev;
+	unsigned int rx_timeout_ms;
 	struct scmi_handle *handle;
 	bool no_completion_irq;
 	void *transport_info;
@@ -233,7 +235,7 @@ void scmi_free_channel(struct scmi_chan_info *cinfo, struct idr *idr, int id);
 struct scmi_shared_mem;
 
 void shmem_tx_prepare(struct scmi_shared_mem __iomem *shmem,
-		      struct scmi_xfer *xfer);
+		      struct scmi_xfer *xfer, struct scmi_chan_info *cinfo);
 u32 shmem_read_header(struct scmi_shared_mem __iomem *shmem);
 void shmem_fetch_response(struct scmi_shared_mem __iomem *shmem,
 			  struct scmi_xfer *xfer);
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 244d94eeb092..f818d00bb2c6 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2013,6 +2013,7 @@ static int scmi_chan_setup(struct scmi_info *info, struct device *dev,
 		return -ENOMEM;
 
 	cinfo->dev = dev;
+	cinfo->rx_timeout_ms = info->desc->max_rx_timeout_ms;
 
 	ret = info->desc->ops->chan_setup(cinfo, info->dev, tx);
 	if (ret)
diff --git a/drivers/firmware/arm_scmi/mailbox.c b/drivers/firmware/arm_scmi/mailbox.c
index 08ff4d110beb..1e40cb035044 100644
--- a/drivers/firmware/arm_scmi/mailbox.c
+++ b/drivers/firmware/arm_scmi/mailbox.c
@@ -36,7 +36,7 @@ static void tx_prepare(struct mbox_client *cl, void *m)
 {
 	struct scmi_mailbox *smbox = client_to_scmi_mailbox(cl);
 
-	shmem_tx_prepare(smbox->shmem, m);
+	shmem_tx_prepare(smbox->shmem, m, smbox->cinfo);
 }
 
 static void rx_callback(struct mbox_client *cl, void *m)
diff --git a/drivers/firmware/arm_scmi/optee.c b/drivers/firmware/arm_scmi/optee.c
index f42dad997ac9..2a7aeab40e54 100644
--- a/drivers/firmware/arm_scmi/optee.c
+++ b/drivers/firmware/arm_scmi/optee.c
@@ -498,7 +498,7 @@ static int scmi_optee_send_message(struct scmi_chan_info *cinfo,
 		msg_tx_prepare(channel->req.msg, xfer);
 		ret = invoke_process_msg_channel(channel, msg_command_size(xfer));
 	} else {
-		shmem_tx_prepare(channel->req.shmem, xfer);
+		shmem_tx_prepare(channel->req.shmem, xfer, cinfo);
 		ret = invoke_process_smt_channel(channel);
 	}
 
diff --git a/drivers/firmware/arm_scmi/shmem.c b/drivers/firmware/arm_scmi/shmem.c
index 0e3eaea5d852..1dfe534b8518 100644
--- a/drivers/firmware/arm_scmi/shmem.c
+++ b/drivers/firmware/arm_scmi/shmem.c
@@ -5,10 +5,13 @@
  * Copyright (C) 2019 ARM Ltd.
  */
 
+#include <linux/ktime.h>
 #include <linux/io.h>
 #include <linux/processor.h>
 #include <linux/types.h>
 
+#include <asm-generic/bug.h>
+
 #include "common.h"
 
 /*
@@ -30,16 +33,36 @@ struct scmi_shared_mem {
 };
 
 void shmem_tx_prepare(struct scmi_shared_mem __iomem *shmem,
-		      struct scmi_xfer *xfer)
+		      struct scmi_xfer *xfer, struct scmi_chan_info *cinfo)
 {
+	ktime_t stop;
+
 	/*
 	 * Ideally channel must be free by now unless OS timeout last
 	 * request and platform continued to process the same, wait
 	 * until it releases the shared memory, otherwise we may endup
-	 * overwriting its response with new message payload or vice-versa
+	 * overwriting its response with new message payload or vice-versa.
+	 * Giving up anyway after twice the expected channel timeout so as
+	 * not to bail-out on intermittent issues where the platform is
+	 * occasionally a bit slower to answer.
+	 *
+	 * Note that after a timeout is detected we bail-out and carry on but
+	 * the transport functionality is probably permanently compromised:
+	 * this is just to ease debugging and avoid complete hangs on boot
+	 * due to a misbehaving SCMI firmware.
 	 */
-	spin_until_cond(ioread32(&shmem->channel_status) &
-			SCMI_SHMEM_CHAN_STAT_CHANNEL_FREE);
+	stop = ktime_add_ms(ktime_get(), 2 * cinfo->rx_timeout_ms);
+	spin_until_cond((ioread32(&shmem->channel_status) &
+			 SCMI_SHMEM_CHAN_STAT_CHANNEL_FREE) ||
+			 ktime_after(ktime_get(), stop));
+	if (!(ioread32(&shmem->channel_status) &
+	      SCMI_SHMEM_CHAN_STAT_CHANNEL_FREE)) {
+		WARN_ON_ONCE(1);
+		dev_err(cinfo->dev,
+			"Timeout waiting for a free TX channel !\n");
+		return;
+	}
+
 	/* Mark channel busy + clear error */
 	iowrite32(0x0, &shmem->channel_status);
 	iowrite32(xfer->hdr.poll_completion ? 0 : SCMI_SHMEM_FLAG_INTR_ENABLED,
diff --git a/drivers/firmware/arm_scmi/smc.c b/drivers/firmware/arm_scmi/smc.c
index 745acfdd0b3d..87a7b13cf868 100644
--- a/drivers/firmware/arm_scmi/smc.c
+++ b/drivers/firmware/arm_scmi/smc.c
@@ -188,7 +188,7 @@ static int smc_send_message(struct scmi_chan_info *cinfo,
 	 */
 	smc_channel_lock_acquire(scmi_info, xfer);
 
-	shmem_tx_prepare(scmi_info->shmem, xfer);
+	shmem_tx_prepare(scmi_info->shmem, xfer, cinfo);
 
 	arm_smccc_1_1_invoke(scmi_info->func_id, 0, 0, 0, 0, 0, 0, 0, &res);
 
-- 
2.35.1



