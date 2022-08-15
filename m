Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22406595031
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbiHPEhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiHPEhC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:37:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DCB7357EC;
        Mon, 15 Aug 2022 13:27:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D62D61133;
        Mon, 15 Aug 2022 20:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192DDC433D6;
        Mon, 15 Aug 2022 20:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595220;
        bh=iTmeA8s+xFoCTgBSS0GCvKoR1P2ycaxa6jZr3GJywEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gA14AuHpjJmwQ7M7ep58ZnRwPdOd+Xz0e+7hP1ZddQXd/rUZ0TSIKm5ZroD+Tr2X6
         R0VekTjmNqwjKcYRsdEbJHt8Qk+MmbH8qlrk0v02p8LxZCm/Zqg+YjluhdebEYOaZl
         pw68kDGGtnFboysC4oPkZNqwSy+/e5c/K3/PVqrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0696/1157] iio: frequency: adf4371: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:52 +0200
Message-Id: <20220815180507.470699394@linuxfoundation.org>
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

[ Upstream commit 0bb5675befe666eeed71ad808426cf2ec1c9a714 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: 7f699bd14913 ("iio: frequency: adf4371: Add support for ADF4371 PLL")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-68-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/frequency/adf4371.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/frequency/adf4371.c b/drivers/iio/frequency/adf4371.c
index ecd5e18995ad..135c8cedc33d 100644
--- a/drivers/iio/frequency/adf4371.c
+++ b/drivers/iio/frequency/adf4371.c
@@ -175,7 +175,7 @@ struct adf4371_state {
 	unsigned int mod2;
 	unsigned int rf_div_sel;
 	unsigned int ref_div_factor;
-	u8 buf[10] ____cacheline_aligned;
+	u8 buf[10] __aligned(IIO_DMA_MINALIGN);
 };
 
 static unsigned long long adf4371_pll_fract_n_get_rate(struct adf4371_state *st,
-- 
2.35.1



