Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0366F566BA7
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbiGEMJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234417AbiGEMHb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:07:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30DB18E37;
        Tue,  5 Jul 2022 05:06:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E797B817D6;
        Tue,  5 Jul 2022 12:06:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6285C341CD;
        Tue,  5 Jul 2022 12:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022781;
        bh=eWhg2Htyke+OsaZs7/m9A1zorj1Ngbbnj7Lp253PPtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RlGhsr6RVpI6o5eCVRxMAmOEGzBcWx6o3hc16PzOIX5LBW3JjD9l6Zl3fAJnKvL+i
         PRTZbLECxmGbU7jxFd3FY+thGImSFvSoObinjJSCy9WjIXrcD3EPgVZCuDyleCBFnc
         JzbOWW1CDZZT6UM0uRYEDb1cayfnN1/GW2etnEW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Ruyi <lv.ruyi@zte.com.cn>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 26/58] nfc: nfcmrvl: Fix irq_of_parse_and_map() return value
Date:   Tue,  5 Jul 2022 13:58:02 +0200
Message-Id: <20220705115611.018632184@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115610.236040773@linuxfoundation.org>
References: <20220705115610.236040773@linuxfoundation.org>
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
@@ -186,9 +186,9 @@ static int nfcmrvl_i2c_parse_dt(struct d
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
@@ -129,9 +129,9 @@ static int nfcmrvl_spi_parse_dt(struct d
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
 


