Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41211594AC0
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355756AbiHPAG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357100AbiHPADn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:03:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A1916E62A;
        Mon, 15 Aug 2022 13:25:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9953FB8119C;
        Mon, 15 Aug 2022 20:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A74C433D6;
        Mon, 15 Aug 2022 20:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595140;
        bh=b2Wl1cgr0hCIZksa0yi8sM5DSO722BIyjIUYCwkDi+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JXpX7Wk417vn7xcbdbCqmr9sAB9tRZJUs/QC3EZZLXjxPehphLHWpzr5eiN4LeBAc
         4+8WCzNACFnhMosvMltp+iVgp8JC5tfC2HBcypIOj/GWTWpf3x/bE0OJn9SnAq0TaK
         83Fi0HP6Y06RlBZrJZtUyLRVBITSfWbXQJkv9P4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0670/1157] iio: amplifiers: ad8366: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:26 +0200
Message-Id: <20220815180506.497676006@linuxfoundation.org>
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

[ Upstream commit 026bffa458d029a5f15ac3f82a9bb0f64aca403d ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Update the comment to include 'may'.

Fixes: e71d42e03c60 ("iio: amplifiers: New driver for AD8366 Dual-Digital Variable Gain Amplifier")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-42-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/amplifiers/ad8366.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/amplifiers/ad8366.c b/drivers/iio/amplifiers/ad8366.c
index 1134ae12e531..f2c2ea79a07f 100644
--- a/drivers/iio/amplifiers/ad8366.c
+++ b/drivers/iio/amplifiers/ad8366.c
@@ -45,10 +45,10 @@ struct ad8366_state {
 	enum ad8366_type	type;
 	struct ad8366_info	*info;
 	/*
-	 * DMA (thus cache coherency maintenance) requires the
+	 * DMA (thus cache coherency maintenance) may require the
 	 * transfer buffers to live in their own cache lines.
 	 */
-	unsigned char		data[2] ____cacheline_aligned;
+	unsigned char		data[2] __aligned(IIO_DMA_MINALIGN);
 };
 
 static struct ad8366_info ad8366_infos[] = {
-- 
2.35.1



