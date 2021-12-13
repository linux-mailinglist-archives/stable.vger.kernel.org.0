Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE62472842
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237767AbhLMKKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241935AbhLMKG6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:06:58 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3344CC08E9BC;
        Mon, 13 Dec 2021 01:51:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ABDD8CE0E80;
        Mon, 13 Dec 2021 09:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58408C00446;
        Mon, 13 Dec 2021 09:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389084;
        bh=dv5tLY2Xmurnn4GASWja+bVymLXzsNL0cHZCX1aJp5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b08MvsdetOC9OkXWDF1P9GJJEvJ0X2iR+og5hCu45ZhxGHs6WbEyd2+MIfqXYaiwP
         4xUmkBmwlkzlgTzjLmpdeuqTOZF+ZBMsNRfZHUzrM3J+/sPxnyGdpj6Uld6k2il9hW
         i4+JzUAr1gRBcTFGCbbo1eDNMGBjzSo5Td3mpUEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 111/132] iio: ltr501: Dont return error code in trigger handler
Date:   Mon, 13 Dec 2021 10:30:52 +0100
Message-Id: <20211213092942.911394943@linuxfoundation.org>
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

commit ef9d67fa72c1b149a420587e435a3e888bdbf74f upstream.

IIO trigger handlers need to return one of the irqreturn_t values.
Returning an error code is not supported.

The ltr501 interrupt handler gets this right for most error paths, but
there is one case where it returns the error code.

In addition for this particular case the trigger handler does not call
`iio_trigger_notify_done()`. Which when not done keeps the triggered
disabled forever.

Modify the code so that the function returns a valid irqreturn_t value as
well as calling `iio_trigger_notify_done()` on all exit paths.

Fixes: 2690be905123 ("iio: Add Lite-On ltr501 ambient light / proximity sensor driver")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/r/20211024171251.22896-1-lars@metafoo.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/ltr501.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/ltr501.c
+++ b/drivers/iio/light/ltr501.c
@@ -1273,7 +1273,7 @@ static irqreturn_t ltr501_trigger_handle
 		ret = regmap_bulk_read(data->regmap, LTR501_ALS_DATA1,
 				       als_buf, sizeof(als_buf));
 		if (ret < 0)
-			return ret;
+			goto done;
 		if (test_bit(0, indio_dev->active_scan_mask))
 			scan.channels[j++] = le16_to_cpu(als_buf[1]);
 		if (test_bit(1, indio_dev->active_scan_mask))


