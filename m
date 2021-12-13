Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B853C472846
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238092AbhLMKKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241913AbhLMKGz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:06:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F16C0A88D7;
        Mon, 13 Dec 2021 01:51:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2ED18B80E16;
        Mon, 13 Dec 2021 09:51:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A62C00446;
        Mon, 13 Dec 2021 09:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389075;
        bh=lFru/eiJ+opmGuVoOgd6CAflirb7kLAfOtF6fZS+NaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S7B4dVHeD3GnvhC2HZQOZcc0m7pxo6SeWUwmN22a07HuCgfvW2MZBvgHH+bUtVL9w
         Ir1qNWnTCyCOF3XyU9rqImPcTDufMSPbavd1Kzc1YWMArFdsF7mKnBpoTyLwU2qFxR
         q9QlKISyCSF9EZyBov6D9Mwd3qenj/s7FPpkO/z8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 109/132] iio: stk3310: Dont return error code in interrupt handler
Date:   Mon, 13 Dec 2021 10:30:50 +0100
Message-Id: <20211213092942.851720023@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

commit 8e1eeca5afa7ba84d885987165dbdc5decf15413 upstream.

Interrupt handlers must return one of the irqreturn_t values. Returning a
error code is not supported.

The stk3310 event interrupt handler returns an error code when reading the
flags register fails.

Fix the implementation to always return an irqreturn_t value.

Fixes: 3dd477acbdd1 ("iio: light: Add threshold interrupt support for STK3310")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/r/20211024171251.22896-3-lars@metafoo.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/stk3310.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/iio/light/stk3310.c
+++ b/drivers/iio/light/stk3310.c
@@ -546,9 +546,8 @@ static irqreturn_t stk3310_irq_event_han
 	mutex_lock(&data->lock);
 	ret = regmap_field_read(data->reg_flag_nf, &dir);
 	if (ret < 0) {
-		dev_err(&data->client->dev, "register read failed\n");
-		mutex_unlock(&data->lock);
-		return ret;
+		dev_err(&data->client->dev, "register read failed: %d\n", ret);
+		goto out;
 	}
 	event = IIO_UNMOD_EVENT_CODE(IIO_PROXIMITY, 1,
 				     IIO_EV_TYPE_THRESH,
@@ -560,6 +559,7 @@ static irqreturn_t stk3310_irq_event_han
 	ret = regmap_field_write(data->reg_flag_psint, 0);
 	if (ret < 0)
 		dev_err(&data->client->dev, "failed to reset interrupts\n");
+out:
 	mutex_unlock(&data->lock);
 
 	return IRQ_HANDLED;


