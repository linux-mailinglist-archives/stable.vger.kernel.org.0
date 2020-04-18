Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8851AED48
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 15:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgDRNuw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 09:50:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbgDRNtY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 09:49:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2236B221F4;
        Sat, 18 Apr 2020 13:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587217763;
        bh=oK4kqRGGJPW2CAwiNXBLNogWEszRqkKuvhC/5JUXd5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wNwOQJSToma2ZFE9wcDywyG7fm7tgxBB+enNLfSzCU76vNw7HIO9vNi6kYoB+moNU
         /j7sj5GmvBa/dKyTXLMEPrH6D4BygTq5QY40mNFKqFixZP+ZCGXtKONlzia/F1KsBX
         6UDHeVq7IRVEyQjbOmJCyGi1kAFk16VY+8Tw52P4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yicheng Li <yichengli@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Gwendal Grignou <gwendal@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.6 54/73] platform/chrome: cros_ec: Query EC protocol version if EC transitions between RO/RW
Date:   Sat, 18 Apr 2020 09:47:56 -0400
Message-Id: <20200418134815.6519-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418134815.6519-1-sashal@kernel.org>
References: <20200418134815.6519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

