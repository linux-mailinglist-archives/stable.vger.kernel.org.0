Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4458635571
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237323AbiKWJTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237340AbiKWJTW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:19:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B38A26DA
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:19:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEC2DB81EE5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365FBC433C1;
        Wed, 23 Nov 2022 09:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195158;
        bh=HlCaUuMmHfxMuJ0ffJRVaWlQ19yPja1m2apHeFztfrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LH/pQ8QtuuBRVAMDTuKHDba66dE3TSYaXOfSyQyQZ1JWB1NPLQZ/lXMvNZuXUwjva
         N9B/aAG6ke2hmfAz4HNHlLAL0YHjeuMRTjy1UYB8esy2wG3Hz5vR6g0efu8EzI1nLp
         GLMMrqJOyzfRAxN24cyz3P9vfWLgdbG6KfooOc3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yann Gautier <yann.gautier@foss.st.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 134/156] mmc: core: properly select voltage range without power cycle
Date:   Wed, 23 Nov 2022 09:51:31 +0100
Message-Id: <20221123084602.763142352@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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
@@ -1145,7 +1145,13 @@ u32 mmc_select_voltage(struct mmc_host *
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


