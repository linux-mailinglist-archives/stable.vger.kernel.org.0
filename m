Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384AC1BC830
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729464AbgD1SaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:30:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:44892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729468AbgD1SaR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:30:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C85A920B1F;
        Tue, 28 Apr 2020 18:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098617;
        bh=dBQ0T4PkvmwXpAxEz8xIZFwhmeRg2Eec4TtdC+P/jQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o7Y0SsnYu68lbmFaZ9joGZZyk5aqPOsc55ZyQC2njUHW4g6kHsGD5HIWE/L7hOA5g
         /HHqjyVInc5TvfBdOHs9rytVptd9SB2L6jD9W5xfV+jTIgCI+uI3TJMnFuSs7nvk8u
         qj3pC2Cp1cVswjYCNshYefMttvMvPkuvvPbLnuxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.6 086/167] iio: xilinx-xadc: Fix ADC-B powerdown
Date:   Tue, 28 Apr 2020 20:24:22 +0200
Message-Id: <20200428182235.857391705@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

commit e44ec7794d88f918805d700240211a9ec05ed89d upstream.

The check for shutting down the second ADC is inverted. This causes it to
be powered down when it should be enabled. As a result channels that are
supposed to be handled by the second ADC return invalid conversion results.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Fixes: bdc8cda1d010 ("iio:adc: Add Xilinx XADC driver")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/xilinx-xadc-core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/xilinx-xadc-core.c
+++ b/drivers/iio/adc/xilinx-xadc-core.c
@@ -722,13 +722,14 @@ static int xadc_power_adc_b(struct xadc
 {
 	uint16_t val;
 
+	/* Powerdown the ADC-B when it is not needed. */
 	switch (seq_mode) {
 	case XADC_CONF1_SEQ_SIMULTANEOUS:
 	case XADC_CONF1_SEQ_INDEPENDENT:
-		val = XADC_CONF2_PD_ADC_B;
+		val = 0;
 		break;
 	default:
-		val = 0;
+		val = XADC_CONF2_PD_ADC_B;
 		break;
 	}
 


