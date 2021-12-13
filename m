Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6214726E1
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236569AbhLMJzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:55:32 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38028 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238269AbhLMJwv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:52:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 418A6B80E15;
        Mon, 13 Dec 2021 09:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 639CFC00446;
        Mon, 13 Dec 2021 09:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389169;
        bh=D6a185hB+zAE/f6BWN/i7zM2KUIjdCpDQrqqVvRFy6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1LAY6qSPLXknBqJTWbmjEcXb0EsVr9wbDbLDxPc/i8vzSGMrYXSGyI0bD4rP7fJp7
         gpxvOc3pcKjQE8F9mIt+yfQiTuJcPg3qb+e4vy9w8/4CR9ngofHLOUundxuVtPsE6z
         22P/hW9d8ao+4dECnV8s/3On1Srhnn7GryEG2PKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 116/132] iio: at91-sama5d2: Fix incorrect sign extension
Date:   Mon, 13 Dec 2021 10:30:57 +0100
Message-Id: <20211213092943.080606542@linuxfoundation.org>
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
@@ -1401,7 +1401,8 @@ static int at91_adc_read_info_raw(struct
 		*val = st->conversion_value;
 		ret = at91_adc_adjust_val_osr(st, val);
 		if (chan->scan_type.sign == 's')
-			*val = sign_extend32(*val, 11);
+			*val = sign_extend32(*val,
+					     chan->scan_type.realbits - 1);
 		st->conversion_done = false;
 	}
 


