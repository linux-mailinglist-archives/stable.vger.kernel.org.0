Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6470F6A69B6
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 10:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjCAJXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 04:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCAJXD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 04:23:03 -0500
X-Greylist: delayed 314 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 01 Mar 2023 01:23:02 PST
Received: from mo-csw-fb.securemx.jp (mo-csw-fb1114.securemx.jp [210.130.202.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 184F815561
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 01:23:01 -0800 (PST)
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1114) id 3219Hlsr004124; Wed, 1 Mar 2023 18:17:47 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1114) id 3219Gv14010495; Wed, 1 Mar 2023 18:16:59 +0900
X-Iguazu-Qid: 2wHHOH2eTl3DvDlZhL
X-Iguazu-QSIG: v=2; s=0; t=1677662217; q=2wHHOH2eTl3DvDlZhL; m=8pWqgCpLp6hMKATjzp7Rjcs2PN1g9YR6BLXDpbtdQvk=
Received: from imx12-a.toshiba.co.jp ([38.106.60.135])
        by relay.securemx.jp (mx-mr1113) id 3219GtFG005714
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 1 Mar 2023 18:16:56 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vinod Koul <vkoul@kernel.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 4.14,4.19,5.4] dmaengine: sh: rcar-dmac: Check for error num after dma_set_max_seg_size
Date:   Wed,  1 Mar 2023 18:16:28 +0900
X-TSB-HOP2: ON
Message-Id: <20230301091628.4004357-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

commit da2ad87fba0891576aadda9161b8505fde81a84d upstream.

As the possible failure of the dma_set_max_seg_size(), it should be
better to check the return value of the dma_set_max_seg_size().

Fixes: 97d49c59e219 ("dmaengine: rcar-dmac: set scatter/gather max segment size")
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20220111011239.452837-1-jiasheng@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/dma/sh/rcar-dmac.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/sh/rcar-dmac.c b/drivers/dma/sh/rcar-dmac.c
index eba942441e3823..10a8a6d4e86015 100644
--- a/drivers/dma/sh/rcar-dmac.c
+++ b/drivers/dma/sh/rcar-dmac.c
@@ -1824,7 +1824,10 @@ static int rcar_dmac_probe(struct platform_device *pdev)
 	dmac->dev = &pdev->dev;
 	platform_set_drvdata(pdev, dmac);
 	dmac->dev->dma_parms = &dmac->parms;
-	dma_set_max_seg_size(dmac->dev, RCAR_DMATCR_MASK);
+	ret = dma_set_max_seg_size(dmac->dev, RCAR_DMATCR_MASK);
+	if (ret)
+		return ret;
+
 	ret = dma_set_mask_and_coherent(dmac->dev, DMA_BIT_MASK(40));
 	if (ret)
 		return ret;
-- 
2.36.1


