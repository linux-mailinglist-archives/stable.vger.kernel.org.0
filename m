Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD0D594099
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349017AbiHOVia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348643AbiHOVg6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:36:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11483C1;
        Mon, 15 Aug 2022 12:26:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1DEEB810C6;
        Mon, 15 Aug 2022 19:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0730BC433C1;
        Mon, 15 Aug 2022 19:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591600;
        bh=FzjM4HdHxjLmZ684q6puJoDo94H7dfh4vykYfgUVssE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nzEYZRCWVSrEETSXUoMaBRtXtnwI/w7n5CXpilMPNjDj7WjT9duBsAvaPqcyOUL0A
         SZdinsnd7Iwn5ib95NbIxLZETpnpUf0bF9qnQ3qBlgsV6L5Xkz3nhOC7qibbUsQYFm
         LLhWP0apvNs/duThld/0kPdC0BvJRMhLGa67nLKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0633/1095] iio: dac: ad5686: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:32 +0200
Message-Id: <20220815180455.625424604@linuxfoundation.org>
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

[ Upstream commit 444e38927d9af093de7cdc6afbb7afdc3485da2d ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Update the comment to include 'may'.

Fixes: 0357e488b825 ("iio:dac:ad5686: Refactor the driver")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-50-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad5686.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/dac/ad5686.h b/drivers/iio/dac/ad5686.h
index cd5fff9e9d53..b7ade3a6b9b6 100644
--- a/drivers/iio/dac/ad5686.h
+++ b/drivers/iio/dac/ad5686.h
@@ -13,6 +13,8 @@
 #include <linux/mutex.h>
 #include <linux/kernel.h>
 
+#include <linux/iio/iio.h>
+
 #define AD5310_CMD(x)				((x) << 12)
 
 #define AD5683_DATA(x)				((x) << 4)
@@ -137,7 +139,7 @@ struct ad5686_state {
 	struct mutex			lock;
 
 	/*
-	 * DMA (thus cache coherency maintenance) requires the
+	 * DMA (thus cache coherency maintenance) may require the
 	 * transfer buffers to live in their own cache lines.
 	 */
 
@@ -145,7 +147,7 @@ struct ad5686_state {
 		__be32 d32;
 		__be16 d16;
 		u8 d8[4];
-	} data[3] ____cacheline_aligned;
+	} data[3] __aligned(IIO_DMA_MINALIGN);
 };
 
 
-- 
2.35.1



