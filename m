Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2B6314F04
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbfEFOhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:37:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727364AbfEFOhS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:37:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD48F214AE;
        Mon,  6 May 2019 14:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153437;
        bh=AHoOq/U3hZdTfrrq6fuWipW2A28YIpy4v6lWRzAZoqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qY81MR1SAV/ydONKJGC30FYMe9j4ZyS0d7tDoUr2Hxu3c06o9vJFDpW6M0W/fy2fI
         CpLe0t2oOptSVvCkzQkQASz5HteEG3NA6ujpokSJEjPXB/cA3+83qCXcMH8TqxwrNp
         GfbsPVc35vgrP0DWqdS1UtRVkGgbGubHcWea+QPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Fertic <jeremyfertic@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.0 089/122] staging: iio: adt7316: fix the dac read calculation
Date:   Mon,  6 May 2019 16:32:27 +0200
Message-Id: <20190506143102.717040256@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Fertic <jeremyfertic@gmail.com>

commit 45130fb030aec26ac28b4bb23344901df3ec3b7f upstream.

The calculation of the current dac value is using the wrong bits of the
dac lsb register. Create two macros to shift the lsb register value into
lsb position, depending on whether the dac is 10 or 12 bit. Initialize
data to 0 so, with an 8 bit dac, the msb register value can be bitwise
ORed with data.

Fixes: 35f6b6b86ede ("staging: iio: new ADT7316/7/8 and ADT7516/7/9 driver")
Signed-off-by: Jeremy Fertic <jeremyfertic@gmail.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/iio/addac/adt7316.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/staging/iio/addac/adt7316.c
+++ b/drivers/staging/iio/addac/adt7316.c
@@ -47,6 +47,8 @@
 #define ADT7516_MSB_AIN3		0xA
 #define ADT7516_MSB_AIN4		0xB
 #define ADT7316_DA_DATA_BASE		0x10
+#define ADT7316_DA_10_BIT_LSB_SHIFT	6
+#define ADT7316_DA_12_BIT_LSB_SHIFT	4
 #define ADT7316_DA_MSB_DATA_REGS	4
 #define ADT7316_LSB_DAC_A		0x10
 #define ADT7316_MSB_DAC_A		0x11
@@ -1403,7 +1405,7 @@ static IIO_DEVICE_ATTR(ex_analog_temp_of
 static ssize_t adt7316_show_DAC(struct adt7316_chip_info *chip,
 				int channel, char *buf)
 {
-	u16 data;
+	u16 data = 0;
 	u8 msb, lsb, offset;
 	int ret;
 
@@ -1428,7 +1430,11 @@ static ssize_t adt7316_show_DAC(struct a
 	if (ret)
 		return -EIO;
 
-	data = (msb << offset) + (lsb & ((1 << offset) - 1));
+	if (chip->dac_bits == 12)
+		data = lsb >> ADT7316_DA_12_BIT_LSB_SHIFT;
+	else if (chip->dac_bits == 10)
+		data = lsb >> ADT7316_DA_10_BIT_LSB_SHIFT;
+	data |= msb << offset;
 
 	return sprintf(buf, "%d\n", data);
 }


