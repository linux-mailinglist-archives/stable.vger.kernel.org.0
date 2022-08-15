Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E11C55941F6
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348521AbiHOVgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348907AbiHOVgE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:36:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B131A06A;
        Mon, 15 Aug 2022 12:25:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 271AEB81123;
        Mon, 15 Aug 2022 19:25:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC28C433C1;
        Mon, 15 Aug 2022 19:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591523;
        bh=VIEVbCtvRfjrQKPCYjdDan+CnTB02T8MRrjk4iIJJi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MX9x+6T+8WH6ToREawWdADJU3HDUrne1ckhVm09O3z8zDpKt7nswkMyObMSQnBBwI
         wSTtT2d8IU+jc30ILiRFAiLGzr5fMY5d0GJlsMf2muYFfoypNwj49l0dajzAC/txl8
         bO7W/U0md5f3tCRDEapNp64prP3aohsnz3ktNbKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0606/1095] iio: adc: ltc2497: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:05 +0200
Message-Id: <20220815180454.601018830@linuxfoundation.org>
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

[ Upstream commit 6ebf401d555ee1e75e779b865d38e171db0aa1f2 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Update the comment to include 'may'.

Fixes: bc82222fcca1 ("iio:adc: Driver for Linear Technology LTC2497 ADC")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-23-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ltc2497.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ltc2497.c b/drivers/iio/adc/ltc2497.c
index 1adddf5a88a9..f7c786f37ceb 100644
--- a/drivers/iio/adc/ltc2497.c
+++ b/drivers/iio/adc/ltc2497.c
@@ -20,10 +20,10 @@ struct ltc2497_driverdata {
 	struct ltc2497core_driverdata common_ddata;
 	struct i2c_client *client;
 	/*
-	 * DMA (thus cache coherency maintenance) requires the
+	 * DMA (thus cache coherency maintenance) may require the
 	 * transfer buffers to live in their own cache lines.
 	 */
-	__be32 buf ____cacheline_aligned;
+	__be32 buf __aligned(IIO_DMA_MINALIGN);
 };
 
 static int ltc2497_result_and_measure(struct ltc2497core_driverdata *ddata,
-- 
2.35.1



