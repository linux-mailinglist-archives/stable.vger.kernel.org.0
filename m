Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 460A6BA3B9
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388717AbfIVSoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:44:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388711AbfIVSoK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:44:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B815921479;
        Sun, 22 Sep 2019 18:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569177849;
        bh=48xQrCMOZWQY0GMUtiT7ORhyY7JKh36Uou8DfkPsZ14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b1C4bWyWq02P3/8HYtovHl2Y8E1/rKYMAAvJmqQNKd+Doy/sxHOpd3o7qJtZ9sFHh
         7s9YjilMnTJfOD6b6jItazfypSX0be6SrOm2wA3I3j7Vp59ZXQZlL25kQH0vLxEHjk
         25gfIl1JiIo4yA9byw9saLqcnyEVsONEyTMlDYw8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 015/203] media: dib0700: fix link error for dibx000_i2c_set_speed
Date:   Sun, 22 Sep 2019 14:40:41 -0400
Message-Id: <20190922184350.30563-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 765bb8610d305ee488b35d07e2a04ae52fb2df9c ]

When CONFIG_DVB_DIB9000 is disabled, we can still compile code that
now fails to link against dibx000_i2c_set_speed:

drivers/media/usb/dvb-usb/dib0700_devices.o: In function `dib01x0_pmu_update.constprop.7':
dib0700_devices.c:(.text.unlikely+0x1c9c): undefined reference to `dibx000_i2c_set_speed'

The call sites are both through dib01x0_pmu_update(), which gets passed
an 'i2c' pointer from dib9000_get_i2c_master(), which has returned
NULL. Checking this pointer seems to be a good idea anyway, and it avoids
the link failure in most cases.

Sean Young found another case that is not fixed by that, where certain
gcc versions leave an unused function in place that causes the link error,
but adding an explict IS_ENABLED() check also solves this.

Fixes: b7f54910ce01 ("V4L/DVB (4647): Added module for DiB0700 based devices")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb/dib0700_devices.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index 66d685065e065..ab7a100ec84fe 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -2439,9 +2439,13 @@ static int dib9090_tuner_attach(struct dvb_usb_adapter *adap)
 		8, 0x0486,
 	};
 
+	if (!IS_ENABLED(CONFIG_DVB_DIB9000))
+		return -ENODEV;
 	if (dvb_attach(dib0090_fw_register, adap->fe_adap[0].fe, i2c, &dib9090_dib0090_config) == NULL)
 		return -ENODEV;
 	i2c = dib9000_get_i2c_master(adap->fe_adap[0].fe, DIBX000_I2C_INTERFACE_GPIO_1_2, 0);
+	if (!i2c)
+		return -ENODEV;
 	if (dib01x0_pmu_update(i2c, data_dib190, 10) != 0)
 		return -ENODEV;
 	dib0700_set_i2c_speed(adap->dev, 1500);
@@ -2517,10 +2521,14 @@ static int nim9090md_tuner_attach(struct dvb_usb_adapter *adap)
 		0, 0x00ef,
 		8, 0x0406,
 	};
+	if (!IS_ENABLED(CONFIG_DVB_DIB9000))
+		return -ENODEV;
 	i2c = dib9000_get_tuner_interface(adap->fe_adap[0].fe);
 	if (dvb_attach(dib0090_fw_register, adap->fe_adap[0].fe, i2c, &nim9090md_dib0090_config[0]) == NULL)
 		return -ENODEV;
 	i2c = dib9000_get_i2c_master(adap->fe_adap[0].fe, DIBX000_I2C_INTERFACE_GPIO_1_2, 0);
+	if (!i2c)
+		return -ENODEV;
 	if (dib01x0_pmu_update(i2c, data_dib190, 10) < 0)
 		return -ENODEV;
 
-- 
2.20.1

