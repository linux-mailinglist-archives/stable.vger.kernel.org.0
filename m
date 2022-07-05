Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2DE2566DB6
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238011AbiGEM04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236823AbiGEMZ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:25:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DDA17E22;
        Tue,  5 Jul 2022 05:17:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DCDBB817CC;
        Tue,  5 Jul 2022 12:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119B5C341C7;
        Tue,  5 Jul 2022 12:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023458;
        bh=e5mcciVgW1C+/q37f4/+fFKAhTA1T2u0ZfsCKlYxsEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IYTyMBCFPEdRuAzHj7+i6hdvz1IyFaAGCTlmccV7qjV+PmMAF0P04rX1lLyhQmOnh
         OjaOCIbad5E/0ErU32hCOz9ZarOT8MlMotIpaSqBByChPjWhIfptu+752vU91MMbGa
         Ln6KxhhUV6YGT2X4vdWPG+L3qZQmFWhgJssFNqaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Ruyi <lv.ruyi@zte.com.cn>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.18 066/102] nfc: nfcmrvl: Fix irq_of_parse_and_map() return value
Date:   Tue,  5 Jul 2022 13:58:32 +0200
Message-Id: <20220705115620.280776926@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 5a478a653b4cca148d5c89832f007ec0809d7e6d upstream.

The irq_of_parse_and_map() returns 0 on failure, not a negative ERRNO.

Reported-by: Lv Ruyi <lv.ruyi@zte.com.cn>
Fixes: caf6e49bf6d0 ("NFC: nfcmrvl: add spi driver")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220627124048.296253-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/nfcmrvl/i2c.c |    6 +++---
 drivers/nfc/nfcmrvl/spi.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/nfc/nfcmrvl/i2c.c
+++ b/drivers/nfc/nfcmrvl/i2c.c
@@ -167,9 +167,9 @@ static int nfcmrvl_i2c_parse_dt(struct d
 		pdata->irq_polarity = IRQF_TRIGGER_RISING;
 
 	ret = irq_of_parse_and_map(node, 0);
-	if (ret < 0) {
-		pr_err("Unable to get irq, error: %d\n", ret);
-		return ret;
+	if (!ret) {
+		pr_err("Unable to get irq\n");
+		return -EINVAL;
 	}
 	pdata->irq = ret;
 
--- a/drivers/nfc/nfcmrvl/spi.c
+++ b/drivers/nfc/nfcmrvl/spi.c
@@ -115,9 +115,9 @@ static int nfcmrvl_spi_parse_dt(struct d
 	}
 
 	ret = irq_of_parse_and_map(node, 0);
-	if (ret < 0) {
-		pr_err("Unable to get irq, error: %d\n", ret);
-		return ret;
+	if (!ret) {
+		pr_err("Unable to get irq\n");
+		return -EINVAL;
 	}
 	pdata->irq = ret;
 


