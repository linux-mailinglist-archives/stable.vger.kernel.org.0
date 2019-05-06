Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6460814F05
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfEFPG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 11:06:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726909AbfEFOhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:37:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D8A8206A3;
        Mon,  6 May 2019 14:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153440;
        bh=2Gd0bH3/tO40zPJAXXvIBjHGlAEcOp4BKYcLxoT5HSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gWTNROQ1tiN2IuxGE4aCLhHnSLc8eL/S0Kark59XNnDsep9IlRV0oCIkuop2Sjx/G
         1FaVKD4Tm9dPkI7I0okknJaYxlHgUcZJYgxNIbno7HQt2phPUKEhxgR1qzlxF2P1a3
         gHnZ/znWAPkADp47JeEDo+hk0xVxoxq585Wu78io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Fertic <jeremyfertic@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.0 090/122] staging: iio: adt7316: fix handling of dac high resolution option
Date:   Mon,  6 May 2019 16:32:28 +0200
Message-Id: <20190506143102.784111183@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/iio/addac/adt7316.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/staging/iio/addac/adt7316.c
+++ b/drivers/staging/iio/addac/adt7316.c
@@ -634,9 +634,7 @@ static ssize_t adt7316_show_da_high_reso
 	struct adt7316_chip_info *chip = iio_priv(dev_info);
 
 	if (chip->config3 & ADT7316_DA_HIGH_RESOLUTION) {
-		if (chip->id == ID_ADT7316 || chip->id == ID_ADT7516)
-			return sprintf(buf, "1 (12 bits)\n");
-		if (chip->id == ID_ADT7317 || chip->id == ID_ADT7517)
+		if (chip->id != ID_ADT7318 && chip->id != ID_ADT7519)
 			return sprintf(buf, "1 (10 bits)\n");
 	}
 
@@ -653,10 +651,12 @@ static ssize_t adt7316_store_da_high_res
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


