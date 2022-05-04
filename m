Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA4351A888
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355774AbiEDRLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356936AbiEDRJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF33F47396;
        Wed,  4 May 2022 09:56:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B3B4B8279C;
        Wed,  4 May 2022 16:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29397C385A5;
        Wed,  4 May 2022 16:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683390;
        bh=2xcGUSWGTwbyBOA5NeTWHBkCsgH79GDnE6WyvaDrGyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RfbiYnWHoFZMtg6J9ah1JyPSncN+jYXvBJhM16n6cojNojd41+oNx/7xZ8SqORuOK
         VwoVhjfAS2s0BKK+SBF2iIpcRlKeimCYrtUoMYADejvNiKlw7sbUDDkzocBC4k4VTw
         mffo71s/ra3S/g7oS2TK9JD9yfpysQT3Toq2FOh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 062/225] iio: dac: ad3552r: fix signedness bug in ad3552r_reset()
Date:   Wed,  4 May 2022 18:45:00 +0200
Message-Id: <20220504153115.705133387@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 460bfa65b0de72f4d8a808bc7cfb1cb591a95b18 ]

The "val" variable is used to store either negative error codes from
ad3552r_read_reg_wrapper() or positive u16 values on success.  It needs
to be signed for the error handling to work correctly.

Fixes: 8f2b54824b28 ("drivers:iio:dac: Add AD3552R driver support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20220316122354.GA16825@kili
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad3552r.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/dac/ad3552r.c b/drivers/iio/dac/ad3552r.c
index 97f13c0b9631..e0a93b27e0e8 100644
--- a/drivers/iio/dac/ad3552r.c
+++ b/drivers/iio/dac/ad3552r.c
@@ -656,7 +656,7 @@ static int ad3552r_reset(struct ad3552r_desc *dac)
 {
 	struct reg_addr_pool addr;
 	int ret;
-	u16 val;
+	int val;
 
 	dac->gpio_reset = devm_gpiod_get_optional(&dac->spi->dev, "reset",
 						  GPIOD_OUT_LOW);
-- 
2.35.1



