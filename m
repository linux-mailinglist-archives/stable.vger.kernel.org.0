Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B97714B9CF
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730782AbgA1OVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:21:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:46392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731216AbgA1OVL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:21:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB65D2071E;
        Tue, 28 Jan 2020 14:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221271;
        bh=9//9jm4pWVGERH43Lx+MZL03EgoWFR1cNNWMMyCf+Tk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QNQOawIwCof5CORujAG+i4PpHAuADd2GpHLrjxxviwMP/nXS/VJr+tFzLhqmo/MgO
         WLIogA/z7kj4ZBOfWYXKKyHffWK+zVCI72pbHh6IeFiMAFK5RyiN399HXPPW0GouXr
         KUj/iWDk63k8KG4Q+nwEKPCJVgr+Gg6YQ95kmJuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 158/271] rtc: pcf8563: Clear event flags and disable interrupts before requesting irq
Date:   Tue, 28 Jan 2020 15:05:07 +0100
Message-Id: <20200128135904.333711550@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 3572e8aea3bf925dac1dbf86127657c39fe5c254 ]

Besides the alarm, the PCF8563 also has a timer triggered interrupt.
In cases where the previous system left the timer and interrupts on,
or somehow the bits got enabled, the interrupt would keep triggering
as the kernel doesn't know about it.

Clear both the alarm and timer event flags, and disable the interrupts,
before requesting the interrupt line.

Fixes: ede3e9d47cca ("drivers/rtc/rtc-pcf8563.c: add alarm support")
Fixes: a45d528aab8b ("rtc: pcf8563: clear expired alarm at boot time")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf8563.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index a4b8b603c807d..533fb7027f0cc 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -563,7 +563,6 @@ static int pcf8563_probe(struct i2c_client *client,
 	struct pcf8563 *pcf8563;
 	int err;
 	unsigned char buf;
-	unsigned char alm_pending;
 
 	dev_dbg(&client->dev, "%s\n", __func__);
 
@@ -587,13 +586,13 @@ static int pcf8563_probe(struct i2c_client *client,
 		return err;
 	}
 
-	err = pcf8563_get_alarm_mode(client, NULL, &alm_pending);
-	if (err) {
-		dev_err(&client->dev, "%s: read error\n", __func__);
+	/* Clear flags and disable interrupts */
+	buf = 0;
+	err = pcf8563_write_block_data(client, PCF8563_REG_ST2, 1, &buf);
+	if (err < 0) {
+		dev_err(&client->dev, "%s: write error\n", __func__);
 		return err;
 	}
-	if (alm_pending)
-		pcf8563_set_alarm_mode(client, 0);
 
 	pcf8563->rtc = devm_rtc_device_register(&client->dev,
 				pcf8563_driver.driver.name,
-- 
2.20.1



