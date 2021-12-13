Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB77D472221
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 09:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbhLMIJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 03:09:07 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:45544 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhLMIJH (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 13 Dec 2021 03:09:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BD69FCE0B59
        for <Stable@vger.kernel.org>; Mon, 13 Dec 2021 08:09:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923ECC00446;
        Mon, 13 Dec 2021 08:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639382944;
        bh=4wK9TYs9DnW+KyWKvVcnFXlFapVIRhX1TdFPA5kmHuw=;
        h=Subject:To:Cc:From:Date:From;
        b=u4ra3mySyamQQwoqYqG1rVFDu13s4zLKRnkihNyk2ygCudMwAutEvSqgcGai5/Xnn
         Epd6K+1KWOg2ONgFH1ZwIgBCiQVWZtS4GsqtnfsHUg6O/aTcPPIZj1tcSR1JtxTW0v
         ANipy/n8WY8OjsrktBH0Q6dVj1rFoz4OcA+hNWrs=
Subject: FAILED: patch "[PATCH] iio: adc: stm32: fix a current leak by resetting pcsel before" failed to apply to 4.14-stable tree
To:     fabrice.gasnier@foss.st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, olivier.moysan@foss.st.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Dec 2021 09:08:53 +0100
Message-ID: <16393829331942@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f711f28e71e965c0d1141c830fa7131b41abbe75 Mon Sep 17 00:00:00 2001
From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Date: Fri, 22 Oct 2021 14:19:29 +0200
Subject: [PATCH] iio: adc: stm32: fix a current leak by resetting pcsel before
 disabling vdda

Some I/Os are connected to ADC input channels, when the corresponding bit
in PCSEL register are set on STM32H7 and STM32MP15. This is done in the
prepare routine of stm32-adc driver.
There are constraints here, as PCSEL shouldn't be set when VDDA supply
is disabled. Enabling/disabling of VDDA supply in done via stm32-adc-core
runtime PM routines (before/after ADC is enabled/disabled).

Currently, PCSEL remains set when disabling ADC. Later on, PM runtime
can disable the VDDA supply. This creates some conditions on I/Os that
can start to leak current.
So PCSEL needs to be cleared when disabling the ADC.

Fixes: 95e339b6e85d ("iio: adc: stm32: add support for STM32H7")
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Reviewed-by: Olivier Moysan <olivier.moysan@foss.st.com>
Link: https://lore.kernel.org/r/1634905169-23762-1-git-send-email-fabrice.gasnier@foss.st.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/adc/stm32-adc.c b/drivers/iio/adc/stm32-adc.c
index 6245434f8377..60f2ccf7e342 100644
--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -1117,6 +1117,7 @@ static void stm32h7_adc_unprepare(struct iio_dev *indio_dev)
 {
 	struct stm32_adc *adc = iio_priv(indio_dev);
 
+	stm32_adc_writel(adc, STM32H7_ADC_PCSEL, 0);
 	stm32h7_adc_disable(indio_dev);
 	stm32_adc_int_ch_disable(adc);
 	stm32h7_adc_enter_pwr_down(adc);

