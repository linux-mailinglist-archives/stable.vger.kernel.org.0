Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8AC594161
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348681AbiHOVhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348987AbiHOVgU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:36:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F88F2E9E4;
        Mon, 15 Aug 2022 12:25:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBDF360693;
        Mon, 15 Aug 2022 19:25:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF794C433C1;
        Mon, 15 Aug 2022 19:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591539;
        bh=x7EQv7AD4LMoZ4EMaiSnO2H0ly6bAUK3LBIgSix3a/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dQrDO66k0wgGsE1bJq3/T+dNViLDbokG1s4Q8/KIWlObhJcrqou4RtrsnfXJzSmJM
         pPVtPHStU4A23DQg/R31WTqjedkPhxXWyKMPh3flZ6yPmV7p1Y9RpHkH2YoX8H8wOe
         7AFuwD4YM715CVHT/dUnSsqsOSy+H8Z0lrKl4Q7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Michael Welling <mwelling@ieee.org>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0611/1095] iio: adc: mcp320x: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:10 +0200
Message-Id: <20220815180454.777785472@linuxfoundation.org>
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

[ Upstream commit e770f78036ce4327caf285873f4b20564a8b4f0f ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Worth noting the fixes tag refers to the same issue being observed
on a platform that probably had only 64 byte cachelines.

Fixes: 0e81bc99a082 ("iio: mcp320x: Fix occasional incorrect readings")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Michael Welling <mwelling@ieee.org>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-28-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/mcp320x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/mcp320x.c b/drivers/iio/adc/mcp320x.c
index b4c69acb33e3..f3b81798b3c9 100644
--- a/drivers/iio/adc/mcp320x.c
+++ b/drivers/iio/adc/mcp320x.c
@@ -92,7 +92,7 @@ struct mcp320x {
 	struct mutex lock;
 	const struct mcp320x_chip_info *chip_info;
 
-	u8 tx_buf ____cacheline_aligned;
+	u8 tx_buf __aligned(IIO_DMA_MINALIGN);
 	u8 rx_buf[4];
 };
 
-- 
2.35.1



