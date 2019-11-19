Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94768101769
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbfKSFnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:43:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:37934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730477AbfKSFnJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:43:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3F6021783;
        Tue, 19 Nov 2019 05:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142188;
        bh=H7Djb+n3qjxbE2dVJgW6kUOuIo0sOoojYsnEGEwGFNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hrt6b5X5bLf8QEOHXkhqIgWg3gkYInukgtxbShITANVUjqkS6+K1rADunt62MErpB
         AsPxeXS99ThsXO6McXUEz5nv2DkBJ0FlsGny2FctMditcy/6wfOd3oCCBTsqH0UIL/
         Qf8T6zM4KT9bZ/vjTnGtItZSnxrRm04z++N6JciY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rui Miguel Silva <rui.silva@linaro.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 419/422] media: ov2680: fix null dereference at power on
Date:   Tue, 19 Nov 2019 06:20:16 +0100
Message-Id: <20191119051426.345896171@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rui Miguel Silva <rui.silva@linaro.org>

[ Upstream commit c45fbdf24c61a7b7a37f1b3bbd46f054637a3627 ]

Swapping the order between v4l2 subdevice registration and checking chip
id in b7a417628abf ("media: ov2680: don't register the v4l2 subdevice
before checking chip ID") makes the mode restore to use the sensor
controls before they are set, so move the mode restore call to s_power
after the handler setup for controls is done.

This remove also the need for the error code path in power on function.

Fixes: b7a417628abf ("media: ov2680: don't register the v4l2 subdevice before checking chip ID")

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov2680.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/ov2680.c b/drivers/media/i2c/ov2680.c
index 3ccd584568fb5..d8798fb714ba8 100644
--- a/drivers/media/i2c/ov2680.c
+++ b/drivers/media/i2c/ov2680.c
@@ -568,10 +568,6 @@ static int ov2680_power_on(struct ov2680_dev *sensor)
 	if (ret < 0)
 		return ret;
 
-	ret = ov2680_mode_restore(sensor);
-	if (ret < 0)
-		goto disable;
-
 	sensor->is_enabled = true;
 
 	/* Set clock lane into LP-11 state */
@@ -580,12 +576,6 @@ static int ov2680_power_on(struct ov2680_dev *sensor)
 	ov2680_stream_disable(sensor);
 
 	return 0;
-
-disable:
-	dev_err(dev, "failed to enable sensor: %d\n", ret);
-	ov2680_power_off(sensor);
-
-	return ret;
 }
 
 static int ov2680_s_power(struct v4l2_subdev *sd, int on)
@@ -606,6 +596,8 @@ static int ov2680_s_power(struct v4l2_subdev *sd, int on)
 		ret = v4l2_ctrl_handler_setup(&sensor->ctrls.handler);
 		if (ret < 0)
 			return ret;
+
+		ret = ov2680_mode_restore(sensor);
 	}
 
 	return ret;
-- 
2.20.1



