Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D6A2E4142
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439458AbgL1PEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:04:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439662AbgL1OL2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:11:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 786F5206C3;
        Mon, 28 Dec 2020 14:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164673;
        bh=vBw9+IFViTIYA9khFT88QgqE0Qv6VUs7SbrIJE8IiJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nqW8KME+2Rv6Kj3d492E8McWRFEILTvxRRSfMu0+Fyl1YOhJbgXBUcg/MIz660Ort
         RMsxV1z/KjPng9IGbhotgiYP7QrT4cAlyVLO9y8EU+3DFncQ4TkCy9Emh6nGkHLVRv
         P03q7EouX2dHCTgEk30ZJ+hWssDrbHtuuyxNy4Qo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 258/717] media: rdacm20: Enable GPIO1 explicitly
Date:   Mon, 28 Dec 2020 13:44:16 +0100
Message-Id: <20201228125033.355269920@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacopo Mondi <jacopo+renesas@jmondi.org>

[ Upstream commit 7fe1d4453fb6bf103d668a19d957a7b2fc21887c ]

The MAX9271 GPIO1 line that controls the sensor reset is by default
enabled after a serializer chip reset.

As rdacm20 does not go through an explicit serializer reset, make sure
GPIO1 is enabled to make the camera module driver more robust.

Fixes: 34009bffc1c6 ("media: i2c: Add RDACM20 driver")
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/rdacm20.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/rdacm20.c b/drivers/media/i2c/rdacm20.c
index 1ed928c4ca70f..16bcb764b0e0d 100644
--- a/drivers/media/i2c/rdacm20.c
+++ b/drivers/media/i2c/rdacm20.c
@@ -487,9 +487,18 @@ static int rdacm20_initialize(struct rdacm20_device *dev)
 	 * Reset the sensor by cycling the OV10635 reset signal connected to the
 	 * MAX9271 GPIO1 and verify communication with the OV10635.
 	 */
-	max9271_clear_gpios(dev->serializer, MAX9271_GPIO1OUT);
+	ret = max9271_enable_gpios(dev->serializer, MAX9271_GPIO1OUT);
+	if (ret)
+		return ret;
+
+	ret = max9271_clear_gpios(dev->serializer, MAX9271_GPIO1OUT);
+	if (ret)
+		return ret;
 	usleep_range(10000, 15000);
-	max9271_set_gpios(dev->serializer, MAX9271_GPIO1OUT);
+
+	ret = max9271_set_gpios(dev->serializer, MAX9271_GPIO1OUT);
+	if (ret)
+		return ret;
 	usleep_range(10000, 15000);
 
 again:
-- 
2.27.0



