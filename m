Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0224C594AD6
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356023AbiHPAGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357185AbiHPADx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:03:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1399AFE3;
        Mon, 15 Aug 2022 13:26:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A81AB61072;
        Mon, 15 Aug 2022 20:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D532C433D6;
        Mon, 15 Aug 2022 20:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595161;
        bh=jAo6yBPzsPxvurDhE/Wv2SdbcO75Px0lVoNRh1O4SwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MyCVsYIdH9vfmYbGVXdLs3+32KuyYf1eGiEFuE/esMB1eZQW++wIgJnnyfTscHkt5
         MaX17cvRuTpn8DUzTow3JBrHC1mV9lrtjfMZZty+o/Y/M9YrtZhi/DhPGSk4pH7XkI
         HZDWxurxqcp6/vcctd3sHH1leXCwLhvNWGJBq5KQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0676/1157] iio: dac: ad5504: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:32 +0200
Message-Id: <20220815180506.725671223@linuxfoundation.org>
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

[ Upstream commit 00b9737caa5aaed5cf45a7c7498edf5957efa3b2 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: 0dbe59c7a788 ("iio:ad5504: Do not store transfer buffers on the stack")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-48-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad5504.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/dac/ad5504.c b/drivers/iio/dac/ad5504.c
index a0817e799cc0..e6c5be728bb2 100644
--- a/drivers/iio/dac/ad5504.c
+++ b/drivers/iio/dac/ad5504.c
@@ -54,7 +54,7 @@ struct ad5504_state {
 	unsigned			pwr_down_mask;
 	unsigned			pwr_down_mode;
 
-	__be16				data[2] ____cacheline_aligned;
+	__be16				data[2] __aligned(IIO_DMA_MINALIGN);
 };
 
 /*
-- 
2.35.1



