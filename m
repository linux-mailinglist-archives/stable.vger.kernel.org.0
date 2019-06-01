Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 842CD31D64
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbfFAN0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:26:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729869AbfFAN0w (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:26:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B446273A3;
        Sat,  1 Jun 2019 13:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395611;
        bh=khIwVd6SZumGNPgq8E7WpdAaNyfO/nGOyz01eOSDa2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rBO0nJZXX2hVy+PBVq0dWQU+CoPLYDGZrp0PzsdGlCDH/gf26uVFUaJYuaT7yxxOL
         6pmccoEGMdOVVboXrWz60l595FzTGdVHuMXjBpN6anX2I5Et+8iljqHaGwOpe5jCHE
         CJk8TpH2QRaaLI++YaCPNOZo7jGhPN8nL6qQPLoU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 28/56] media: ov6650: Fix sensor possibly not detected on probe
Date:   Sat,  1 Jun 2019 09:25:32 -0400
Message-Id: <20190601132600.27427-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132600.27427-1-sashal@kernel.org>
References: <20190601132600.27427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janusz Krzysztofik <jmkrzyszt@gmail.com>

[ Upstream commit 933c1320847f5ed6b61a7d10f0a948aa98ccd7b0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/soc_camera/ov6650.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
index 1e4783b51a351..1e9ebfda25525 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -843,6 +843,8 @@ static int ov6650_video_probe(struct i2c_client *client)
 	if (ret < 0)
 		return ret;
 
+	msleep(20);
+
 	/*
 	 * check and show product ID and manufacturer ID
 	 */
-- 
2.20.1

