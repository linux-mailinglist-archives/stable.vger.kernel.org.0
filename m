Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA0437CAF5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239062AbhELQdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:33:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:44832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241294AbhELQ1A (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 132F061430;
        Wed, 12 May 2021 15:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834686;
        bh=t1ZHTfanzEWNLo69Qb9Ttj0bYvu9hjx48HC5/qJafIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rp8Z84zJq9MNmg8iAMpiMc0MyeF2Q7QuQ0T03H1bPaPm80ZUkP/GXDYKfNEvCOKUc
         DTOLmXwOu15yzgQoOTLtgWrSLMdJ6wOseOVzbgiiouuNIIq5vrFocfE8ZiLkAGZDkI
         D75JRZWKiBJmdo8WX20Y3K2FzzVAtiO772EiigKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.12 044/677] iio: magnetometer: yas530: Fix return value on error path
Date:   Wed, 12 May 2021 16:41:30 +0200
Message-Id: <20210512144838.674734708@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit e64837bf9e2c063d6b5bab51c0554a60270f636d upstream.

There was a missed return variable assignment in the
default errorpath of the switch statement in yas5xx_probe().
Fix it.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20210215153023.47899-1-linus.walleij@linaro.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/magnetometer/yamaha-yas530.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/magnetometer/yamaha-yas530.c
+++ b/drivers/iio/magnetometer/yamaha-yas530.c
@@ -888,6 +888,7 @@ static int yas5xx_probe(struct i2c_clien
 		strncpy(yas5xx->name, "yas532", sizeof(yas5xx->name));
 		break;
 	default:
+		ret = -ENODEV;
 		dev_err(dev, "unhandled device ID %02x\n", yas5xx->devid);
 		goto assert_reset;
 	}


