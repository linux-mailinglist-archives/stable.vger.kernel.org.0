Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3518361655
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbfGGTiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:38:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56864 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727461AbfGGTiB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:01 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz1-0006dJ-AV; Sun, 07 Jul 2019 20:37:59 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz0-0005XP-6w; Sun, 07 Jul 2019 20:37:58 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jeremy Fertic" <jeremyfertic@gmail.com>,
        "Jonathan Cameron" <Jonathan.Cameron@huawei.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.854394507@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 014/129] staging: iio: adt7316: fix dac_bits assignment
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Fertic <jeremyfertic@gmail.com>

commit e9de475723de5bf207a5b7b88bdca863393e42c8 upstream.

The value of dac_bits is used in adt7316_show_DAC() and adt7316_store_DAC(),
and it should be either 8, 10, or 12 bits depending on the device in use. The
driver currently only assigns a value to dac_bits in
adt7316_store_da_high_resolution(). The purpose of the dac high resolution
option is not to change dac resolution for normal operation. Instead, it
is specific to an optional feature where one or two of the four dacs can
be set to output voltage proportional to temperature. If the user chooses
to set dac a and/or dac b to output voltage proportional to temperature,
the da_high_resolution attribute can optionally be enabled to use 10 bit
resolution rather than the default 8 bits. This is only available on the
10 and 12 bit dac devices. If the user attempts to read or write dacs a
or b under these settings, the driver's current behaviour is to return an
error. Dacs c and d continue to operate normally under these conditions.
With the above in mind, remove the dac_bits assignments from this function
since the value of dac_bits as used in the driver is not dependent on this
dac high resolution option.

Since the dac_bits assignments discussed above are currently the only ones
in this driver, the default value of dac_bits is 0. This results in incorrect
calculations when the dacs are read or written in adt7316_show_DAC() and
adt7316_store_DAC(). To correct this, assign a value to dac_bits in
adt7316_probe() to ensure correct operation as soon as the device is
registered and available to userspace.

Fixes: 35f6b6b86ede ("staging: iio: new ADT7316/7/8 and ADT7516/7/9 driver")
Signed-off-by: Jeremy Fertic <jeremyfertic@gmail.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/iio/addac/adt7316.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/staging/iio/addac/adt7316.c
+++ b/drivers/staging/iio/addac/adt7316.c
@@ -654,15 +654,9 @@ static ssize_t adt7316_store_da_high_res
 	u8 config3;
 	int ret;
 
-	chip->dac_bits = 8;
-
-	if (buf[0] == '1') {
+	if (buf[0] == '1')
 		config3 = chip->config3 | ADT7316_DA_HIGH_RESOLUTION;
-		if (chip->id == ID_ADT7316 || chip->id == ID_ADT7516)
-			chip->dac_bits = 12;
-		else if (chip->id == ID_ADT7317 || chip->id == ID_ADT7517)
-			chip->dac_bits = 10;
-	} else
+	else
 		config3 = chip->config3 & (~ADT7316_DA_HIGH_RESOLUTION);
 
 	ret = chip->bus.write(chip->bus.client, ADT7316_CONFIG3, config3);
@@ -2129,6 +2123,13 @@ int adt7316_probe(struct device *dev, st
 	else
 		return -ENODEV;
 
+	if (chip->id == ID_ADT7316 || chip->id == ID_ADT7516)
+		chip->dac_bits = 12;
+	else if (chip->id == ID_ADT7317 || chip->id == ID_ADT7517)
+		chip->dac_bits = 10;
+	else
+		chip->dac_bits = 8;
+
 	chip->ldac_pin = adt7316_platform_data[1];
 	if (!chip->ldac_pin) {
 		chip->config3 |= ADT7316_DA_EN_VIA_DAC_LDCA;

