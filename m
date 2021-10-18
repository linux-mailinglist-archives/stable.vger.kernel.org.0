Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A48431CD7
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbhJRNpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:45:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233982AbhJRNnj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:43:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C10DD610A6;
        Mon, 18 Oct 2021 13:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564080;
        bh=RUSYGcUE9avAjSDc7pZPpcq1IGDFoer+waIvRGTiRgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IohCQsT4WF8xkkMwqA2xhjI0j4xUj0heowN4G/5EBD+PbnMaeR6BhhAmTyzUNpZXa
         CCNfHd0aSV9e3Yk7emgCx8WNRKBHeiYY9jM/jjsjl67Hj7gn+WtwDwMz4Q/mfYjQoE
         vn4Vyyy5Y/0YLvJkY8WB0qwpy+/ZZAVkGIjzb/qI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 058/103] iio: adc: max1027: Fix the number of max1X31 channels
Date:   Mon, 18 Oct 2021 15:24:34 +0200
Message-Id: <20211018132336.706593142@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit f0cb5fed37ab37f6a6c5463c5fd39b58a45670c8 upstream.

The macro MAX1X29_CHANNELS() already calls MAX1X27_CHANNELS().
Calling MAX1X27_CHANNELS() before MAX1X29_CHANNELS() in the definition
of MAX1X31_CHANNELS() declares the first 8 channels twice. So drop this
extra call from the MAX1X31 channels list definition.

Fixes: 7af5257d8427 ("iio: adc: max1027: Prepare the introduction of different resolutions")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20210818111139.330636-3-miquel.raynal@bootlin.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/max1027.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/iio/adc/max1027.c
+++ b/drivers/iio/adc/max1027.c
@@ -142,7 +142,6 @@ MODULE_DEVICE_TABLE(of, max1027_adc_dt_i
 	MAX1027_V_CHAN(11, depth)
 
 #define MAX1X31_CHANNELS(depth)			\
-	MAX1X27_CHANNELS(depth),		\
 	MAX1X29_CHANNELS(depth),		\
 	MAX1027_V_CHAN(12, depth),		\
 	MAX1027_V_CHAN(13, depth),		\


