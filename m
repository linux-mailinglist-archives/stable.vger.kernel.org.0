Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90DB0B5C2C
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729664AbfIRGXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:23:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728146AbfIRGXe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:23:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C6ED218AF;
        Wed, 18 Sep 2019 06:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787813;
        bh=L0NefyNw+fmLtrMwBX9dMweJMjwLec/5MmMyXvZSIBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ydqJAI5vF4FxWm0WCnO/dFRqydPNaRKWjHEOylfeKTTteMTKxGwhVusGd1R11E/xq
         GXK66+0h9kcd3FJck31NPJN8aAY8QrP2yy7N4eke0jzwmPgLZYafFlaziXZTzwNkPS
         dAgU6L2eTXVabgVVdVHzy97vA84HVj+BsjSA92hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Moysan <olivier.moysan@st.com>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 44/50] iio: adc: stm32-dfsdm: fix data type
Date:   Wed, 18 Sep 2019 08:19:27 +0200
Message-Id: <20190918061228.175134274@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061223.116178343@linuxfoundation.org>
References: <20190918061223.116178343@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Moysan <olivier.moysan@st.com>

commit c6013bf50e2a2a94ab3d012e191096432aa50c6f upstream.

Fix the data type as DFSDM raw output is complements 2,
24bits left aligned in a 32-bit register.
This change does not affect AUDIO path
- Set data as signed for IIO (as for AUDIO)
- Set 8 bit right shift for IIO.
The 8 LSBs bits of data contains channel info and are masked.

Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Fixes: e2e6771c6462 ("IIO: ADC: add STM32 DFSDM sigma delta ADC support")
Acked-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/stm32-dfsdm-adc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/stm32-dfsdm-adc.c
+++ b/drivers/iio/adc/stm32-dfsdm-adc.c
@@ -981,11 +981,11 @@ static int stm32_dfsdm_adc_chan_init_one
 	ch->info_mask_shared_by_all = BIT(IIO_CHAN_INFO_OVERSAMPLING_RATIO);
 
 	if (adc->dev_data->type == DFSDM_AUDIO) {
-		ch->scan_type.sign = 's';
 		ch->ext_info = dfsdm_adc_audio_ext_info;
 	} else {
-		ch->scan_type.sign = 'u';
+		ch->scan_type.shift = 8;
 	}
+	ch->scan_type.sign = 's';
 	ch->scan_type.realbits = 24;
 	ch->scan_type.storagebits = 32;
 


