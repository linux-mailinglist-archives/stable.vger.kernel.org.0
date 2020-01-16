Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6E3713F4D0
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388726AbgAPSwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:52:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:42516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389439AbgAPRIe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:08:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0676E2467C;
        Thu, 16 Jan 2020 17:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194513;
        bh=QOXJQFLhX9thyDPeqKCT78Ibo5JZTuoneB29aF9mx6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EFSFpqpQ/4gsggMeQ/YXbl/wWQFGYDbW94BbMNtGYkqA/Umb8VHA997P6DfoSPSuD
         IuGk2c3UtpMbBWrmj0HvJ7pcYKxeR5rxDAM4fjBVXl64mXXowlZ9/uqT/BYXkSXXeV
         lcAUsr7I3nGy1iAf99B5pJxOL8RcUDUlnW1r/ZRE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 407/671] firmware: arm_scmi: fix bitfield definitions for SENSOR_DESC attributes
Date:   Thu, 16 Jan 2020 12:00:45 -0500
Message-Id: <20200116170509.12787-144-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 430daaf96ad133be5ce7c3a5c60e94247f7c6f71 ]

As per the SCMI specification the bitfields for SENSOR_DESC attributes
are as follows:
attributes_low 	[7:0] 	Number of trip points supported
attributes_high	[15:11]	The power-of-10 multiplier in 2's-complement
			format that is applied to the sensor units

Looks like the code developed during the draft versions of the
specification slipped through and are wrong with respect to final
released version. Fix them by adjusting the bitfields appropriately.

Fixes: 5179c523c1ea ("firmware: arm_scmi: add initial support for sensor protocol")
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/sensors.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/sensors.c b/drivers/firmware/arm_scmi/sensors.c
index b53d5cc9c9f6..c00287b5f2c2 100644
--- a/drivers/firmware/arm_scmi/sensors.c
+++ b/drivers/firmware/arm_scmi/sensors.c
@@ -30,10 +30,10 @@ struct scmi_msg_resp_sensor_description {
 		__le32 id;
 		__le32 attributes_low;
 #define SUPPORTS_ASYNC_READ(x)	((x) & BIT(31))
-#define NUM_TRIP_POINTS(x)	(((x) >> 4) & 0xff)
+#define NUM_TRIP_POINTS(x)	((x) & 0xff)
 		__le32 attributes_high;
 #define SENSOR_TYPE(x)		((x) & 0xff)
-#define SENSOR_SCALE(x)		(((x) >> 11) & 0x3f)
+#define SENSOR_SCALE(x)		(((x) >> 11) & 0x1f)
 #define SENSOR_UPDATE_SCALE(x)	(((x) >> 22) & 0x1f)
 #define SENSOR_UPDATE_BASE(x)	(((x) >> 27) & 0x1f)
 		    u8 name[SCMI_MAX_STR_SIZE];
-- 
2.20.1

