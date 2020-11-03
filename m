Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 137222A57B4
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730596AbgKCVpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:45:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:50944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731367AbgKCUxQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:53:16 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A8752053B;
        Tue,  3 Nov 2020 20:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436795;
        bh=gM1YoWADvmm5lSFIjXGNj1m13WGMFH8QDdVQiikhN7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2bl3JIQjvZyTBocjpU/T/O9/vPXwFmXkr3kE8WCGkNYNunZvjnMypoIyKAD/k3dt8
         lCnFxIqhCzomxG0nlFVwW67YozDDFRThSypvark3sq0d+/QNrOghFWSQXmtBHNvbyR
         +Gmv606GPGbgxEgxNLTXb3pGdUeOU69S+fwwsDFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Etienne Carriere <etienne.carriere@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 015/214] firmware: arm_scmi: Add missing Rx size re-initialisation
Date:   Tue,  3 Nov 2020 21:34:23 +0100
Message-Id: <20201103203251.215361383@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 9724722fde8f9bbd2b87340f00b9300c9284001e ]

Few commands provide the list of description partially and require
to be called consecutively until all the descriptors are fetched
completely. In such cases, we don't release the buffers and reuse
them for consecutive transmits.

However, currently we don't reset the Rx size which will be set as
per the response for the last transmit. This may result in incorrect
response size being interpretted as the firmware may repond with size
greater than the one set but we read only upto the size set by previous
response.

Let us reset the receive buffer size to max possible in such cases as
we don't know the exact size of the response.

Link:  https://lore.kernel.org/r/20201012141746.32575-1-sudeep.holla@arm.com
Fixes: b6f20ff8bd94 ("firmware: arm_scmi: add common infrastructure and support for base protocol")
Reported-by: Etienne Carriere <etienne.carriere@linaro.org>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/base.c    | 2 ++
 drivers/firmware/arm_scmi/clock.c   | 2 ++
 drivers/firmware/arm_scmi/common.h  | 2 ++
 drivers/firmware/arm_scmi/driver.c  | 8 ++++++++
 drivers/firmware/arm_scmi/perf.c    | 2 ++
 drivers/firmware/arm_scmi/sensors.c | 2 ++
 6 files changed, 18 insertions(+)

diff --git a/drivers/firmware/arm_scmi/base.c b/drivers/firmware/arm_scmi/base.c
index f804e8af6521b..f986ee8919f03 100644
--- a/drivers/firmware/arm_scmi/base.c
+++ b/drivers/firmware/arm_scmi/base.c
@@ -173,6 +173,8 @@ static int scmi_base_implementation_list_get(const struct scmi_handle *handle,
 			protocols_imp[tot_num_ret + loop] = *(list + loop);
 
 		tot_num_ret += loop_num_ret;
+
+		scmi_reset_rx_to_maxsz(handle, t);
 	} while (loop_num_ret);
 
 	scmi_xfer_put(handle, t);
diff --git a/drivers/firmware/arm_scmi/clock.c b/drivers/firmware/arm_scmi/clock.c
index 32526a793f3ac..38400a8d0ca89 100644
--- a/drivers/firmware/arm_scmi/clock.c
+++ b/drivers/firmware/arm_scmi/clock.c
@@ -177,6 +177,8 @@ scmi_clock_describe_rates_get(const struct scmi_handle *handle, u32 clk_id,
 		}
 
 		tot_rate_cnt += num_returned;
+
+		scmi_reset_rx_to_maxsz(handle, t);
 		/*
 		 * check for both returned and remaining to avoid infinite
 		 * loop due to buggy firmware
diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index 5237c2ff79fea..9a680b9af9e58 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -103,6 +103,8 @@ int scmi_do_xfer_with_response(const struct scmi_handle *h,
 			       struct scmi_xfer *xfer);
 int scmi_xfer_get_init(const struct scmi_handle *h, u8 msg_id, u8 prot_id,
 		       size_t tx_size, size_t rx_size, struct scmi_xfer **p);
+void scmi_reset_rx_to_maxsz(const struct scmi_handle *handle,
+			    struct scmi_xfer *xfer);
 int scmi_handle_put(const struct scmi_handle *handle);
 struct scmi_handle *scmi_handle_get(struct device *dev);
 void scmi_set_handle(struct scmi_device *scmi_dev);
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 3eb0382491ceb..11078199abed3 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -481,6 +481,14 @@ int scmi_do_xfer(const struct scmi_handle *handle, struct scmi_xfer *xfer)
 	return ret;
 }
 
+void scmi_reset_rx_to_maxsz(const struct scmi_handle *handle,
+			    struct scmi_xfer *xfer)
+{
+	struct scmi_info *info = handle_to_scmi_info(handle);
+
+	xfer->rx.len = info->desc->max_msg_size;
+}
+
 #define SCMI_MAX_RESPONSE_TIMEOUT	(2 * MSEC_PER_SEC)
 
 /**
diff --git a/drivers/firmware/arm_scmi/perf.c b/drivers/firmware/arm_scmi/perf.c
index 601af4edad5e6..129a2887e964f 100644
--- a/drivers/firmware/arm_scmi/perf.c
+++ b/drivers/firmware/arm_scmi/perf.c
@@ -281,6 +281,8 @@ scmi_perf_describe_levels_get(const struct scmi_handle *handle, u32 domain,
 		}
 
 		tot_opp_cnt += num_returned;
+
+		scmi_reset_rx_to_maxsz(handle, t);
 		/*
 		 * check for both returned and remaining to avoid infinite
 		 * loop due to buggy firmware
diff --git a/drivers/firmware/arm_scmi/sensors.c b/drivers/firmware/arm_scmi/sensors.c
index a400ea805fc23..931208bc48f12 100644
--- a/drivers/firmware/arm_scmi/sensors.c
+++ b/drivers/firmware/arm_scmi/sensors.c
@@ -154,6 +154,8 @@ static int scmi_sensor_description_get(const struct scmi_handle *handle,
 		}
 
 		desc_index += num_returned;
+
+		scmi_reset_rx_to_maxsz(handle, t);
 		/*
 		 * check for both returned and remaining to avoid infinite
 		 * loop due to buggy firmware
-- 
2.27.0



