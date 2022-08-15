Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEA8B593F86
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348823AbiHOVhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349015AbiHOVg2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:36:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659EA101593;
        Mon, 15 Aug 2022 12:25:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00C046100A;
        Mon, 15 Aug 2022 19:25:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6227C433D7;
        Mon, 15 Aug 2022 19:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591548;
        bh=gjLriqIdzmeysA+p9MegAImHwIi1C5sySXkdAMnieJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XECm0eZ7n2LfsR7fHSElPwr3Z6ZuPMUr3cu0FdLNWzjU43uzXTFeqGeDfdwgj82a8
         2Ldyo77ropvQ9UE9MFsYu+tIZW0ICDpQtLANQ1dDTxyj3S3XWThxCicPGpTtPvmpvs
         /f+Tj629spyFGAgsYXk9HnsH7X63sQRuggzVUy54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0614/1095] iio: adc: ti-adc108s102: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:13 +0200
Message-Id: <20220815180454.909094176@linuxfoundation.org>
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

[ Upstream commit 6909fe17888b66ea53ebb15640f82b97daa587a0 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Dual fixes tags as two cases that were introduced in different patches.
One of those patches is a fix however and likely to have been backported
to stable kernels.

Note the second alignment marking is likely to be unnecessary, but is
left for now to keep this fix simple.

Fixes: 3691e5a69449 ("iio: adc: add driver for the ti-adc084s021 chip")
Fixes: cbe5c6977604 ("iio: adc: ti-adc108s102: Fix alignment of buffer pushed to iio buffers.")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-31-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ti-adc108s102.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ti-adc108s102.c b/drivers/iio/adc/ti-adc108s102.c
index c8e48881c37f..c82a161630e1 100644
--- a/drivers/iio/adc/ti-adc108s102.c
+++ b/drivers/iio/adc/ti-adc108s102.c
@@ -77,8 +77,8 @@ struct adc108s102_state {
 	 *  tx_buf: 8 channel read commands, plus 1 dummy command
 	 *  rx_buf: 1 dummy response, 8 channel responses
 	 */
-	__be16				rx_buf[9] ____cacheline_aligned;
-	__be16				tx_buf[9] ____cacheline_aligned;
+	__be16				rx_buf[9] __aligned(IIO_DMA_MINALIGN);
+	__be16				tx_buf[9] __aligned(IIO_DMA_MINALIGN);
 };
 
 #define ADC108S102_V_CHAN(index)					\
-- 
2.35.1



