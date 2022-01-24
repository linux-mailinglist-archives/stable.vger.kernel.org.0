Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36382499E53
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347893AbiAXWcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1586949AbiAXW1e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:27:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDD0C019B31;
        Mon, 24 Jan 2022 12:54:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47061B81243;
        Mon, 24 Jan 2022 20:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ACDDC36AE3;
        Mon, 24 Jan 2022 20:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057681;
        bh=1xQpMaORlAjMY+OYmQAFt/yWySqQIyzA1KWUNh4bLgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a7WZuRCYlGRc0nlJhD3pyQzQ/NBzJocS6N/LuaMaNKu/n3fTg4b3wQw7H4Zwv3xqV
         9rpOzSNmTuDK4TY8ZvOYeEfXE6PmOkQK9pYyUB2mmaWbLJha71FhFofp2soEkXoAtV
         MGgg7huAHYwn3mTbfiv5/CxWdOh9CM40NWCsymZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.16 0043/1039] media: ov8865: Disable only enabled regulators on error path
Date:   Mon, 24 Jan 2022 19:30:32 +0100
Message-Id: <20220124184126.587770188@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
 


