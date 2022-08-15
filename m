Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B9A593F88
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348946AbiHOViJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349074AbiHOVgg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:36:36 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58EDF4C;
        Mon, 15 Aug 2022 12:26:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4010ECE12C8;
        Mon, 15 Aug 2022 19:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17390C433C1;
        Mon, 15 Aug 2022 19:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591584;
        bh=HLQ2nldeCGQ4S65ve1hTIYx9ITuoCpzbvZnJt2vv1aU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JibUvFGpV86Va/4TAcldEJkk4V5qw5h9oDi/lOEqsbtoIMEzQlRcPZFHureuYRRL9
         jDDrUtAYmbO4XemvVj7FVp9JY1E4TCVwg+ZpHVHQ91xH9no0vuxI3boAUpn1eANnjQ
         up/xDJOT6VTS63YZJNSlMuNN5J8RzmXIpuZb3pu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0628/1095] iio: dac: ad5360: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:27 +0200
Message-Id: <20220815180455.419064911@linuxfoundation.org>
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

[ Upstream commit 94ec314e1bd686b669c24385ce2dbc967eb74147 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Update the comment to include 'may'.

Fixes: a3e2940c24d3 ("staging:iio:dac: Add AD5360 driver")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-45-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad5360.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/dac/ad5360.c b/drivers/iio/dac/ad5360.c
index ecbc6a51d60f..1bde696a572c 100644
--- a/drivers/iio/dac/ad5360.c
+++ b/drivers/iio/dac/ad5360.c
@@ -79,13 +79,13 @@ struct ad5360_state {
 	struct mutex			lock;
 
 	/*
-	 * DMA (thus cache coherency maintenance) requires the
+	 * DMA (thus cache coherency maintenance) may require the
 	 * transfer buffers to live in their own cache lines.
 	 */
 	union {
 		__be32 d32;
 		u8 d8[4];
-	} data[2] ____cacheline_aligned;
+	} data[2] __aligned(IIO_DMA_MINALIGN);
 };
 
 enum ad5360_type {
-- 
2.35.1



