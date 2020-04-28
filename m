Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9157A1BC833
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729501AbgD1SaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:30:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729499AbgD1SaY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:30:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3AD021707;
        Tue, 28 Apr 2020 18:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098624;
        bh=WD3yPOcNBz5ao0L7Opx2owCe6PDhH1jhqWizIZim2uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0HLcIB41+0hUzAA1KRekI/IYVQxoDuOUy62nCZeWVxA9AGmZLgqXFQ9uYXuwkSNO
         OO3sbeXaoYiRCJmtkLkOmE5ccH+rxRg+PJ5IQrDRfUsCGYmLPApQuaXV/azyQ/rZah
         91r0f47gw+yvvUDxdWBezKwTYeI9xQqiKxewC2fo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.6 087/167] iio: xilinx-xadc: Fix clearing interrupt when enabling trigger
Date:   Tue, 28 Apr 2020 20:24:23 +0200
Message-Id: <20200428182235.965806499@linuxfoundation.org>
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

commit f954b098fbac4d183219ce5b42d76d6df2aed50a upstream.

When enabling the trigger and unmasking the end-of-sequence (EOS) interrupt
the EOS interrupt should be cleared from the status register. Otherwise it
is possible that it was still set from a previous capture. If that is the
case the interrupt would fire immediately even though no conversion has
been done yet and stale data is being read from the device.

The old code only clears the interrupt if the interrupt was previously
unmasked. Which does not make much sense since the interrupt is always
masked at this point and in addition masking the interrupt does not clear
the interrupt from the status register. So the clearing needs to be done
unconditionally.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Fixes: bdc8cda1d010 ("iio:adc: Add Xilinx XADC driver")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/xilinx-xadc-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/xilinx-xadc-core.c
+++ b/drivers/iio/adc/xilinx-xadc-core.c
@@ -674,7 +674,7 @@ static int xadc_trigger_set_state(struct
 
 	spin_lock_irqsave(&xadc->lock, flags);
 	xadc_read_reg(xadc, XADC_AXI_REG_IPIER, &val);
-	xadc_write_reg(xadc, XADC_AXI_REG_IPISR, val & XADC_AXI_INT_EOS);
+	xadc_write_reg(xadc, XADC_AXI_REG_IPISR, XADC_AXI_INT_EOS);
 	if (state)
 		val |= XADC_AXI_INT_EOS;
 	else


