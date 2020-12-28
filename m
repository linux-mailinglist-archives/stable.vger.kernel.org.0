Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9462E42AA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391634AbgL1N6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:58:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:60040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391624AbgL1N6V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:58:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37A3F2078D;
        Mon, 28 Dec 2020 13:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163859;
        bh=JJ98nMTw0U+b1TISDdZ/VTbdI0leF7vvt/tfhi4+4g0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IJ4fAW4BVYWzRBUXQW8YPgIhIx8mn1S8ykj01Ta4tTJvoArN0M6cBqqam25w2ioGp
         vMaqhCIHWYojkOaJ4XzFECDX2bMVDPZ6YqOIlGAe94TYExSczgVMWFsdlhQKb+gOyW
         9a0k9/gsEyQYX1zXdrzsHKv+bnTeHr7e2wwAU7sU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Dan Murphy <dmurphy@ti.com>, Stable@vger.kernel.org
Subject: [PATCH 5.4 432/453] iio:adc:ti-ads124s08: Fix buffer being too long.
Date:   Mon, 28 Dec 2020 13:51:08 +0100
Message-Id: <20201228124958.015381701@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit b0bd27f02d768e3a861c4e6c27f8e369720e6c25 upstream.

The buffer is expressed as a u32 array, yet the extra space for
the s64 timestamp was expressed as sizeof(s64)/sizeof(u16).
This will result in 2 extra u32 elements.
Fix by dividing by sizeof(u32).

Fixes: e717f8c6dfec ("iio: adc: Add the TI ads124s08 ADC code")
Signed-off-by: Jonathan Cameron<Jonathan.Cameron@huawei.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: Dan Murphy <dmurphy@ti.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200920112742.170751-8-jic23@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/ti-ads124s08.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ti-ads124s08.c
+++ b/drivers/iio/adc/ti-ads124s08.c
@@ -270,7 +270,7 @@ static irqreturn_t ads124s_trigger_handl
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct ads124s_private *priv = iio_priv(indio_dev);
-	u32 buffer[ADS124S08_MAX_CHANNELS + sizeof(s64)/sizeof(u16)];
+	u32 buffer[ADS124S08_MAX_CHANNELS + sizeof(s64)/sizeof(u32)];
 	int scan_index, j = 0;
 	int ret;
 


