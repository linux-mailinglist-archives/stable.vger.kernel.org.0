Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA812594AB7
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353587AbiHPAGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357285AbiHPAEE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:04:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC764CC317;
        Mon, 15 Aug 2022 13:28:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBF7A61187;
        Mon, 15 Aug 2022 20:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22DEC433C1;
        Mon, 15 Aug 2022 20:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595286;
        bh=dNFBnbzURibeCT2P3eZZy7892rCSoDAp9zS8hNV0w5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xN9q9MOdDgP2vnkSUq0McM1cRqqdPB0cWay9+HU2XdmyPVNXaaT5kXbPm6uWx2RAg
         q3darCVFskUdfp+TrOgiPjKZMM4j/bEYFCtt/ZJX93WcoMDXZRibJXnNftHS0lndmg
         oQkxbqxv8QeDku1Vw9SkGT0ZO03MJbYXXngkKQrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Michael Welling <mwelling@ieee.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0689/1157] iio: dac: mcp4922: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:45 +0200
Message-Id: <20220815180507.181610102@linuxfoundation.org>
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

[ Upstream commit e66bf04797f1f95a2402414c00e64d00f63d31ec ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: 1b791fadf3a1 ("iio: dac: mcp4902/mcp4912/mcp4922 dac driver")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Acked-by: Michael Welling <mwelling@ieee.org>
Link: https://lore.kernel.org/r/20220508175712.647246-61-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/mcp4922.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/dac/mcp4922.c b/drivers/iio/dac/mcp4922.c
index cb9e60e71b91..6c0e31032c57 100644
--- a/drivers/iio/dac/mcp4922.c
+++ b/drivers/iio/dac/mcp4922.c
@@ -29,7 +29,7 @@ struct mcp4922_state {
 	unsigned int value[MCP4922_NUM_CHANNELS];
 	unsigned int vref_mv;
 	struct regulator *vref_reg;
-	u8 mosi[2] ____cacheline_aligned;
+	u8 mosi[2] __aligned(IIO_DMA_MINALIGN);
 };
 
 #define MCP4922_CHAN(chan, bits) {			\
-- 
2.35.1



