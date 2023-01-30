Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D26B681023
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236718AbjA3OAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236800AbjA3OAY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:00:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1AD839CD6
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:00:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB70561048
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A94C433D2;
        Mon, 30 Jan 2023 13:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087175;
        bh=wHKJSGyQUymGm4fOzQcgC4Pa+sJLBucPUcej5WkSxZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FzUtUP2eoZg9dpBwJECMoD9I8YzHKQKXlug57o0bDVQkLsrEiHFRkM3hb5skJcoGR
         eMwzonDW58jZZmFPsFmlQUWjbFybOLvP6UVUmtnApskj0Vbpi7agZdoIuwlGHOBPQg
         slqgZc+is29evCbtWXegXamC7m0QFwnFtzmqrVlI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Akhil R <akhilrajeev@nvidia.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/313] dmaengine: tegra: Fix memory leak in terminate_all()
Date:   Mon, 30 Jan 2023 14:49:16 +0100
Message-Id: <20230130134342.288941108@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Akhil R <akhilrajeev@nvidia.com>

[ Upstream commit a7a7ee6f5a019ad72852c001abbce50d35e992f2 ]

Terminate vdesc when terminating an ongoing transfer.
This will ensure that the vdesc is present in the desc_terminated list
The descriptor will be freed later in desc_free_list().

This fixes the memory leaks which can happen when terminating an
ongoing transfer.

Fixes: ee17028009d4 ("dmaengine: tegra: Add tegra gpcdma driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Link: https://lore.kernel.org/r/20230118115801.15210-1-akhilrajeev@nvidia.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/tegra186-gpc-dma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/tegra186-gpc-dma.c b/drivers/dma/tegra186-gpc-dma.c
index fa9bda4a2bc6..75af3488a3ba 100644
--- a/drivers/dma/tegra186-gpc-dma.c
+++ b/drivers/dma/tegra186-gpc-dma.c
@@ -707,6 +707,7 @@ static int tegra_dma_terminate_all(struct dma_chan *dc)
 			return err;
 		}
 
+		vchan_terminate_vdesc(&tdc->dma_desc->vd);
 		tegra_dma_disable(tdc);
 		tdc->dma_desc = NULL;
 	}
-- 
2.39.0



