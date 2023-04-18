Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE8F6E6465
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbjDRMsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbjDRMsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:48:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EDA15A04
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:48:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA98F6326B
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F253BC433D2;
        Tue, 18 Apr 2023 12:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822106;
        bh=fzAd6xMVxPqoigDacFBZ1ZFRV4kxd6oevsFExFdBmOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sd7Lxa5Ar33uxelERO+0I80Mv2TYT/47GH6M/zoOLijzyXBbAmqtcUJAlh8Yg5vEN
         tkmGjvoQLmsJfUxQfMcHyjmk6gJ09qvtBYkeKsxoGgC+hbPgGoF13+AcJOCJsPdCrx
         hAg0Xpq9D2x/Y88F+o01ufL7Pt57RzODhXSSV5+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe Kerello <christophe.kerello@foss.st.com>,
        Tudor Ambarus <tudor.ambarus@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.2 024/139] mtd: rawnand: stm32_fmc2: use timings.mode instead of checking tRC_min
Date:   Tue, 18 Apr 2023 14:21:29 +0200
Message-Id: <20230418120314.552443035@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
@@ -1531,7 +1531,7 @@ static int stm32_fmc2_nfc_setup_interfac
 	if (IS_ERR(sdrt))
 		return PTR_ERR(sdrt);
 
-	if (sdrt->tRC_min < 30000)
+	if (conf->timings.mode > 3)
 		return -EOPNOTSUPP;
 
 	if (chipnr == NAND_DATA_IFACE_CHECK_ONLY)


