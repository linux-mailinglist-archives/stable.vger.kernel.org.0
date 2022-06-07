Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B6654134C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356659AbiFGT6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357524AbiFGT4v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:56:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A05AFAE4;
        Tue,  7 Jun 2022 11:24:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36507B82383;
        Tue,  7 Jun 2022 18:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864B5C385A2;
        Tue,  7 Jun 2022 18:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626237;
        bh=gGqQsQ13HffQfxEIYsnJmO3ZT8DclDvMintTYDYyOBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rkeE1GQm9Kj2dluiuzG3TBtBOcUMEI8Qb1i7jWIYCuCPiH2TkcmteN8eFvLAhRrmh
         Jln7XyW5+3sUGaFDuaZZbyGaNMcB5YxnpQSBxplEtRnCllV2X/paxidlL4Y59PkoNe
         sa/zKPju2zIFpCMQM/wYx9eJu8a1eb1mpa2IiH7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Tsung Hsieh <chentsung@chromium.org>,
        Pratyush Yadav <p.yadav@ti.com>,
        Michael Walle <michael@walle.cc>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 307/772] mtd: spi-nor: core: Check written SR value in spi_nor_write_16bit_sr_and_check()
Date:   Tue,  7 Jun 2022 18:58:19 +0200
Message-Id: <20220607164958.071953284@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Tsung Hsieh <chentsung@chromium.org>

[ Upstream commit 70dd83d737d8900b2d98db6dc6b928c596334d37 ]

Read back Status Register 1 to ensure that the written byte match the
received value and return -EIO if read back test failed.

Without this patch, spi_nor_write_16bit_sr_and_check() only check the
second half of the 16bit. It causes errors like spi_nor_sr_unlock()
return success incorrectly when spi_nor_write_16bit_sr_and_check()
doesn't write SR successfully.

Fixes: 39d1e3340c73 ("mtd: spi-nor: Fix clearing of QE bit on lock()/unlock()")
Signed-off-by: Chen-Tsung Hsieh <chentsung@chromium.org>
Signed-off-by: Pratyush Yadav <p.yadav@ti.com>
Reviewed-by: Michael Walle <michael@walle.cc>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Acked-by: Pratyush Yadav <p.yadav@ti.com>
Link: https://lore.kernel.org/r/20220126073227.3401275-1-chentsung@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index cc155f6c6c68..3d78f7f97f96 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -1007,6 +1007,15 @@ static int spi_nor_write_16bit_sr_and_check(struct spi_nor *nor, u8 sr1)
 	if (ret)
 		return ret;
 
+	ret = spi_nor_read_sr(nor, sr_cr);
+	if (ret)
+		return ret;
+
+	if (sr1 != sr_cr[0]) {
+		dev_dbg(nor->dev, "SR: Read back test failed\n");
+		return -EIO;
+	}
+
 	if (nor->flags & SNOR_F_NO_READ_CR)
 		return 0;
 
-- 
2.35.1



