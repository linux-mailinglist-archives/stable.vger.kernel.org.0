Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAF66B40CC
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjCJNqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:46:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbjCJNqR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:46:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24AFF10B1E4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:46:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3DEE617D5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA355C4339B;
        Fri, 10 Mar 2023 13:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678455975;
        bh=gwi6LtZ1h1v23El38qFw3x1lxt0PK5PLOyxHzfj8DWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sogUchKVPH43hqJf2DHWWsaCsT7PY2QcOJx3PUQaxbZd6Dh2C9H2hQVmwM42G817V
         tV9LMq1pH1GhJeTKHbtgtCM6efWge2dcJQGMwPMuwP7dFwWMbORZvDQqAkyLa7YfC8
         aZomA4V6kp0lEpgOlBwLsu9YMxTvWXPqZIYOoZRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Vinod Koul <vkoul@kernel.org>,
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.14 009/193] dmaengine: sh: rcar-dmac: Check for error num after dma_set_max_seg_size
Date:   Fri, 10 Mar 2023 14:36:31 +0100
Message-Id: <20230310133711.240144387@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/dma/sh/rcar-dmac.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/dma/sh/rcar-dmac.c
+++ b/drivers/dma/sh/rcar-dmac.c
@@ -1766,7 +1766,10 @@ static int rcar_dmac_probe(struct platfo
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


