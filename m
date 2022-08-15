Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B205A595042
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbiHPEiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbiHPEiU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:38:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BC9CACA1;
        Mon, 15 Aug 2022 13:27:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E9AC611AA;
        Mon, 15 Aug 2022 20:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C67C433C1;
        Mon, 15 Aug 2022 20:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595276;
        bh=XVTACl5lEivz5w/igqkLXPqt+lJ92BfMNTk1diWpk6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TukIbbGZmieuGfP3NMFljxyH5mM4N3pLGOq8rzlPUEoUfk0gqq8NIaDZGA8jEAtLQ
         9vGF0vyAxTiT9GjGO/6tgPneAjyGbXYy/vn3k3hVnV4iSHxNuhz1jq265fybJImo1c
         dtLKnJsstn5OOt+IlUBx+Yu2YhsPM9p/zw2c+3OU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0713/1157] iio: potentiometer: mcp4131: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:01:09 +0200
Message-Id: <20220815180508.050661480@linuxfoundation.org>
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

[ Upstream commit 4842e5de6f39ebf2c0f6da9e6a0cb751c7108507 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: 22d199a53910 ("iio: potentiometer: add driver for Microchip MCP413X/414X/415X/416X/423X/424X/425X/426X")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-85-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/potentiometer/mcp4131.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/potentiometer/mcp4131.c b/drivers/iio/potentiometer/mcp4131.c
index 7c8c18ab8764..7890c0993ec4 100644
--- a/drivers/iio/potentiometer/mcp4131.c
+++ b/drivers/iio/potentiometer/mcp4131.c
@@ -129,7 +129,7 @@ struct mcp4131_data {
 	struct spi_device *spi;
 	const struct mcp4131_cfg *cfg;
 	struct mutex lock;
-	u8 buf[2] ____cacheline_aligned;
+	u8 buf[2] __aligned(IIO_DMA_MINALIGN);
 };
 
 #define MCP4131_CHANNEL(ch) {					\
-- 
2.35.1



