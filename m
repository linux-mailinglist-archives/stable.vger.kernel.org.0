Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2765F2705
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 01:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiJBXGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 19:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbiJBXGO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 19:06:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4273647B98;
        Sun,  2 Oct 2022 16:01:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B49AB80DA2;
        Sun,  2 Oct 2022 22:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146F6C43140;
        Sun,  2 Oct 2022 22:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751187;
        bh=u5TzAJ+V988KQo6k184h+K2UMiphbxZiON4R8VGPRfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hhgOawzIs6P6zktwdqsOZlQdpKkOKkctdMguPXo4Wc3zsS2j6Oc4IkVO7xnztnJS2
         NPo4fcjvdpPX1Wt0/Fa8zEpXIyc5j6TLcrz18MLiGQh4dvbDqFG64F89NWUjDnH6wz
         93xDVIIcAy+Rzrm2zSRyrXELoW36/o4ItpULOXhQVPiPFOAkT0kIo/vaGK7NKYd8sD
         GbCayTXqiZlUIPXH5MqO9Up1N+Ta01KZEVejnJ16oBDx+wUS+qC6tN49BMJmy/JmZv
         TOrxv6JVlpNIA/oJ/CoVB7QAVKLLEN0bOM0Ti7n3ll26bTRirxKM/n0pY1hbv3Wd/J
         hE/HrG0rgHBuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Swati Agarwal <swati.agarwal@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com,
        lars@metafoo.de, adrianml@alumnos.upm.es,
        shravya.kumbham@xilinx.com, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 2/8] dmaengine: xilinx_dma: cleanup for fetching xlnx,num-fstores property
Date:   Sun,  2 Oct 2022 18:52:54 -0400
Message-Id: <20221002225300.239982-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002225300.239982-1-sashal@kernel.org>
References: <20221002225300.239982-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Swati Agarwal <swati.agarwal@xilinx.com>

[ Upstream commit 462bce790e6a7e68620a4ce260cc38f7ed0255d5 ]

Free the allocated resources for missing xlnx,num-fstores property.

Signed-off-by: Swati Agarwal <swati.agarwal@xilinx.com>
Link: https://lore.kernel.org/r/20220817061125.4720-3-swati.agarwal@xilinx.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 3f38df6b51f2..f72803587b8f 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -2654,7 +2654,7 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 		if (err < 0) {
 			dev_err(xdev->dev,
 				"missing xlnx,num-fstores property\n");
-			return err;
+			goto disable_clks;
 		}
 
 		err = of_property_read_u32(node, "xlnx,flush-fsync",
-- 
2.35.1

