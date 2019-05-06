Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 320F314DB9
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbfEFOqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:46:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729021AbfEFOqB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:46:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FC062053B;
        Mon,  6 May 2019 14:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153960;
        bh=HxP6j9eOxPuAu3PNxMhnaWz0ZlCmBnUYcwZkays1naA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJFQvAT6BDST7VHQyCH5qZ8D4CuweiGSxl2/7LwLN3zlE9obQ9dDLNwLquJQfIG0c
         T1KUFxuIBDUOUnQTiaEzCCClQI1C45uEmza5YeSfwrJddHwd2mgHQDzARhhfDo91Cu
         YJQxWxiCoiPjtrl27UsPvZySQbYgmIQlKpi/ILXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Fertic <jeremyfertic@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 62/75] staging: iio: adt7316: fix the dac write calculation
Date:   Mon,  6 May 2019 16:33:10 +0200
Message-Id: <20190506143058.890036809@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.287515952@linuxfoundation.org>
References: <20190506143053.287515952@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/iio/addac/adt7316.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/staging/iio/addac/adt7316.c
+++ b/drivers/staging/iio/addac/adt7316.c
@@ -1447,7 +1447,7 @@ static ssize_t adt7316_show_DAC(struct a
 static ssize_t adt7316_store_DAC(struct adt7316_chip_info *chip,
 		int channel, const char *buf, size_t len)
 {
-	u8 msb, lsb, offset;
+	u8 msb, lsb, lsb_reg, offset;
 	u16 data;
 	int ret;
 
@@ -1465,9 +1465,13 @@ static ssize_t adt7316_store_DAC(struct
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


