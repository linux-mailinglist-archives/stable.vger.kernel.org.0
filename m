Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3845940F5
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349045AbiHOVig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348693AbiHOVhC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:37:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9F3302;
        Mon, 15 Aug 2022 12:26:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21E1EB810C6;
        Mon, 15 Aug 2022 19:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60079C433C1;
        Mon, 15 Aug 2022 19:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591615;
        bh=Wqu/9eB3IBw4Rlu01YrHumyUkZpx4nb+nPdYyBgmIMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NxXoQ0w8ht2xcj1wHScdJoaEzxAmsM6BYR57mOSRUIvmIfcwoSG7LIOjmU6XpH3dY
         mAoXl5QaiNoXq43FL634/cnD5nVqbe9EuIC72lCWMNKejNm/e0EysrvVvhC8/3mi4v
         Gwau9BqhcPiMcYenjA6A8QGest3tW2aeox78O0Uk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        David Lechner <david@lechnology.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0620/1095] iio: adc: ti-ads7950: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:19 +0200
Message-Id: <20220815180455.122978329@linuxfoundation.org>
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

[ Upstream commit dd54ba8b2469f6ae665c529623a9454ce5293ca8 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Update the comment to include 'may'.

Fixes: 902c4b2446d4 ("iio: adc: New driver for TI ADS7950 chips")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: David Lechner <david@lechnology.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-37-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ti-ads7950.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ti-ads7950.c b/drivers/iio/adc/ti-ads7950.c
index e3658b969c5b..2cc9a9bd9db6 100644
--- a/drivers/iio/adc/ti-ads7950.c
+++ b/drivers/iio/adc/ti-ads7950.c
@@ -102,11 +102,11 @@ struct ti_ads7950_state {
 	unsigned int		gpio_cmd_settings_bitmask;
 
 	/*
-	 * DMA (thus cache coherency maintenance) requires the
+	 * DMA (thus cache coherency maintenance) may require the
 	 * transfer buffers to live in their own cache lines.
 	 */
 	u16 rx_buf[TI_ADS7950_MAX_CHAN + 2 + TI_ADS7950_TIMESTAMP_SIZE]
-							____cacheline_aligned;
+		__aligned(IIO_DMA_MINALIGN);
 	u16 tx_buf[TI_ADS7950_MAX_CHAN + 2];
 	u16 single_tx;
 	u16 single_rx;
-- 
2.35.1



