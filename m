Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8BDC2F4D2
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbfE3EmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:42:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728962AbfE3DMV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:21 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0443524515;
        Thu, 30 May 2019 03:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185940;
        bh=D15HQzt/gFInZPdaZ219sAc+1IU88ZyBC5dXpV86zog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FjL4u1Ry4/Cma9Ivp1IPgdnu9Tnk1vTsR3EXhuhEKhn06H9va8oq2ObrcNB7yHz7O
         PhAgpObA/EeXMJvqU9sgkDnPWLxYnkfZpwbDcI+SYyrlCFBOSU7uaXCwIvWDVulE7i
         6LuuaiRe94FSMo7zbfkeQCiYczfpO2vfLwbz2fNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        James Hutchinson <jahutchinson99@googlemail.com>,
        Antti Palosaari <crope@iki.fi>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 345/405] media: m88ds3103: serialize reset messages in m88ds3103_set_frontend
Date:   Wed, 29 May 2019 20:05:43 -0700
Message-Id: <20190530030558.144982340@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 981fbe3da20a6f35f17977453bce7dfc1664d74f ]

Ref: https://bugzilla.kernel.org/show_bug.cgi?id=199323

Users are experiencing problems with the DVBSky S960/S960C USB devices
since the following commit:

9d659ae: ("locking/mutex: Add lock handoff to avoid starvation")

The device malfunctions after running for an indeterminable period of
time, and the problem can only be cleared by rebooting the machine.

It is possible to encourage the problem to surface by blocking the
signal to the LNB.

Further debugging revealed the cause of the problem.

In the following capture:
- thread #1325 is running m88ds3103_set_frontend
- thread #42 is running ts2020_stat_work

a> [1325] usb 1-1: dvb_usb_v2_generic_io: >>> 08 68 02 07 80
   [1325] usb 1-1: dvb_usb_v2_generic_io: <<< 08
   [42] usb 1-1: dvb_usb_v2_generic_io: >>> 09 01 01 68 3f
   [42] usb 1-1: dvb_usb_v2_generic_io: <<< 08 ff
   [42] usb 1-1: dvb_usb_v2_generic_io: >>> 08 68 02 03 11
   [42] usb 1-1: dvb_usb_v2_generic_io: <<< 07
   [42] usb 1-1: dvb_usb_v2_generic_io: >>> 09 01 01 60 3d
   [42] usb 1-1: dvb_usb_v2_generic_io: <<< 07 ff
b> [1325] usb 1-1: dvb_usb_v2_generic_io: >>> 08 68 02 07 00
   [1325] usb 1-1: dvb_usb_v2_generic_io: <<< 07
   [42] usb 1-1: dvb_usb_v2_generic_io: >>> 08 68 02 03 11
   [42] usb 1-1: dvb_usb_v2_generic_io: <<< 07
   [42] usb 1-1: dvb_usb_v2_generic_io: >>> 09 01 01 60 21
   [42] usb 1-1: dvb_usb_v2_generic_io: <<< 07 ff
   [42] usb 1-1: dvb_usb_v2_generic_io: >>> 08 68 02 03 11
   [42] usb 1-1: dvb_usb_v2_generic_io: <<< 07
   [42] usb 1-1: dvb_usb_v2_generic_io: >>> 09 01 01 60 66
   [42] usb 1-1: dvb_usb_v2_generic_io: <<< 07 ff
   [1325] usb 1-1: dvb_usb_v2_generic_io: >>> 08 68 02 03 11
   [1325] usb 1-1: dvb_usb_v2_generic_io: <<< 07
   [1325] usb 1-1: dvb_usb_v2_generic_io: >>> 08 60 02 10 0b
   [1325] usb 1-1: dvb_usb_v2_generic_io: <<< 07

Two i2c messages are sent to perform a reset in m88ds3103_set_frontend:

  a. 0x07, 0x80
  b. 0x07, 0x00

However, as shown in the capture, the regmap mutex is being handed over
to another thread (ts2020_stat_work) in between these two messages.

>From here, the device responds to every i2c message with an 07 message,
and will only return to normal operation following a power cycle.

Use regmap_multi_reg_write to group the two reset messages, ensuring
both are processed before the regmap mutex is unlocked.

Signed-off-by: James Hutchinson <jahutchinson99@googlemail.com>
Reviewed-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/m88ds3103.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 123f2a33738b0..403f42806455e 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -309,6 +309,9 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	u16 u16tmp;
 	u32 tuner_frequency_khz, target_mclk;
 	s32 s32tmp;
+	static const struct reg_sequence reset_buf[] = {
+		{0x07, 0x80}, {0x07, 0x00}
+	};
 
 	dev_dbg(&client->dev,
 		"delivery_system=%d modulation=%d frequency=%u symbol_rate=%d inversion=%d pilot=%d rolloff=%d\n",
@@ -321,11 +324,7 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	}
 
 	/* reset */
-	ret = regmap_write(dev->regmap, 0x07, 0x80);
-	if (ret)
-		goto err;
-
-	ret = regmap_write(dev->regmap, 0x07, 0x00);
+	ret = regmap_multi_reg_write(dev->regmap, reset_buf, 2);
 	if (ret)
 		goto err;
 
-- 
2.20.1



