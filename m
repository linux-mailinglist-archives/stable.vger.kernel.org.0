Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16965940DC
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349086AbiHOVir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348806AbiHOVhf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:37:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AEB925FE;
        Mon, 15 Aug 2022 12:27:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB5D760EF0;
        Mon, 15 Aug 2022 19:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D3BC433C1;
        Mon, 15 Aug 2022 19:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591632;
        bh=gBGcrnAMclXRoqc3CuPodqBwsRNPRWq2FLZYJfZT2Ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ngDD8ye1wOel+cP/UVQO8OItSUQRA4MrAUyHEOCWpdEz+YcbPBGzHglPl2Un5tqWb
         L3Cs+w/U6XvF8B1naWT8RiYwutkxXpkjrqA2WaXBylKI98DeXsVCYVMoVgDQknGZQk
         1eN8SrR+ebPyIQ7UHNCOFxqprynNMrgVtKh/WMDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0642/1095] iio: dac: ad8801: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:41 +0200
Message-Id: <20220815180455.953092388@linuxfoundation.org>
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

[ Upstream commit 1c20292c6b60cfc60a5e652174b8063e5cc03fec ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: 7f270bc9a2d9 ("iio: dac: AD8801: add Analog Devices AD8801/AD8803 support")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-59-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad8801.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/dac/ad8801.c b/drivers/iio/dac/ad8801.c
index 6be35c92d435..919e8c880697 100644
--- a/drivers/iio/dac/ad8801.c
+++ b/drivers/iio/dac/ad8801.c
@@ -26,7 +26,7 @@ struct ad8801_state {
 	struct regulator *vrefh_reg;
 	struct regulator *vrefl_reg;
 
-	__be16 data ____cacheline_aligned;
+	__be16 data __aligned(IIO_DMA_MINALIGN);
 };
 
 static int ad8801_spi_write(struct ad8801_state *state,
-- 
2.35.1



