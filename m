Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC0B1B3E9F
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730753AbgDVK3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:29:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730769AbgDVK0x (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:26:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDF932071E;
        Wed, 22 Apr 2020 10:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551212;
        bh=oK4kqRGGJPW2CAwiNXBLNogWEszRqkKuvhC/5JUXd5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XM7vA2cGJYL1oaijp1d9P/MLz1tON9ukGsJKSzBgWvAqpDEL9wVRokvUGkuLtez0R
         xHjQqruW1nLSGYPq4xMdFIAiVTm71CvPHN3soBhIsAtD4io3f7oGCZk/zPX8BIpPSr
         I/PGks0toRpFUzQZ2Xx9ayfvzCbTzFSaMQI5Ph8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yicheng Li <yichengli@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Gwendal Grignou <gwendal@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 145/166] platform/chrome: cros_ec: Query EC protocol version if EC transitions between RO/RW
Date:   Wed, 22 Apr 2020 11:57:52 +0200
Message-Id: <20200422095104.180569258@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yicheng Li <yichengli@chromium.org>

[ Upstream commit 42cd0ab476e2daffc23982c37822a78f9a53cdd5 ]

RO and RW of EC may have different EC protocol version. If EC transitions
between RO and RW, but AP does not reboot (this is true for fingerprint
microcontroller / cros_fp, but not true for main ec / cros_ec), the AP
still uses the protocol version queried before transition, which can
cause problems. In the case of fingerprint microcontroller, this causes
AP to send the wrong version of EC_CMD_GET_NEXT_EVENT to RO in the
interrupt handler, which in turn prevents RO to clear the interrupt
line to AP, in an infinite loop.

Once an EC_HOST_EVENT_INTERFACE_READY is received, we know that there
might have been a transition between RO and RW, so re-query the protocol.

Signed-off-by: Yicheng Li <yichengli@chromium.org>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Gwendal Grignou <gwendal@chromium.org>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec.c           | 30 +++++++++++++++++++++
 include/linux/platform_data/cros_ec_proto.h |  4 +++
 2 files changed, 34 insertions(+)

diff --git a/drivers/platform/chrome/cros_ec.c b/drivers/platform/chrome/cros_ec.c
index 6fc8f2c3ac517..7ee43b2e0654a 100644
--- a/drivers/platform/chrome/cros_ec.c
+++ b/drivers/platform/chrome/cros_ec.c
@@ -138,6 +138,24 @@ static int cros_ec_sleep_event(struct cros_ec_device *ec_dev, u8 sleep_event)
 	return ret;
 }
 
+static int cros_ec_ready_event(struct notifier_block *nb,
+			       unsigned long queued_during_suspend,
+			       void *_notify)
+{
+	struct cros_ec_device *ec_dev = container_of(nb, struct cros_ec_device,
+						     notifier_ready);
+	u32 host_event = cros_ec_get_host_event(ec_dev);
+
+	if (host_event & EC_HOST_EVENT_MASK(EC_HOST_EVENT_INTERFACE_READY)) {
+		mutex_lock(&ec_dev->lock);
+		cros_ec_query_all(ec_dev);
+		mutex_unlock(&ec_dev->lock);
+		return NOTIFY_OK;
+	}
+
+	return NOTIFY_DONE;
+}
+
 /**
  * cros_ec_register() - Register a new ChromeOS EC, using the provided info.
  * @ec_dev: Device to register.
@@ -237,6 +255,18 @@ int cros_ec_register(struct cros_ec_device *ec_dev)
 		dev_dbg(ec_dev->dev, "Error %d clearing sleep event to ec",
 			err);
 
+	if (ec_dev->mkbp_event_supported) {
+		/*
+		 * Register the notifier for EC_HOST_EVENT_INTERFACE_READY
+		 * event.
+		 */
+		ec_dev->notifier_ready.notifier_call = cros_ec_ready_event;
+		err = blocking_notifier_chain_register(&ec_dev->event_notifier,
+						      &ec_dev->notifier_ready);
+		if (err)
+			return err;
+	}
+
 	dev_info(dev, "Chrome EC device registered\n");
 
 	return 0;
diff --git a/include/linux/platform_data/cros_ec_proto.h b/include/linux/platform_data/cros_ec_proto.h
index ba59147701918..3832433266762 100644
--- a/include/linux/platform_data/cros_ec_proto.h
+++ b/include/linux/platform_data/cros_ec_proto.h
@@ -125,6 +125,9 @@ struct cros_ec_command {
  * @host_event_wake_mask: Mask of host events that cause wake from suspend.
  * @last_event_time: exact time from the hard irq when we got notified of
  *     a new event.
+ * @notifier_ready: The notifier_block to let the kernel re-query EC
+ *		    communication protocol when the EC sends
+ *		    EC_HOST_EVENT_INTERFACE_READY.
  * @ec: The platform_device used by the mfd driver to interface with the
  *      main EC.
  * @pd: The platform_device used by the mfd driver to interface with the
@@ -166,6 +169,7 @@ struct cros_ec_device {
 	u32 host_event_wake_mask;
 	u32 last_resume_result;
 	ktime_t last_event_time;
+	struct notifier_block notifier_ready;
 
 	/* The platform devices used by the mfd driver */
 	struct platform_device *ec;
-- 
2.20.1



