Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89B01B08DB
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgDTMJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:09:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgDTMJJ (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:09:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DF9920679;
        Mon, 20 Apr 2020 12:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587384548;
        bh=5EHikwcID/c3N6w6ySXmgKJM68KZRgR/Cm3S6tFcuwM=;
        h=Subject:To:From:Date:From;
        b=HBXE0RvfV7gFdEyTM/xYpIlp5POk4/HzJKCY7FQATs2cAM2MuKchD638ePo/mSQLc
         EiaL1Xs6qbltU0V52W1h74MVN7WiEyaFIeDc3iq3KegUSidMRRieR1C9hHRUgg2EuV
         NY7Pz4bWRexrYNKr9Vj32GspwQZf6VAfb52Ugfbk=
Subject: patch "iio: xilinx-xadc: Fix ADC-B powerdown" added to staging-linus
To:     lars@metafoo.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Apr 2020 14:08:47 +0200
Message-ID: <1587384527119205@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: xilinx-xadc: Fix ADC-B powerdown

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e44ec7794d88f918805d700240211a9ec05ed89d Mon Sep 17 00:00:00 2001
From: Lars-Peter Clausen <lars@metafoo.de>
Date: Fri, 3 Apr 2020 15:27:13 +0200
Subject: iio: xilinx-xadc: Fix ADC-B powerdown

The check for shutting down the second ADC is inverted. This causes it to
be powered down when it should be enabled. As a result channels that are
supposed to be handled by the second ADC return invalid conversion results.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Fixes: bdc8cda1d010 ("iio:adc: Add Xilinx XADC driver")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/xilinx-xadc-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/xilinx-xadc-core.c b/drivers/iio/adc/xilinx-xadc-core.c
index ec227b358cd6..f50e04a8b0ec 100644
--- a/drivers/iio/adc/xilinx-xadc-core.c
+++ b/drivers/iio/adc/xilinx-xadc-core.c
@@ -722,13 +722,14 @@ static int xadc_power_adc_b(struct xadc *xadc, unsigned int seq_mode)
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
 
-- 
2.26.1


