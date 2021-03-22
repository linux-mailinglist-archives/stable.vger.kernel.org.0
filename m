Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1ED344192
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbhCVMeT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:34:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231551AbhCVMdV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:33:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6E226199F;
        Mon, 22 Mar 2021 12:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416398;
        bh=FKq6rZ2Ke0ICL1Ru4IhqBy/idzzVBl+D9H6u8T9JoC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XbnflXgfTapfJbVFU0+XJL4zijmUcCKJN7T7YJ/OrVv0q4s/prVqSPXBwg28WxQPF
         lcukMoBxAv8N0B5rt4s0lF5qgYGj6TUNMo78U1uVHKJuRXT4YJCtmVLV0jZRrBuEl4
         Ju30snzuQ1T9+JyoPZLsscjfSzJr8OJUeBBXyhF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.11 091/120] iio: adc: ab8500-gpadc: Fix off by 10 to 3
Date:   Mon, 22 Mar 2021 13:27:54 +0100
Message-Id: <20210322121932.718236252@linuxfoundation.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

commit 4f5434086d9223f20b3128a7dc78b35271e76655 upstream.

Fix an off by three orders of magnitude error in the AB8500
GPADC driver. Luckily it showed up quite quickly when trying
to make use of it. The processed reads were returning
microvolts, microamperes and microcelsius instead of millivolts,
milliamperes and millicelsius as advertised.

Cc: stable@vger.kernel.org
Fixes: 07063bbfa98e ("iio: adc: New driver for the AB8500 GPADC")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20201224011700.1059659-1-linus.walleij@linaro.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ab8500-gpadc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ab8500-gpadc.c
+++ b/drivers/iio/adc/ab8500-gpadc.c
@@ -918,7 +918,7 @@ static int ab8500_gpadc_read_raw(struct
 			return processed;
 
 		/* Return millivolt or milliamps or millicentigrades */
-		*val = processed * 1000;
+		*val = processed;
 		return IIO_VAL_INT;
 	}
 


