Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE7D116254
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbfLHN7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:59:13 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59930 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726440AbfLHNyj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:39 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1A-0007d4-QD; Sun, 08 Dec 2019 13:54:36 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1A-0002Kn-CP; Sun, 08 Dec 2019 13:54:36 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>,
        "Sean Young" <sean@mess.org>
Date:   Sun, 08 Dec 2019 13:52:49 +0000
Message-ID: <lsq.1575813165.458870360@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 05/72] media: dib0700: fix link error for
 dibx000_i2c_set_speed
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 765bb8610d305ee488b35d07e2a04ae52fb2df9c upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/usb/dvb-usb/dib0700_devices.c | 8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -2283,9 +2283,13 @@ static int dib9090_tuner_attach(struct d
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
@@ -2361,10 +2365,14 @@ static int nim9090md_tuner_attach(struct
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
 

