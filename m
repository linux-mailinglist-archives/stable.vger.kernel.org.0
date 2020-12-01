Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13DC2C9CE8
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388219AbgLAJFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:05:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:42290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389060AbgLAJFO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:05:14 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2D3F20809;
        Tue,  1 Dec 2020 09:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813474;
        bh=Ws4JrFG7hmAkKWrYn6GrNTih35HVAgdhMO+gshlUH3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uUzPSQHIgbY6iCXBF32FEXyG/ayznJqDp1bM9PHQpBEyWbdeiNecdwa4xr+vcFoJS
         1h/CDZmDtWxZtYt/XIPEgJDEhLv3yAVbIgUM4vnyVDF6tKODjoJw+L3Krzl8w5UNzR
         1PBUCOyJ3xbatYzhbWw5a3uAvT3dpGCTZ0qFhA5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 51/98] bnxt_en: fix error return code in bnxt_init_board()
Date:   Tue,  1 Dec 2020 09:53:28 +0100
Message-Id: <20201201084657.598677811@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 3383176efc0fb0c0900a191026468a58668b4214 ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Link: https://lore.kernel.org/r/1605792621-6268-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4869cda460dad..d8e1d7a9196cd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10826,6 +10826,7 @@ static int bnxt_init_board(struct pci_dev *pdev, struct net_device *dev)
 	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) != 0 &&
 	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)) != 0) {
 		dev_err(&pdev->dev, "System does not support DMA, aborting\n");
+		rc = -EIO;
 		goto init_err_disable;
 	}
 
-- 
2.27.0



