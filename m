Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4DB1672AD
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731502AbgBUIFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:05:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:39268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731852AbgBUIFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:05:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F40420801;
        Fri, 21 Feb 2020 08:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272340;
        bh=WuG/B6lmBEnh3GUKDiqWFqR3zitCFb14UJnbGdNR6mY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxVy9mriNRGHrATXWo7lY/VNtNuPXOU0GroOK3TmAI/8xIJVuhin76SuMHBVp26Lf
         KhRTyxC4zUz0UW5KaARFpNIdYFNzHouRRgO9GwN0RPeb3jTjtccY66RYHn+f0B5Cem
         bb/bvnmc9eaBGbvDLL007S/9Qtjo7zoJsUc9/Wo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Zhou <chenzhou10@huawei.com>,
        Peng Ma <peng.ma@nxp.com>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 070/344] dmaengine: fsl-qdma: fix duplicated argument to &&
Date:   Fri, 21 Feb 2020 08:37:49 +0100
Message-Id: <20200221072355.353201379@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Zhou <chenzhou10@huawei.com>

[ Upstream commit 4b048178854da11656596d36a107577d66fd1e08 ]

There is duplicated argument to && in function fsl_qdma_free_chan_resources,
which looks like a typo, pointer fsl_queue->desc_pool also needs NULL check,
fix it.
Detected with coccinelle.

Fixes: b092529e0aa0 ("dmaengine: fsl-qdma: Add qDMA controller driver for Layerscape SoCs")
Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
Reviewed-by: Peng Ma <peng.ma@nxp.com>
Tested-by: Peng Ma <peng.ma@nxp.com>
Link: https://lore.kernel.org/r/20200120125843.34398-1-chenzhou10@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl-qdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/fsl-qdma.c b/drivers/dma/fsl-qdma.c
index 89792083d62c5..95cc0256b3878 100644
--- a/drivers/dma/fsl-qdma.c
+++ b/drivers/dma/fsl-qdma.c
@@ -304,7 +304,7 @@ static void fsl_qdma_free_chan_resources(struct dma_chan *chan)
 
 	vchan_dma_desc_free_list(&fsl_chan->vchan, &head);
 
-	if (!fsl_queue->comp_pool && !fsl_queue->comp_pool)
+	if (!fsl_queue->comp_pool && !fsl_queue->desc_pool)
 		return;
 
 	list_for_each_entry_safe(comp_temp, _comp_temp,
-- 
2.20.1



