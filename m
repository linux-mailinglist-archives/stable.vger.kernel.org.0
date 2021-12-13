Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3474729EC
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhLMK1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240248AbhLMK0b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:26:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F4EC08EB2D;
        Mon, 13 Dec 2021 02:00:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 18228CE0F4D;
        Mon, 13 Dec 2021 10:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F2AC34603;
        Mon, 13 Dec 2021 10:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389642;
        bh=cx0ZoL38XEe9D70cZeuDqsSEqy/OdcaUeqZyVLZCf1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/SpQK0W3SMzLRGvPRQ8pVTL6Q0XzOqFqVxPNR73OC6PXsP9j4OM22LkziPX8R2q6
         Oci+aw57tcs1zfabN0iYP99zzofGxBDWk4gnUwiiCtJakhDiCHdDhs5tJfCWGhvPQU
         ivx1geYpcG/UvD8pjoeeoIzFIBW60LTTBZBgojlo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 153/171] iio: at91-sama5d2: Fix incorrect sign extension
Date:   Mon, 13 Dec 2021 10:31:08 +0100
Message-Id: <20211213092950.152204060@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gwendal Grignou <gwendal@chromium.org>

commit 652e7df485c6884d552085ae2c73efa6cfea3547 upstream.

Use scan_type when processing raw data which also fixes that the sign
extension was from the wrong bit.

Use channel definition as root of trust and replace constant
when reading elements directly using the raw sysfs attributes.

Fixes: 6794e23fa3fe ("iio: adc: at91-sama5d2_adc: add support for oversampling resolution")
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Reviewed-by: Eugen Hristev <eugen.hristev@microchip.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211104082413.3681212-9-gwendal@chromium.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/at91-sama5d2_adc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -1377,7 +1377,8 @@ static int at91_adc_read_info_raw(struct
 		*val = st->conversion_value;
 		ret = at91_adc_adjust_val_osr(st, val);
 		if (chan->scan_type.sign == 's')
-			*val = sign_extend32(*val, 11);
+			*val = sign_extend32(*val,
+					     chan->scan_type.realbits - 1);
 		st->conversion_done = false;
 	}
 


