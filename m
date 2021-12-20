Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5800347AD3D
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236244AbhLTOvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237021AbhLTOrx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:47:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C918C061379;
        Mon, 20 Dec 2021 06:44:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DEB6B80EEF;
        Mon, 20 Dec 2021 14:44:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AF0C36AE8;
        Mon, 20 Dec 2021 14:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011471;
        bh=IjIXePeDOKbCVKU97Of6ECgPY5gGQ49V92TvZoL1qLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1bRbWuTeqORHXjTQk6jGXlEJoK5ByPz4JVUqjDYyDLlZfxlwoopda5Qm71jT2FOul
         BodMDH+Pi8ifq7YZUV+vNaR6iCPk3Ch8hSqUuAyQ5n09s8iiLT6+4+Mnr2qvkjJVFx
         4ulAFkq7t2exSBQ8Jb3aGLjL+64YFdZHi5X1soGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Olivier Moysan <olivier.moysan@foss.st.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 09/71] iio: adc: stm32: fix a current leak by resetting pcsel before disabling vdda
Date:   Mon, 20 Dec 2021 15:33:58 +0100
Message-Id: <20211220143025.998752805@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>

commit f711f28e71e965c0d1141c830fa7131b41abbe75 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/stm32-adc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -933,6 +933,7 @@ pwr_dwn:
 
 static void stm32h7_adc_unprepare(struct stm32_adc *adc)
 {
+	stm32_adc_writel(adc, STM32H7_ADC_PCSEL, 0);
 	stm32h7_adc_disable(adc);
 	stm32h7_adc_enter_pwr_down(adc);
 }


