Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C13C9595028
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbiHPEhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbiHPEgz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:36:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37D99C2D0;
        Mon, 15 Aug 2022 13:26:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E2B5B81197;
        Mon, 15 Aug 2022 20:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79027C433D6;
        Mon, 15 Aug 2022 20:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595208;
        bh=gjLriqIdzmeysA+p9MegAImHwIi1C5sySXkdAMnieJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pju+3NPd3O3LPf69s4V9MVgq4Lz4JD6iTbiIXeYkBI+L62iCx3zwWqBLKeR9/A4pH
         Ckx4VjHU81T1TNJf+qDysF7OlQX5jZ/dinxK8Vx9zy7gB0nXzv41MdpD7lOF1sbTkJ
         U0FwQTzc3eX2RsKEAUgxCU4lSs4XZO8KflOfc/xI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0659/1157] iio: adc: ti-adc108s102: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:15 +0200
Message-Id: <20220815180506.089544338@linuxfoundation.org>
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



