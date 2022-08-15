Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F33D594242
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349443AbiHOVsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350184AbiHOVrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:47:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53425F9AA;
        Mon, 15 Aug 2022 12:31:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69094B81062;
        Mon, 15 Aug 2022 19:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50D8C433D6;
        Mon, 15 Aug 2022 19:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591871;
        bh=5CiSJRDycVN1/+uf8e3hF3S3PgT4ShsvHAWoBCYNW5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkJZrY+p5erzJW6ZIRw7p4Yx3vND2O+ZQf5jHntibB5QnWYs9+qFdzG8536KyBS7C
         451j8htkSzayjrcPnz7CPnaFAki7D0LXxkZtCeTMmlvpgrspWmwCpKmefX8eiZXY06
         ufhgGqwB2Dq8TQjQtpiHSe0wsK4yO0egQXO7WOmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Mugilraj Dhavachelvan <dmugil2000@gmail.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0664/1095] iio: potentiometer: ad5110: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:01:03 +0200
Message-Id: <20220815180456.859968072@linuxfoundation.org>
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



