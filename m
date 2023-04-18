Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2C66E62B8
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbjDRMey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbjDRMeo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:34:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF44E125A2
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:34:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C04B063265
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C9FC433EF;
        Tue, 18 Apr 2023 12:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821280;
        bh=Fw2A4ipcJcZC4qwi9MPkoNFOsuEwHAAOXOVBpAqgCuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uac5cDdgT8J7ScZLH4yRucVMucVccwQnrz1sd4YG3hGDbRmyDx7JJi8AZI7r1Sar2
         4C6WwZdLcoRNwAA9xDnt/bGIszXWSB4FshZb7hwAdFcAiIYi1yLeIo8TvtlsaZgFZE
         sNezrsTNk4JFrAUJTRvLG0AsrPwQRZszmjwgAWPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe Kerello <christophe.kerello@foss.st.com>,
        Tudor Ambarus <tudor.ambarus@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 067/124] mtd: rawnand: stm32_fmc2: use timings.mode instead of checking tRC_min
Date:   Tue, 18 Apr 2023 14:21:26 +0200
Message-Id: <20230418120312.286126241@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Kerello <christophe.kerello@foss.st.com>

commit ddbb664b6ab8de7dffa388ae0c88cd18616494e5 upstream.

Use timings.mode value instead of checking tRC_min timing
for EDO mode support.

Signed-off-by: Christophe Kerello <christophe.kerello@foss.st.com>
Fixes: 2cd457f328c1 ("mtd: rawnand: stm32_fmc2: add STM32 FMC2 NAND flash controller driver")
Cc: stable@vger.kernel.org #v5.10+
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230328155819.225521-3-christophe.kerello@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/stm32_fmc2_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/stm32_fmc2_nand.c
+++ b/drivers/mtd/nand/raw/stm32_fmc2_nand.c
@@ -1525,7 +1525,7 @@ static int stm32_fmc2_nfc_setup_interfac
 	if (IS_ERR(sdrt))
 		return PTR_ERR(sdrt);
 
-	if (sdrt->tRC_min < 30000)
+	if (conf->timings.mode > 3)
 		return -EOPNOTSUPP;
 
 	if (chipnr == NAND_DATA_IFACE_CHECK_ONLY)


