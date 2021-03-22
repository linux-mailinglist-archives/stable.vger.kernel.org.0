Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817C3344441
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 14:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhCVM7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:59:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232721AbhCVM4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:56:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FB5F619BA;
        Mon, 22 Mar 2021 12:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417324;
        bh=tPetY16AiQmg8h1ZYslYI+vPL7h0XaE/AWhM9p3MhSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Evud/tKqxI8OvG5zjF5H5Exy1ydfYwHHJQtH6zFOvpZ16GH2tTs52zHZ6IC2lWJ+
         4gtW1zK70qdnPl/tWnfYad9MRJ6Y+Kjn2Kzt4GGFAEtKGnmOrlGDf6LPTOZyF9YV8A
         mpEXkJtx6J00WWcqJFplDmG1mmx9BPesGGUAM14I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 30/43] iio: gyro: mpu3050: Fix error handling in mpu3050_trigger_handler
Date:   Mon, 22 Mar 2021 13:29:11 +0100
Message-Id: <20210322121920.999100040@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121920.053255560@linuxfoundation.org>
References: <20210322121920.053255560@linuxfoundation.org>
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
@@ -549,6 +549,8 @@ static irqreturn_t mpu3050_trigger_handl
 					       MPU3050_FIFO_R,
 					       &fifo_values[offset],
 					       toread);
+			if (ret)
+				goto out_trigger_unlock;
 
 			dev_dbg(mpu3050->dev,
 				"%04x %04x %04x %04x %04x\n",


