Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE1E014E280
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730444AbgA3Smo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:42:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:51162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730441AbgA3Smn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:42:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E751220702;
        Thu, 30 Jan 2020 18:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409763;
        bh=IEY2DK0mVd3QRoS/LYnosAPqfWr7Mx1laUopAzlAE6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=STNT+7EHqubwYVZ7H6H/yrizqJaAbL+HLkSil1RFGyfiX5uwHW7hLZtw4hhFCfPKn
         kf0zTO0tCaRcUoo06b35RkDhNKTTDBjW4q+gjgwUagoT90uU3RIXXh1tsAJJOX+geS
         rEoF80omZN2IYTStA299jdD6rVfhgpMxmDQ7r538=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Moysan <olivier.moysan@st.com>,
        Stable@vger.kernel.org, Fabrice Gasnier <fabrice.gasnier@st.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 024/110] iio: adc: stm32-dfsdm: fix single conversion
Date:   Thu, 30 Jan 2020 19:38:00 +0100
Message-Id: <20200130183617.936420980@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Moysan <olivier.moysan@st.com>

commit dc26935fb60e8da8d59655dd2ec0de47b20d7d8f upstream.

Apply data formatting to single conversion,
as this is already done in continuous and trigger modes.

Fixes: 102afde62937 ("iio: adc: stm32-dfsdm: manage data resolution in trigger mode")

Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Cc: <Stable@vger.kernel.org>
Acked-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/stm32-dfsdm-adc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/adc/stm32-dfsdm-adc.c
+++ b/drivers/iio/adc/stm32-dfsdm-adc.c
@@ -1204,6 +1204,8 @@ static int stm32_dfsdm_single_conv(struc
 
 	stm32_dfsdm_stop_conv(adc);
 
+	stm32_dfsdm_process_data(adc, res);
+
 stop_dfsdm:
 	stm32_dfsdm_stop_dfsdm(adc->dfsdm);
 


