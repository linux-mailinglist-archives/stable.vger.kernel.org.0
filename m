Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7268594B00
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351834AbiHPAIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356703AbiHPAHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:07:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295661714E4;
        Mon, 15 Aug 2022 13:28:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80B96B811A0;
        Mon, 15 Aug 2022 20:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3310C433D6;
        Mon, 15 Aug 2022 20:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595324;
        bh=8LUaCd4bTBKPuxdWhBKc9IuyNYhTts+CufpvhOlETNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uuK2/ySmNUd4ZSGIA4LrQgztPGiiMWSADusiE4bbw7I+Oqp32CRCNCYahXuXQYc8W
         bw2J9oxNVMJu7j1Too/mLy6n3kwjDILS3aS3cRB4pcWz8IyYLpSI4WWIgQgLqXQaMF
         47dRer0mlA6ybp/gDbWxtiQTqKfAlBxrLGzMD6QE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0695/1157] iio: frequency: adf4350: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:51 +0200
Message-Id: <20220815180507.427045776@linuxfoundation.org>
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

[ Upstream commit 389b8972eb2a614cb3189e5fa55b1b7f66142c71 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Updated help text to 'may' require buffers to be in their own cacheline.

Fixes: e31166f0fd48 ("iio: frequency: New driver for Analog Devices ADF4350/ADF4351 Wideband Synthesizers")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-67-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/frequency/adf4350.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/frequency/adf4350.c b/drivers/iio/frequency/adf4350.c
index be1218d86291..85e289700c3c 100644
--- a/drivers/iio/frequency/adf4350.c
+++ b/drivers/iio/frequency/adf4350.c
@@ -56,10 +56,10 @@ struct adf4350_state {
 	 */
 	struct mutex			lock;
 	/*
-	 * DMA (thus cache coherency maintenance) requires the
-	 * transfer buffers to live in their own cache lines.
+	 * DMA (thus cache coherency maintenance) may require that
+	 * transfer buffers live in their own cache lines.
 	 */
-	__be32				val ____cacheline_aligned;
+	__be32				val __aligned(IIO_DMA_MINALIGN);
 };
 
 static struct adf4350_platform_data default_pdata = {
-- 
2.35.1



