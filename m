Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF98D2A59AB
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbgKCUjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:39:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:48596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729926AbgKCUi1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:38:27 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C42022226;
        Tue,  3 Nov 2020 20:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435906;
        bh=VII72c+Xy9wwyEpRk7ysq7tztNFetVc9cUkEEF/I4l4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJoFATXURwvki2rjpfeVLda/LngUFGsQ+GUw+miS/6d3SRyLGXrLJdsaE0yRHhDYq
         cl5UI3JdODzbtGQuVkXc9s2yw5YsAYVXL4urqEvGBpLhX3jlcd9TVi4PRdKnHBw+9K
         NL87T9QZ9du+3H0B2KN8eanKKq+djhGAN4nE6cms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Etienne Carriere <etienne.carriere@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 017/391] firmware: arm_scmi: Add missing Rx size re-initialisation
Date:   Tue,  3 Nov 2020 21:31:08 +0100
Message-Id: <20201103203349.112565902@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
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
index 9853bd3c4d456..017e5d8bd869a 100644
--- a/drivers/firmware/arm_scmi/base.c
+++ b/drivers/firmware/arm_scmi/base.c
@@ -197,6 +197,8 @@ static int scmi_base_implementation_list_get(const struct scmi_handle *handle,
 			protocols_imp[tot_num_ret + loop] = *(list + loop);
 
 		tot_num_ret += loop_num_ret;
+
+		scmi_reset_rx_to_maxsz(handle, t);
 	} while (loop_num_ret);
 
 	scmi_xfer_put(handle, t);
diff --git a/drivers/firmware/arm_scmi/clock.c b/drivers/firmware/arm_scmi/clock.c
index 75e39882746e1..fa3ad3a150c36 100644
--- a/drivers/firmware/arm_scmi/clock.c
+++ b/drivers/firmware/arm_scmi/clock.c
@@ -192,6 +192,8 @@ scmi_clock_describe_rates_get(const struct scmi_handle *handle, u32 clk_id,
 		}
 
 		tot_rate_cnt += num_returned;
+
+		scmi_reset_rx_to_maxsz(handle, t);
 		/*
 		 * check for both returned and remaining to avoid infinite
 		 * loop due to buggy firmware
diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index c113e578cc6ce..6db59a7ac8531 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -147,6 +147,8 @@ int scmi_do_xfer_with_response(const struct scmi_handle *h,
 			       struct scmi_xfer *xfer);
 int scmi_xfer_get_init(const struct scmi_handle *h, u8 msg_id, u8 prot_id,
 		       size_t tx_size, size_t rx_size, struct scmi_xfer **p);
+void scmi_reset_rx_to_maxsz(const struct scmi_handle *handle,
+			    struct scmi_xfer *xfer);
 int scmi_handle_put(const struct scmi_handle *handle);
 struct scmi_handle *scmi_handle_get(struct device *dev);
 void scmi_set_handle(struct scmi_device *scmi_dev);
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 03ec74242c141..28a3e4902ea4e 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -402,6 +402,14 @@ int scmi_do_xfer(const struct scmi_handle *handle, struct scmi_xfer *xfer)
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
index 3e1e87012c95b..3e8b548a12b62 100644
--- a/drivers/firmware/arm_scmi/perf.c
+++ b/drivers/firmware/arm_scmi/perf.c
@@ -304,6 +304,8 @@ scmi_perf_describe_levels_get(const struct scmi_handle *handle, u32 domain,
 		}
 
 		tot_opp_cnt += num_returned;
+
+		scmi_reset_rx_to_maxsz(handle, t);
 		/*
 		 * check for both returned and remaining to avoid infinite
 		 * loop due to buggy firmware
diff --git a/drivers/firmware/arm_scmi/sensors.c b/drivers/firmware/arm_scmi/sensors.c
index 1af0ad362e823..4beee439b84ba 100644
--- a/drivers/firmware/arm_scmi/sensors.c
+++ b/drivers/firmware/arm_scmi/sensors.c
@@ -166,6 +166,8 @@ static int scmi_sensor_description_get(const struct scmi_handle *handle,
 		}
 
 		desc_index += num_returned;
+
+		scmi_reset_rx_to_maxsz(handle, t);
 		/*
 		 * check for both returned and remaining to avoid infinite
 		 * loop due to buggy firmware
-- 
2.27.0



