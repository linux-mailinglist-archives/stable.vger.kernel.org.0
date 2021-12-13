Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7728472222
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 09:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhLMIJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 03:09:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhLMIJL (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 13 Dec 2021 03:09:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF583C06173F
        for <Stable@vger.kernel.org>; Mon, 13 Dec 2021 00:09:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EAC79CE0B59
        for <Stable@vger.kernel.org>; Mon, 13 Dec 2021 08:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A37C00446;
        Mon, 13 Dec 2021 08:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639382947;
        bh=DL0nWj4+SCym3AwLYzHcdjV7RYTLWYWSrvXqEbjLbhY=;
        h=Subject:To:Cc:From:Date:From;
        b=Y/SbilMEkMmtfYeAMmid5osrQEl17WxskFYhxfxdiYftAd2HPJyU2e56sL2vBOnQq
         CVFzIqgGtjr/cDMTjrNUHWQICL/+VCcJOiKSDKzMSiwk2kaeQ1wQnoLymnFyiGAU01
         V/H3RqmOQc+CZSwEYeUh9LfXy3trPdu1RfT0rlV4=
Subject: FAILED: patch "[PATCH] iio: adc: stm32: fix a current leak by resetting pcsel before" failed to apply to 4.19-stable tree
To:     fabrice.gasnier@foss.st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, olivier.moysan@foss.st.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Dec 2021 09:08:53 +0100
Message-ID: <163938293315183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

