Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 761231B08DC
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgDTMJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:09:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgDTMJL (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:09:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1BD222202;
        Mon, 20 Apr 2020 12:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587384551;
        bh=S4ZbAFZKwRhRlWkn9j2Hms1n7aHCg1aAYmVgwRuV0ow=;
        h=Subject:To:From:Date:From;
        b=qACmiHLpn3AN5eya67kGDMO5+gMfTaPuMWn9ROJuKXW9F+wF5/mbC64xEb0Z8pb/U
         GQwZX9H9lwahOr54QmU+9vYqXLRPxgdH4SlpJPvFtH5QzIV63Te0+k13GqmQ84+X3q
         hmc0dc2mh9t4Ws5jIxyPj3cs86fyU1AjHbf66kW0=
Subject: patch "iio: xilinx-xadc: Fix clearing interrupt when enabling trigger" added to staging-linus
To:     lars@metafoo.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Apr 2020 14:08:47 +0200
Message-ID: <158738452798139@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: xilinx-xadc: Fix clearing interrupt when enabling trigger

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f954b098fbac4d183219ce5b42d76d6df2aed50a Mon Sep 17 00:00:00 2001
From: Lars-Peter Clausen <lars@metafoo.de>
Date: Fri, 3 Apr 2020 15:27:14 +0200
Subject: iio: xilinx-xadc: Fix clearing interrupt when enabling trigger

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
---
 drivers/iio/adc/xilinx-xadc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/xilinx-xadc-core.c b/drivers/iio/adc/xilinx-xadc-core.c
index f50e04a8b0ec..62ded9683a57 100644
--- a/drivers/iio/adc/xilinx-xadc-core.c
+++ b/drivers/iio/adc/xilinx-xadc-core.c
@@ -674,7 +674,7 @@ static int xadc_trigger_set_state(struct iio_trigger *trigger, bool state)
 
 	spin_lock_irqsave(&xadc->lock, flags);
 	xadc_read_reg(xadc, XADC_AXI_REG_IPIER, &val);
-	xadc_write_reg(xadc, XADC_AXI_REG_IPISR, val & XADC_AXI_INT_EOS);
+	xadc_write_reg(xadc, XADC_AXI_REG_IPISR, XADC_AXI_INT_EOS);
 	if (state)
 		val |= XADC_AXI_INT_EOS;
 	else
-- 
2.26.1


