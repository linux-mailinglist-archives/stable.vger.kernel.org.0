Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03E9594ADF
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356133AbiHPAHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356265AbiHPACK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:02:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451E5168A79;
        Mon, 15 Aug 2022 13:23:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5206860F71;
        Mon, 15 Aug 2022 20:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58898C433D6;
        Mon, 15 Aug 2022 20:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595022;
        bh=qW9AXJ5zCJJ/JZcmqysahmvVrivteExCNuJWGepCaWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GR6PUxTIXIpfCmXwk+ebvOjeAC0Dzcy4wPoa8erzu5cPrWtiVeRUvdVfGD9O/fn48
         XTgiXoGcXsG3ZR7qlX7gAjZT1rntvBI8vIsNYpdNtPIaaYhGQ01rmQDempbo07RZaT
         5tUi1lGMqDTEOv/HrJ+26acr9Tl6U9zHdPE+WK7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Puranjay Mohan <puranjay12@gmail.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0633/1157] iio: accel: adxl355: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 19:59:49 +0200
Message-Id: <20220815180505.011821883@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 46403dcf3a7cbd24b86f809fd79962f4d6b137c5 ]

 ____cacheline_aligned is insufficient guarantee for non-coherent DMA.
Switch to the updated IIO_DMA_MINALIGN definition.

Fixes: 327a0eaf19d53 ("iio: accel: adxl355: Add triggered buffer support")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Puranjay Mohan <puranjay12@gmail.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-4-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/adxl355_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/accel/adxl355_core.c b/drivers/iio/accel/adxl355_core.c
index 7561399daef3..4bc648eac8b2 100644
--- a/drivers/iio/accel/adxl355_core.c
+++ b/drivers/iio/accel/adxl355_core.c
@@ -177,7 +177,7 @@ struct adxl355_data {
 			u8 buf[14];
 			s64 ts;
 		} buffer;
-	} ____cacheline_aligned;
+	} __aligned(IIO_DMA_MINALIGN);
 };
 
 static int adxl355_set_op_mode(struct adxl355_data *data,
-- 
2.35.1



