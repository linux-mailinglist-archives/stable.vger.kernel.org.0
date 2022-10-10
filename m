Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C44215F992A
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbiJJHIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231559AbiJJHHr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:07:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68E1167F3;
        Mon, 10 Oct 2022 00:05:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FCF660E33;
        Mon, 10 Oct 2022 07:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35D6C43470;
        Mon, 10 Oct 2022 07:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385535;
        bh=atj1j0PKW4J78bE2bxMxEMMO/nt/+7SxCYm3vfCz78Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZBcydlnWFiHjVw5pDzcs4ZuCRAj6G744L7htfb/tMaLKA7hsVi0t7/O7VTlMn4fIm
         5P9isCR8GN4Ike8xpZimlM8hsYAdHaxn7Ti9aawgdPS6dTk9jNChkFJKQMyfkNsM1A
         9z8dBWfKNu/T/y2FZqnHN1eyp1r46XBsnuG5Qw6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Swati Agarwal <swati.agarwal@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 14/48] dmaengine: xilinx_dma: cleanup for fetching xlnx,num-fstores property
Date:   Mon, 10 Oct 2022 09:05:12 +0200
Message-Id: <20221010070334.078829702@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070333.676316214@linuxfoundation.org>
References: <20221010070333.676316214@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ba0dccaa8cf1..f63ec9d862ff 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -3191,7 +3191,7 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 		if (err < 0) {
 			dev_err(xdev->dev,
 				"missing xlnx,num-fstores property\n");
-			return err;
+			goto disable_clks;
 		}
 
 		err = of_property_read_u32(node, "xlnx,flush-fsync",
-- 
2.35.1



