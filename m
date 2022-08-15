Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97EA5594017
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348846AbiHOVjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348845AbiHOVhp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:37:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B8DDEAB;
        Mon, 15 Aug 2022 12:27:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA138610A1;
        Mon, 15 Aug 2022 19:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969E1C433D6;
        Mon, 15 Aug 2022 19:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591651;
        bh=sbKiUkLWI4e9wRtVslmNKBxQISuUd3FwZfgPSd6f2fE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dGuhKSbsXS/AGKCzk1bDZkWcLeymfE1EbOFcg82Lg75GARs2REkJephyDRAMSUaHu
         sqo1tFW+3kbUt5BXdWVqURfvHWgqCzM1euGt2I38xCM2XaroB96PItGIB4QvcKFwzK
         Z98f8MJYZ/Vw/TdxKnph2utGRdWKVCm+0aqZ5F4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0621/1095] iio: adc: ti-ads8344: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:20 +0200
Message-Id: <20220815180455.168008422@linuxfoundation.org>
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

[ Upstream commit 8966b11e5a14aaabc747ee97a7942fd50a681402 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: 8dd2d7c0fed7 ("iio: adc: Add driver for the TI ADS8344 A/DC chips")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-38-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ti-ads8344.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ti-ads8344.c b/drivers/iio/adc/ti-ads8344.c
index c96d2a9ba924..bbd85cb47f81 100644
--- a/drivers/iio/adc/ti-ads8344.c
+++ b/drivers/iio/adc/ti-ads8344.c
@@ -28,7 +28,7 @@ struct ads8344 {
 	 */
 	struct mutex lock;
 
-	u8 tx_buf ____cacheline_aligned;
+	u8 tx_buf __aligned(IIO_DMA_MINALIGN);
 	u8 rx_buf[3];
 };
 
-- 
2.35.1



