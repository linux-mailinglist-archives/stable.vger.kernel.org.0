Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84CF861747
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbfGGTqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:46:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56848 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727457AbfGGTiB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:01 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz1-0006dM-AU; Sun, 07 Jul 2019 20:37:59 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz0-0005XU-94; Sun, 07 Jul 2019 20:37:58 +0100
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
Message-ID: <lsq.1562518457.922294205@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 015/129] staging: iio: adt7316: fix handling of dac
 high resolution option
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

commit 76b7fe8d6c4daf4db672eb953c892c6f6572a282 upstream.

The adt7316/7 and adt7516/7 have the option to output voltage proportional
to temperature on dac a and/or dac b. The default dac resolution in this
mode is 8 bits with the dac high resolution option enabling 10 bits. None
of these settings affect dacs c and d. Remove the "1 (12 bits)" output from
the show function since that is not an option for this mode. Return
"1 (10 bits)" if the device is one of the above mentioned chips and the dac
high resolution mode is enabled.

In the store function, the driver currently allows the user to write to the
ADT7316_DA_HIGH_RESOLUTION bit regardless of the device in use. Add a check
to return an error in the case of an adt7318 or adt7519. Remove the else
statement that clears the ADT7316_DA_HIGH_RESOLUTION bit. Instead, clear it
before conditionally enabling it, depending on user input. This matches the
typical pattern in the driver when an attribute is a boolean.

Fixes: 35f6b6b86ede ("staging: iio: new ADT7316/7/8 and ADT7516/7/9 driver")
Signed-off-by: Jeremy Fertic <jeremyfertic@gmail.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/iio/addac/adt7316.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/staging/iio/addac/adt7316.c
+++ b/drivers/staging/iio/addac/adt7316.c
@@ -635,9 +635,7 @@ static ssize_t adt7316_show_da_high_reso
 	struct adt7316_chip_info *chip = iio_priv(dev_info);
 
 	if (chip->config3 & ADT7316_DA_HIGH_RESOLUTION) {
-		if (chip->id == ID_ADT7316 || chip->id == ID_ADT7516)
-			return sprintf(buf, "1 (12 bits)\n");
-		else if (chip->id == ID_ADT7317 || chip->id == ID_ADT7517)
+		if (chip->id != ID_ADT7318 && chip->id != ID_ADT7519)
 			return sprintf(buf, "1 (10 bits)\n");
 	}
 
@@ -654,10 +652,12 @@ static ssize_t adt7316_store_da_high_res
 	u8 config3;
 	int ret;
 
+	if (chip->id == ID_ADT7318 || chip->id == ID_ADT7519)
+		return -EPERM;
+
+	config3 = chip->config3 & (~ADT7316_DA_HIGH_RESOLUTION);
 	if (buf[0] == '1')
-		config3 = chip->config3 | ADT7316_DA_HIGH_RESOLUTION;
-	else
-		config3 = chip->config3 & (~ADT7316_DA_HIGH_RESOLUTION);
+		config3 |= ADT7316_DA_HIGH_RESOLUTION;
 
 	ret = chip->bus.write(chip->bus.client, ADT7316_CONFIG3, config3);
 	if (ret)

