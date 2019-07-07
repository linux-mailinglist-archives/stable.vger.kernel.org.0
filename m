Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30FD661750
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbfGGTrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:47:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56794 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727439AbfGGTiA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:00 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz0-0006cu-70; Sun, 07 Jul 2019 20:37:58 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCyz-0005WU-3P; Sun, 07 Jul 2019 20:37:57 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jonathan Cameron" <Jonathan.Cameron@huawei.com>,
        "Jeremy Fertic" <jeremyfertic@gmail.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.358003632@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 002/129] staging: iio: adt7316: invert the logic of
 the check for an ldac pin
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

commit 85a1c11913312132d0800ca2c1c42a011f96ea92 upstream.

ADT7316_DA_EN_VIA_DAC_LDCA is set when the dac and ldac registers are being
used to update the dacs instead of the ldac pin. ADT7516_SEL_AIN3 is an adc
input that shares the ldac pin. Only set these bits if an ldac pin is not
being used.

This could be backported to stable, but note there are various
other bugs that probably make that a waste of time.

Signed-off-by: Jeremy Fertic <jeremyfertic@gmail.com>
Fixes: 35f6b6b86ede ("staging: iio: new ADT7316/7/8 and ADT7516/7/9 driver")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/iio/addac/adt7316.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/iio/addac/adt7316.c
+++ b/drivers/staging/iio/addac/adt7316.c
@@ -2130,7 +2130,7 @@ int adt7316_probe(struct device *dev, st
 		return -ENODEV;
 
 	chip->ldac_pin = adt7316_platform_data[1];
-	if (chip->ldac_pin) {
+	if (!chip->ldac_pin) {
 		chip->config3 |= ADT7316_DA_EN_VIA_DAC_LDCA;
 		if ((chip->id & ID_FAMILY_MASK) == ID_ADT75XX)
 			chip->config1 |= ADT7516_SEL_AIN3;

