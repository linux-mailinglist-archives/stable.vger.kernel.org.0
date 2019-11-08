Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02172F4A36
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390043AbfKHMHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:07:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:53802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732382AbfKHLku (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:40:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A168521D7E;
        Fri,  8 Nov 2019 11:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213249;
        bh=zgtQn59xKSHLgHf3t2ThmqyQQy/k5Hd9egH/wHnXQc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0iLX8P4p3Uc0jtDTOUntuGCZghvtYLu/qRo1HuHDfwlbIRBOU7CJV/Ndle2o57FcJ
         P+brYzKHvLz/9XUxGzMRT1YFHN0kWIi3PSrYxfLqriqsRoIrWWbwwRbFRaOr8XstZ6
         Lwtr5+LA1SdxrxGJwjLVStNdnXNU7uJznPJcCO8Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Olof Johansson <olof@lixom.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 116/205] firmware: arm_scmi: use strlcpy to ensure NULL-terminated strings
Date:   Fri,  8 Nov 2019 06:36:23 -0500
Message-Id: <20191108113752.12502-116-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit ca64b719a1e665ac7449b6a968059176af7365a8 ]

Replace all the memcpy() for copying name strings from the firmware with
strlcpy() to make sure we are bounded by the source buffer size and we
also always have NULL-terminated strings.

This is needed to avoid out of bounds accesses if the firmware returns
a non-terminated string.

Reported-by: Olof Johansson <olof@lixom.net>
Acked-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/base.c    | 2 +-
 drivers/firmware/arm_scmi/clock.c   | 2 +-
 drivers/firmware/arm_scmi/perf.c    | 2 +-
 drivers/firmware/arm_scmi/power.c   | 2 +-
 drivers/firmware/arm_scmi/sensors.c | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/arm_scmi/base.c b/drivers/firmware/arm_scmi/base.c
index 9dff33ea6416f..204390297f4bd 100644
--- a/drivers/firmware/arm_scmi/base.c
+++ b/drivers/firmware/arm_scmi/base.c
@@ -208,7 +208,7 @@ static int scmi_base_discover_agent_get(const struct scmi_handle *handle,
 
 	ret = scmi_do_xfer(handle, t);
 	if (!ret)
-		memcpy(name, t->rx.buf, SCMI_MAX_STR_SIZE);
+		strlcpy(name, t->rx.buf, SCMI_MAX_STR_SIZE);
 
 	scmi_xfer_put(handle, t);
 
diff --git a/drivers/firmware/arm_scmi/clock.c b/drivers/firmware/arm_scmi/clock.c
index e4119eb34986c..30fc04e284312 100644
--- a/drivers/firmware/arm_scmi/clock.c
+++ b/drivers/firmware/arm_scmi/clock.c
@@ -111,7 +111,7 @@ static int scmi_clock_attributes_get(const struct scmi_handle *handle,
 
 	ret = scmi_do_xfer(handle, t);
 	if (!ret)
-		memcpy(clk->name, attr->name, SCMI_MAX_STR_SIZE);
+		strlcpy(clk->name, attr->name, SCMI_MAX_STR_SIZE);
 	else
 		clk->name[0] = '\0';
 
diff --git a/drivers/firmware/arm_scmi/perf.c b/drivers/firmware/arm_scmi/perf.c
index 64342944d9175..87c99d296ecd3 100644
--- a/drivers/firmware/arm_scmi/perf.c
+++ b/drivers/firmware/arm_scmi/perf.c
@@ -174,7 +174,7 @@ scmi_perf_domain_attributes_get(const struct scmi_handle *handle, u32 domain,
 			dom_info->mult_factor =
 					(dom_info->sustained_freq_khz * 1000) /
 					dom_info->sustained_perf_level;
-		memcpy(dom_info->name, attr->name, SCMI_MAX_STR_SIZE);
+		strlcpy(dom_info->name, attr->name, SCMI_MAX_STR_SIZE);
 	}
 
 	scmi_xfer_put(handle, t);
diff --git a/drivers/firmware/arm_scmi/power.c b/drivers/firmware/arm_scmi/power.c
index cfa033b05aed5..62f3401a1f01e 100644
--- a/drivers/firmware/arm_scmi/power.c
+++ b/drivers/firmware/arm_scmi/power.c
@@ -106,7 +106,7 @@ scmi_power_domain_attributes_get(const struct scmi_handle *handle, u32 domain,
 		dom_info->state_set_notify = SUPPORTS_STATE_SET_NOTIFY(flags);
 		dom_info->state_set_async = SUPPORTS_STATE_SET_ASYNC(flags);
 		dom_info->state_set_sync = SUPPORTS_STATE_SET_SYNC(flags);
-		memcpy(dom_info->name, attr->name, SCMI_MAX_STR_SIZE);
+		strlcpy(dom_info->name, attr->name, SCMI_MAX_STR_SIZE);
 	}
 
 	scmi_xfer_put(handle, t);
diff --git a/drivers/firmware/arm_scmi/sensors.c b/drivers/firmware/arm_scmi/sensors.c
index 27f2092b9882a..b53d5cc9c9f6c 100644
--- a/drivers/firmware/arm_scmi/sensors.c
+++ b/drivers/firmware/arm_scmi/sensors.c
@@ -140,7 +140,7 @@ static int scmi_sensor_description_get(const struct scmi_handle *handle,
 			s = &si->sensors[desc_index + cnt];
 			s->id = le32_to_cpu(buf->desc[cnt].id);
 			s->type = SENSOR_TYPE(attrh);
-			memcpy(s->name, buf->desc[cnt].name, SCMI_MAX_STR_SIZE);
+			strlcpy(s->name, buf->desc[cnt].name, SCMI_MAX_STR_SIZE);
 		}
 
 		desc_index += num_returned;
-- 
2.20.1

