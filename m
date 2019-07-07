Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B02F61746
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbfGGTqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:46:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56876 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727460AbfGGTiB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:01 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz1-0006dY-Fl; Sun, 07 Jul 2019 20:37:59 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz0-0005Xd-FF; Sun, 07 Jul 2019 20:37:58 +0100
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
Message-ID: <lsq.1562518457.98043477@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 017/129] staging: iio: adt7316: fix the dac write
 calculation
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

commit 78accaea117c1ae878774974fab91ac4a0b0e2b0 upstream.

The lsb calculation is not masking the correct bits from the user input.
Subtract 1 from (1 << offset) to correctly set up the mask to be applied
to user input.

The lsb register stores its value starting at the bit 7 position.
adt7316_store_DAC() currently assumes the value is at the other end of the
register. Shift the lsb value before storing it in a new variable lsb_reg,
and write this variable to the lsb register.

Fixes: 35f6b6b86ede ("staging: iio: new ADT7316/7/8 and ADT7516/7/9 driver")
Signed-off-by: Jeremy Fertic <jeremyfertic@gmail.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/iio/addac/adt7316.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/staging/iio/addac/adt7316.c
+++ b/drivers/staging/iio/addac/adt7316.c
@@ -1448,7 +1448,7 @@ static ssize_t adt7316_show_DAC(struct a
 static ssize_t adt7316_store_DAC(struct adt7316_chip_info *chip,
 		int channel, const char *buf, size_t len)
 {
-	u8 msb, lsb, offset;
+	u8 msb, lsb, lsb_reg, offset;
 	u16 data;
 	int ret;
 
@@ -1466,9 +1466,13 @@ static ssize_t adt7316_store_DAC(struct
 		return -EINVAL;
 
 	if (chip->dac_bits > 8) {
-		lsb = data & (1 << offset);
+		lsb = data & ((1 << offset) - 1);
+		if (chip->dac_bits == 12)
+			lsb_reg = lsb << ADT7316_DA_12_BIT_LSB_SHIFT;
+		else
+			lsb_reg = lsb << ADT7316_DA_10_BIT_LSB_SHIFT;
 		ret = chip->bus.write(chip->bus.client,
-			ADT7316_DA_DATA_BASE + channel * 2, lsb);
+			ADT7316_DA_DATA_BASE + channel * 2, lsb_reg);
 		if (ret)
 			return -EIO;
 	}

