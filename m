Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125AB594AB0
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353252AbiHPAFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356686AbiHPACt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:02:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6180B169C7A;
        Mon, 15 Aug 2022 13:24:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3628B8119A;
        Mon, 15 Aug 2022 20:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A984DC433C1;
        Mon, 15 Aug 2022 20:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595045;
        bh=AX2ZAm9ioak9DLDdbaSI+mHlOTJ/08BFG9uYSEzNwnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQK2+r6QwrZX1EQimBVxevuRVbhfojq1ATBU3SAAs/M4cV8viIq4lc2k5WCCzUjns
         0xIaST+4WZSS8dUg5lfCWzjVMUq28Vc112dnQpGIEsuHn3FfAZWAQlHLSOQMVH0qvX
         IAVkqh4VgEjFUUrrvM2Dmda2dlSPgbU5wk5VKVDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0639/1157] iio: adc: ad7280a: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 19:59:55 +0200
Message-Id: <20220815180505.276542465@linuxfoundation.org>
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

[ Upstream commit 4e2008429588b857bbc13d048b67b931a8d84816 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: 003f1d48de52 ("staging:iio:adc:ad7280a: Split buff[2] into tx and rx parts")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-11-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7280a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad7280a.c b/drivers/iio/adc/ad7280a.c
index 3bdf3d9422f2..d4a4e15c8244 100644
--- a/drivers/iio/adc/ad7280a.c
+++ b/drivers/iio/adc/ad7280a.c
@@ -183,7 +183,7 @@ struct ad7280_state {
 	unsigned char			cb_mask[AD7280A_MAX_CHAIN];
 	struct mutex			lock; /* protect sensor state */
 
-	__be32				tx ____cacheline_aligned;
+	__be32				tx __aligned(IIO_DMA_MINALIGN);
 	__be32				rx;
 };
 
-- 
2.35.1



