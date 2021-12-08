Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B0C46D3C5
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 13:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233807AbhLHM5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 07:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233796AbhLHM5l (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 8 Dec 2021 07:57:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F95BC061746
        for <Stable@vger.kernel.org>; Wed,  8 Dec 2021 04:54:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE391B81F7E
        for <Stable@vger.kernel.org>; Wed,  8 Dec 2021 12:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C55C00446;
        Wed,  8 Dec 2021 12:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638968046;
        bh=4oKwn1DBqQyNlyzHlkivVAw6MoyWpBm8e6F62/ZoyEc=;
        h=Subject:To:From:Date:From;
        b=JsZkM27rD0JBrOW1ikaaqIIUlFoPyTzTtAqcVu94AFvmoS/vpGuxKo27zQDk5GGab
         9YLSq40VHtSiTsV1q0bC/BdRp7RjcJjTME2BTmFGrSHqe+qxHhbd/P0TmjxGTgGDwV
         iji5kSSJEmFXcoewj3HmgTotpso1r5bGMpQjkKY8=
Subject: patch "iio: adc: stm32: fix a current leak by resetting pcsel before" added to char-misc-linus
To:     fabrice.gasnier@foss.st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, olivier.moysan@foss.st.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 08 Dec 2021 13:53:53 +0100
Message-ID: <16389680334820@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: stm32: fix a current leak by resetting pcsel before

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f711f28e71e965c0d1141c830fa7131b41abbe75 Mon Sep 17 00:00:00 2001
From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Date: Fri, 22 Oct 2021 14:19:29 +0200
Subject: iio: adc: stm32: fix a current leak by resetting pcsel before
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
---
 drivers/iio/adc/stm32-adc.c | 1 +
 1 file changed, 1 insertion(+)

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
-- 
2.34.1


