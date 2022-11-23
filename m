Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 916A06354A5
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237107AbiKWJIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237125AbiKWJIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:08:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D445623BE9
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:08:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F386B81EF2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C3EC433D7;
        Wed, 23 Nov 2022 09:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194502;
        bh=lN7LWd8fpUKRteACJxqs8EUEmMM5J6qINk4Mj9sT32o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XeeROYqEDG2gao07I/QakkEHxc5oN9BGweQ1/zf0J8pjCjGBoNQfmlfxasQUijAP7
         wlSbPy9g0nS0ryKOAHiIFRoyfiAhiz4UBEOvnCt3YHk2GzTF0P9uh4h9eqIgaNp/XC
         /FKskcky9zwBMZgowMacnPitMJXT+oPGoyrksmz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yann Gautier <yann.gautier@foss.st.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 095/114] mmc: core: properly select voltage range without power cycle
Date:   Wed, 23 Nov 2022 09:51:22 +0100
Message-Id: <20221123084555.589931514@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yann Gautier <yann.gautier@foss.st.com>

commit 39a72dbfe188291b156dd6523511e3d5761ce775 upstream.

In mmc_select_voltage(), if there is no full power cycle, the voltage
range selected at the end of the function will be on a single range
(e.g. 3.3V/3.4V). To keep a range around the selected voltage (3.2V/3.4V),
the mask shift should be reduced by 1.

This issue was triggered by using a specific SD-card (Verbatim Premium
16GB UHS-1) on an STM32MP157C-DK2 board. This board cannot do UHS modes
and there is no power cycle. And the card was failing to switch to
high-speed mode. When adding the range 3.2V/3.3V for this card with the
proposed shift change, the card can switch to high-speed mode.

Fixes: ce69d37b7d8f ("mmc: core: Prevent violation of specs while initializing cards")
Signed-off-by: Yann Gautier <yann.gautier@foss.st.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221028073740.7259-1-yann.gautier@foss.st.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/core.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1461,7 +1461,13 @@ u32 mmc_select_voltage(struct mmc_host *
 		mmc_power_cycle(host, ocr);
 	} else {
 		bit = fls(ocr) - 1;
-		ocr &= 3 << bit;
+		/*
+		 * The bit variable represents the highest voltage bit set in
+		 * the OCR register.
+		 * To keep a range of 2 values (e.g. 3.2V/3.3V and 3.3V/3.4V),
+		 * we must shift the mask '3' with (bit - 1).
+		 */
+		ocr &= 3 << (bit - 1);
 		if (bit != host->ios.vdd)
 			dev_warn(mmc_dev(host), "exceeding card's volts\n");
 	}


