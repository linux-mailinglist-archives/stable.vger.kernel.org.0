Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF426595003
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbiHPEgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbiHPEfX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:35:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213B5CAC84;
        Mon, 15 Aug 2022 13:27:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 600BFB8119B;
        Mon, 15 Aug 2022 20:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982AFC433D6;
        Mon, 15 Aug 2022 20:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595264;
        bh=5CiSJRDycVN1/+uf8e3hF3S3PgT4ShsvHAWoBCYNW5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMvxGByHs7g89EihLZgYfgFmxGpYM+BcrLxvwYNrkCJ7LLw15rxAMCwFb3DkRwmLj
         8sSyUgpPCjqCSBYhg0x7x1lmMsN/VxAHpsiqRJAA6YmnakGKQMjCIXnzKlIbPCBneX
         nNANRyC0LrKjJHcVo2YYzU3WPZ93Bbvh6/hsAU1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Mugilraj Dhavachelvan <dmugil2000@gmail.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0709/1157] iio: potentiometer: ad5110: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:01:05 +0200
Message-Id: <20220815180507.920005842@linuxfoundation.org>
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

[ Upstream commit b5841c38cb2f7e54b0787b3e0326a6b21b89ea3e ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: d03a74bfacce ("iio: potentiometer: Add driver support for AD5110")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Mugilraj Dhavachelvan <dmugil2000@gmail.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-81-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/potentiometer/ad5110.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/potentiometer/ad5110.c b/drivers/iio/potentiometer/ad5110.c
index d4eeedae56e5..8fbcce482989 100644
--- a/drivers/iio/potentiometer/ad5110.c
+++ b/drivers/iio/potentiometer/ad5110.c
@@ -63,10 +63,10 @@ struct ad5110_data {
 	struct mutex            lock;
 	const struct ad5110_cfg	*cfg;
 	/*
-	 * DMA (thus cache coherency maintenance) requires the
+	 * DMA (thus cache coherency maintenance) may require the
 	 * transfer buffers to live in their own cache lines.
 	 */
-	u8			buf[2] ____cacheline_aligned;
+	u8			buf[2] __aligned(IIO_DMA_MINALIGN);
 };
 
 static const struct iio_chan_spec ad5110_channels[] = {
-- 
2.35.1



