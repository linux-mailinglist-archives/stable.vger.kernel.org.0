Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93D1E28A8B
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389164AbfEWTQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:16:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389160AbfEWTQT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:16:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30B8C2133D;
        Thu, 23 May 2019 19:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638978;
        bh=n+iY9opbL5gGBysj7809sJCcw/XvIAH8N+H6U+pwqK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GrwjIGIrvxCYv2zjKhtc5sSSwjBNf9g3Gl0OI7t2V6j8YTpFBMbc7oJsZfFbBPZ70
         KIrJr3GNSjYRmtNHFzYYyLh9sovDNEDUQU+9yr1AfrIvljVJ7P3Y5jO+MsYA/AlQqX
         wp6tm7PhXritxMUSCN1/iUME1GbN4KNTxz+bMUxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.19 034/114] media: ov6650: Fix sensor possibly not detected on probe
Date:   Thu, 23 May 2019 21:05:33 +0200
Message-Id: <20190523181734.865863531@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
References: <20190523181731.372074275@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janusz Krzysztofik <jmkrzyszt@gmail.com>

commit 933c1320847f5ed6b61a7d10f0a948aa98ccd7b0 upstream.

After removal of clock_start() from before soc_camera_init_i2c() in
soc_camera_probe() by commit 9aea470b399d ("[media] soc-camera: switch
I2C subdevice drivers to use v4l2-clk") introduced in v3.11, the ov6650
driver could no longer probe the sensor successfully because its clock
was no longer turned on in advance.  The issue was initially worked
around by adding that missing clock_start() equivalent to OMAP1 camera
interface driver - the only user of this sensor - but a propoer fix
should be rather implemented in the sensor driver code itself.

Fix the issue by inserting a delay between the clock is turned on and
the sensor I2C registers are read for the first time.

Tested on Amstrad Delta with now out of tree but still locally
maintained omap1_camera host driver.

Fixes: 9aea470b399d ("[media] soc-camera: switch I2C subdevice drivers to use v4l2-clk")

Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/i2c/ov6650.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -815,6 +815,8 @@ static int ov6650_video_probe(struct i2c
 	if (ret < 0)
 		return ret;
 
+	msleep(20);
+
 	/*
 	 * check and show product ID and manufacturer ID
 	 */


