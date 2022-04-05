Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A474F2FFE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241620AbiDEIep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239440AbiDEIUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05C2939AC;
        Tue,  5 Apr 2022 01:13:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC526B81A37;
        Tue,  5 Apr 2022 08:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCB0C385A0;
        Tue,  5 Apr 2022 08:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146402;
        bh=Zn6H0fiRR7Pz3PyeF3Xc4WniB/RzWJxtbHai6a0pBdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EUvn/LPIqjYEB7/XNk3qvex2/Y4LpXT7YSGzrwIdzcVoYaiFT6j9BqH/Va2HlDJWV
         KphHh+ZemaVeLER4KMoae+VxhagKMCVFFT+yBI9sH+VjjCCFlNvfRE339KwmFeLO4H
         Wz9B06UIJPBCbfwzUdUl4hiB1cnyKB5Cbqd9Kul4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jie Hai <haijie1@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0750/1126] dmaengine: hisi_dma: fix MSI allocate fail when reload hisi_dma
Date:   Tue,  5 Apr 2022 09:24:57 +0200
Message-Id: <20220405070429.597822501@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jie Hai <haijie1@huawei.com>

[ Upstream commit b95044b38425f563404234d96bbb20cc6360c7e1 ]

Remove the loaded hisi_dma driver and reload it, the driver fails
to work properly. The following error is reported in the kernel log:

[ 1475.597609] hisi_dma 0000:7b:00.0: Failed to allocate MSI vectors!
[ 1475.604915] hisi_dma: probe of 0000:7b:00.0 failed with error -28

As noted in "The MSI Driver Guide HOWTO"[1], the number of MSI
interrupt must be a power of two. The Kunpeng DMA driver allocates 30
MSI interrupts. As a result, no space left on device is reported
when the driver is reloaded and allocates interrupt vectors from the
interrupt domain.

This patch changes the number of interrupt vectors allocated by
hisi_dma driver to 32 to avoid this problem.

[1] https://www.kernel.org/doc/html/latest/PCI/msi-howto.html

Fixes: e9f08b65250d ("dmaengine: hisilicon: Add Kunpeng DMA engine support")

Signed-off-by: Jie Hai <haijie1@huawei.com>
Acked-by: Zhou Wang <wangzhou1@hisilicon.com>
Link: https://lore.kernel.org/r/20220216072101.34473-1-haijie1@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/hisi_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/hisi_dma.c b/drivers/dma/hisi_dma.c
index 97c87a7cba87..43817ced3a3e 100644
--- a/drivers/dma/hisi_dma.c
+++ b/drivers/dma/hisi_dma.c
@@ -30,7 +30,7 @@
 #define HISI_DMA_MODE			0x217c
 #define HISI_DMA_OFFSET			0x100
 
-#define HISI_DMA_MSI_NUM		30
+#define HISI_DMA_MSI_NUM		32
 #define HISI_DMA_CHAN_NUM		30
 #define HISI_DMA_Q_DEPTH_VAL		1024
 
-- 
2.34.1



