Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3771594AAD
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352594AbiHPAFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356625AbiHPACl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:02:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9644B4AD;
        Mon, 15 Aug 2022 13:24:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 595C561073;
        Mon, 15 Aug 2022 20:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BBA2C433D6;
        Mon, 15 Aug 2022 20:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595051;
        bh=d4ycwxc2rDoKWptparan665MelJUrI1M2sFJzZh0K1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HvOEx1ZUTxfNuoECvJfSYQFs+oOSUuphsxAb6UxQgIejvo+zKS+52gKQw56eiRMKh
         a1uvieJumkvFOZ3SxZi1KYjeR1GV1aMJaHscjTwiIyH4LxiBdQ+V9XuXE6jB/26Iv5
         BmLNLCFI+lt3mHia9nfAVw6m4oTQQ4IaCtb+GBWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0641/1157] iio: adc: ad7298: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 19:59:57 +0200
Message-Id: <20220815180505.359733110@linuxfoundation.org>
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

[ Upstream commit 585c9772f883da3ac425e2e8277b2aaceb201f38 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: be7fd3b86ad2 ("iio:adc:ad7298 make the tx and rx buffers __be16")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-13-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7298.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad7298.c b/drivers/iio/adc/ad7298.c
index 3f4e73f7d35a..c0430f71f592 100644
--- a/drivers/iio/adc/ad7298.c
+++ b/drivers/iio/adc/ad7298.c
@@ -49,7 +49,7 @@ struct ad7298_state {
 	 * DMA (thus cache coherency maintenance) requires the
 	 * transfer buffers to live in their own cache lines.
 	 */
-	__be16				rx_buf[12] ____cacheline_aligned;
+	__be16				rx_buf[12] __aligned(IIO_DMA_MINALIGN);
 	__be16				tx_buf[2];
 };
 
-- 
2.35.1



