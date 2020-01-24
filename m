Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1A76148402
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732311AbgAXLjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:39:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:37036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390938AbgAXLYB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:24:01 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EECA206D4;
        Fri, 24 Jan 2020 11:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865040;
        bh=LGw4FAVCK5D0w+/bHhlwHz3gjNhDdkPaIU+Geu1zqvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=02Mv/sJuZY+tXPUn3hWaXkhjCAM+jub5RItzWLKrc3Vn+nT1j/jcRxuc0quJIOF4Z
         oOpX8tJLIf41/yzwugvV6Z/Afvo35CJ4YkO5FtD5R+7lTEurajIyqvv4/h6UDkHmRP
         yVAHNOZ49b+r1uzIw5kkR2LoepbUJZjrH5jIuZK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 422/639] firmware: arm_scmi: fix bitfield definitions for SENSOR_DESC attributes
Date:   Fri, 24 Jan 2020 10:29:52 +0100
Message-Id: <20200124093139.924944121@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b53d5cc9c9f6c..c00287b5f2c23 100644
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



