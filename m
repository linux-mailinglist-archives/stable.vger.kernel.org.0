Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE6155CADB
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbiF0JOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 05:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbiF0JOc (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 27 Jun 2022 05:14:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9E35590
        for <Stable@vger.kernel.org>; Mon, 27 Jun 2022 02:14:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 044B0B80ECB
        for <Stable@vger.kernel.org>; Mon, 27 Jun 2022 09:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC17C3411D;
        Mon, 27 Jun 2022 09:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656321269;
        bh=9ntuZAJTsolU+4xV9g904NlmdV4yiZEn5+xoEWQGRQE=;
        h=Subject:To:Cc:From:Date:From;
        b=VSRJmFxyOyrbxVaxJdPr/VTjMBe3IPY7uCPOcQJAgPyg0gv3A2/JRhkKXWDuG914u
         cxxUDDVyx9DRxU9oUnB4MSqEn4bwXEOvKRigKx9i9HIqXuWdqjYn1Do9BbjFnGE0NW
         DnKSkukopD71BxU9Vk0n6YQmLw8i4/wwgMGWgHZw=
Subject: FAILED: patch "[PATCH] iio: adc: stm32: fix maximum clock rate for stm32mp15x" failed to apply to 4.19-stable tree
To:     olivier.moysan@foss.st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, fabrice.gasnier@foss.st.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Jun 2022 11:14:19 +0200
Message-ID: <165632125921410@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

From 990539486e7e311fb5dab1bf4d85d1a8973ae644 Mon Sep 17 00:00:00 2001
From: Olivier Moysan <olivier.moysan@foss.st.com>
Date: Thu, 9 Jun 2022 11:52:34 +0200
Subject: [PATCH] iio: adc: stm32: fix maximum clock rate for stm32mp15x

Change maximum STM32 ADC input clock rate to 36MHz, as specified
in STM32MP15x datasheets.

Fixes: d58c67d1d851 ("iio: adc: stm32-adc: add support for STM32MP1")
Signed-off-by: Olivier Moysan <olivier.moysan@foss.st.com>
Reviewed-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/20220609095234.375925-1-olivier.moysan@foss.st.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/adc/stm32-adc-core.c b/drivers/iio/adc/stm32-adc-core.c
index bb04deeb7992..3efb8c404ccc 100644
--- a/drivers/iio/adc/stm32-adc-core.c
+++ b/drivers/iio/adc/stm32-adc-core.c
@@ -809,7 +809,7 @@ static const struct stm32_adc_priv_cfg stm32h7_adc_priv_cfg = {
 static const struct stm32_adc_priv_cfg stm32mp1_adc_priv_cfg = {
 	.regs = &stm32h7_adc_common_regs,
 	.clk_sel = stm32h7_adc_clk_sel,
-	.max_clk_rate_hz = 40000000,
+	.max_clk_rate_hz = 36000000,
 	.has_syscfg = HAS_VBOOSTER | HAS_ANASWVDD,
 	.num_irqs = 2,
 	.num_adcs = 2,

