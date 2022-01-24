Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE814998B0
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449894AbiAXV3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449928AbiAXVRf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:17:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE2AC067A67;
        Mon, 24 Jan 2022 12:12:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A190C6131F;
        Mon, 24 Jan 2022 20:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9AAC340E5;
        Mon, 24 Jan 2022 20:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055154;
        bh=1xQpMaORlAjMY+OYmQAFt/yWySqQIyzA1KWUNh4bLgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xa7IvfNgf8BUeSOSGVPCXM0GDH5hUL8FB1K1qWLO0DU0zV5dS7FM9gggZMoq75306
         vO+XpGzMVe3x9FOuOmwbYyPYjv82yGGPL0pAXpvKFDi1LN40wN6ei1CXIUMc19QVPc
         CiwLx1sYH3gtL5Yus6kVpQg1QKdjV8XgCxn4SFwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 041/846] media: ov8865: Disable only enabled regulators on error path
Date:   Mon, 24 Jan 2022 19:32:38 +0100
Message-Id: <20220124184102.363875969@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit cbe0b3af73bf72fad197756f026084404e2bcdc7 upstream.

If powering on the sensor failed, the entire power-off sequence was run
independently of how far the power-on sequence proceeded before the error.
This lead to disabling regulators and/or clock that was not enabled.

Fix this by disabling only clocks and regulators that were enabled
previously.

Fixes: 11c0d8fdccc5 ("media: i2c: Add support for the OV8865 image sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov8865.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/media/i2c/ov8865.c
+++ b/drivers/media/i2c/ov8865.c
@@ -2330,27 +2330,27 @@ static int ov8865_sensor_power(struct ov
 		if (ret) {
 			dev_err(sensor->dev,
 				"failed to enable DOVDD regulator\n");
-			goto disable;
+			return ret;
 		}
 
 		ret = regulator_enable(sensor->avdd);
 		if (ret) {
 			dev_err(sensor->dev,
 				"failed to enable AVDD regulator\n");
-			goto disable;
+			goto disable_dovdd;
 		}
 
 		ret = regulator_enable(sensor->dvdd);
 		if (ret) {
 			dev_err(sensor->dev,
 				"failed to enable DVDD regulator\n");
-			goto disable;
+			goto disable_avdd;
 		}
 
 		ret = clk_prepare_enable(sensor->extclk);
 		if (ret) {
 			dev_err(sensor->dev, "failed to enable EXTCLK clock\n");
-			goto disable;
+			goto disable_dvdd;
 		}
 
 		gpiod_set_value_cansleep(sensor->reset, 0);
@@ -2359,14 +2359,16 @@ static int ov8865_sensor_power(struct ov
 		/* Time to enter streaming mode according to power timings. */
 		usleep_range(10000, 12000);
 	} else {
-disable:
 		gpiod_set_value_cansleep(sensor->powerdown, 1);
 		gpiod_set_value_cansleep(sensor->reset, 1);
 
 		clk_disable_unprepare(sensor->extclk);
 
+disable_dvdd:
 		regulator_disable(sensor->dvdd);
+disable_avdd:
 		regulator_disable(sensor->avdd);
+disable_dovdd:
 		regulator_disable(sensor->dovdd);
 	}
 


