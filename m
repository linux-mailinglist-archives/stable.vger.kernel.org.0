Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 003963A861
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387760AbfFIQ77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:59:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733253AbfFIQ76 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:59:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E25DF206DF;
        Sun,  9 Jun 2019 16:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099597;
        bh=CHEyM8egTsuGj6slw2vaJuzkEXhPw85kwpnVHJXn30w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DHb91MS4kwutEernlo583Qy0al7lB9iR0No023VGI4++nL7PJNMwU8iYyXF4YkJzt
         M+ZHywfVTJd9rb3qm/ahNsr51ORQnReMcumi+O/uo9592bXQdkfywQjog3pTpC9wyc
         kgmKiU29FO++v6RP/ZIGhyLttC61HxwiKWEaeo5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.4 042/241] media: ov6650: Fix sensor possibly not detected on probe
Date:   Sun,  9 Jun 2019 18:39:44 +0200
Message-Id: <20190609164148.988340642@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
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
 drivers/media/i2c/soc_camera/ov6650.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -843,6 +843,8 @@ static int ov6650_video_probe(struct i2c
 	if (ret < 0)
 		return ret;
 
+	msleep(20);
+
 	/*
 	 * check and show product ID and manufacturer ID
 	 */


