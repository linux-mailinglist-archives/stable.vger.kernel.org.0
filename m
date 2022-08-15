Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C771B594086
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348168AbiHOVgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348792AbiHOVft (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:35:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECA7FFF62;
        Mon, 15 Aug 2022 12:25:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D822CB810C6;
        Mon, 15 Aug 2022 19:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C36AC433C1;
        Mon, 15 Aug 2022 19:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591505;
        bh=AjPHz77vqqBU48LoSmJeUUwmzkiS0wYCFE5oYXiVF7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0USe6qc7CT0xDXuUpjHx57RE1tOwssPNZpukYlXBLP3gu27GGDFc7qQ/402bjfTF6
         9TaPmQkef1AyRiLH3DWZWD/cyVQZAlL2tHkaKoR3MLS+0uoVixvsLJFuGdnXocKgXk
         GRyypUXT2pAjj2ZllMov4FJh2u39z/NeJh3uym/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0601/1095] iio: adc: ad7887: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:00 +0200
Message-Id: <20220815180454.394611037@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

[ Upstream commit b330ea6bc52468e183ced79189ff064f36c64aa7 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Update the comment to include 'may'.

Fixes tag is clearly not where this was introduced but it is very unlikely
anyone will back port it past that point.

Fixes: 65dd3d3d7a9b ("staging:iio:ad7887: Squash everything into one file")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-18-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7887.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/ad7887.c b/drivers/iio/adc/ad7887.c
index f64999714a4d..965bdc8aa696 100644
--- a/drivers/iio/adc/ad7887.c
+++ b/drivers/iio/adc/ad7887.c
@@ -66,13 +66,12 @@ struct ad7887_state {
 	unsigned char			tx_cmd_buf[4];
 
 	/*
-	 * DMA (thus cache coherency maintenance) requires the
+	 * DMA (thus cache coherency maintenance) may require the
 	 * transfer buffers to live in their own cache lines.
 	 * Buffer needs to be large enough to hold two 16 bit samples and a
 	 * 64 bit aligned 64 bit timestamp.
 	 */
-	unsigned char data[ALIGN(4, sizeof(s64)) + sizeof(s64)]
-		____cacheline_aligned;
+	unsigned char data[ALIGN(4, sizeof(s64)) + sizeof(s64)] __aligned(IIO_DMA_MINALIGN);
 };
 
 enum ad7887_supported_device_ids {
-- 
2.35.1



