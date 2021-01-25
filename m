Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538B43033AD
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbhAZFCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:02:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:36954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727220AbhAYSvx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:51:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA34E224B8;
        Mon, 25 Jan 2021 18:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600693;
        bh=fP0oFZlIytRDhnTOnXTs7OtIBpYJHgmXAmSSJf78FdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZKylyXF8/c4H0G3fBytdJcWk+wydEmJOzClKZtZ4iO15vW0KGozFTMRDWkziRWgVk
         CJDirfUQszLvFXOgZDZHa4GNWu2noltOM9Unnvr4mR2PvbvDrJX6cNow0bmvzRMu5s
         UwBRO6c29JbDHl7h9EX0DZtcRPxjVPzqV5Tay+Es=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 114/199] iio: adc: ti_am335x_adc: remove omitted iio_kfifo_free()
Date:   Mon, 25 Jan 2021 19:38:56 +0100
Message-Id: <20210125183221.051056008@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Ardelean <alexandru.ardelean@analog.com>

commit 7e6d9788aa02333a4353058816d52b9a90aae0d3 upstream.

When the conversion was done to use devm_iio_kfifo_allocate(), a call to
iio_kfifo_free() was omitted (to be removed).
This change removes it.

Fixes: 3c5308058899 ("iio: adc: ti_am335x_adc: alloc kfifo & IRQ via devm_ functions")
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Link: https://lore.kernel.org/r/20201203072650.24128-1-alexandru.ardelean@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/ti_am335x_adc.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -397,16 +397,12 @@ static int tiadc_iio_buffered_hardware_s
 	ret = devm_request_threaded_irq(dev, irq, pollfunc_th, pollfunc_bh,
 				flags, indio_dev->name, indio_dev);
 	if (ret)
-		goto error_kfifo_free;
+		return ret;
 
 	indio_dev->setup_ops = setup_ops;
 	indio_dev->modes |= INDIO_BUFFER_SOFTWARE;
 
 	return 0;
-
-error_kfifo_free:
-	iio_kfifo_free(indio_dev->buffer);
-	return ret;
 }
 
 static const char * const chan_name_ain[] = {


