Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1A31AA0B9
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369494AbgDOMal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:30:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406054AbgDOLou (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:44:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D8F820732;
        Wed, 15 Apr 2020 11:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951074;
        bh=MuIOjmunTWEFlt5HQIFx2mjqJzIGMAOGls5X8CybAR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTSiitbuCvm4bRJ8tLkreLAgjXtnxhcXjjRJCjF6Lg73QWE0dar4qWGsGC+WtHRKA
         jwlqSF41DjQLJrGLELZqwdAuR4dwkiGUPfDE6L4/UligcvwjDpEu2Av+lIRLwliczW
         wNEshZ0zCqG0hB4qW1YVSdmYkxpzQ9XYAwExQDbI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yicheng Li <yichengli@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Gwendal Grignou <gwendal@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 106/106] platform/chrome: cros_ec: Query EC protocol version if EC transitions between RO/RW
Date:   Wed, 15 Apr 2020 07:42:26 -0400
Message-Id: <20200415114226.13103-106-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114226.13103-1-sashal@kernel.org>
References: <20200415114226.13103-1-sashal@kernel.org>
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
index 6d6ce86a1408a..e5e1bbb270914 100644
--- a/drivers/platform/chrome/cros_ec.c
+++ b/drivers/platform/chrome/cros_ec.c
@@ -137,6 +137,24 @@ static int cros_ec_sleep_event(struct cros_ec_device *ec_dev, u8 sleep_event)
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
@@ -236,6 +254,18 @@ int cros_ec_register(struct cros_ec_device *ec_dev)
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
index 30098a5515231..e6af1b4a7cbcf 100644
--- a/include/linux/platform_data/cros_ec_proto.h
+++ b/include/linux/platform_data/cros_ec_proto.h
@@ -126,6 +126,9 @@ struct cros_ec_command {
  * @host_event_wake_mask: Mask of host events that cause wake from suspend.
  * @last_event_time: exact time from the hard irq when we got notified of
  *     a new event.
+ * @notifier_ready: The notifier_block to let the kernel re-query EC
+ *		    communication protocol when the EC sends
+ *		    EC_HOST_EVENT_INTERFACE_READY.
  * @ec: The platform_device used by the mfd driver to interface with the
  *      main EC.
  * @pd: The platform_device used by the mfd driver to interface with the
@@ -167,6 +170,7 @@ struct cros_ec_device {
 	u32 host_event_wake_mask;
 	u32 last_resume_result;
 	ktime_t last_event_time;
+	struct notifier_block notifier_ready;
 
 	/* The platform devices used by the mfd driver */
 	struct platform_device *ec;
-- 
2.20.1

