Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9922F34418E
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhCVMeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:34:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231488AbhCVMdS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:33:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07D5B61990;
        Mon, 22 Mar 2021 12:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416395;
        bh=Thj2BLnJy/B5q8Mr7PuHRR4CrJMZD4dBO5VAgv42dNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uWgUPeM782tjnX8PnrmYBzlDgoIYY17h/g2bHSbutzkYxZb4FxrWYeH5KlTxEN6li
         lWMZ0yLAMd09P/ZzcFnPDrowZXnRV1KEl8VS/wHS4H/szNBlwn71mjAwn+jplhhzuv
         r0S0xvdvawvQdv+ncB9jgGxKCSDHEpUVIpIbldDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.11 090/120] iio: gyro: mpu3050: Fix error handling in mpu3050_trigger_handler
Date:   Mon, 22 Mar 2021 13:27:53 +0100
Message-Id: <20210322121932.687859713@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

commit 6dbbbe4cfd398704b72b21c1d4a5d3807e909d60 upstream.

There is one regmap_bulk_read() call in mpu3050_trigger_handler
that we have caught its return value bug lack further handling.
Check and terminate the execution flow just like the other three
regmap_bulk_read() calls in this function.

Fixes: 3904b28efb2c7 ("iio: gyro: Add driver for the MPU-3050 gyroscope")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20210301080421.13436-1-dinghao.liu@zju.edu.cn
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/mpu3050-core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/gyro/mpu3050-core.c
+++ b/drivers/iio/gyro/mpu3050-core.c
@@ -551,6 +551,8 @@ static irqreturn_t mpu3050_trigger_handl
 					       MPU3050_FIFO_R,
 					       &fifo_values[offset],
 					       toread);
+			if (ret)
+				goto out_trigger_unlock;
 
 			dev_dbg(mpu3050->dev,
 				"%04x %04x %04x %04x %04x\n",


