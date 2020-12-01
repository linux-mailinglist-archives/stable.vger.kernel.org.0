Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B472C9A96
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbgLAI67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:58:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:34682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388034AbgLAI65 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:58:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE3A1206D8;
        Tue,  1 Dec 2020 08:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813096;
        bh=Eltv4jINqLCplTubDg4TvrQFdmzGRndZ02hic17dWcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UrKkIuGjMSXTgAQWX6XIpm5lYh6HU5A9J+F5uHSCr0UQ+yuZnhPA5tnFNNl0LMVw9
         C8xYCrhM/j1Yh/NKS/uIuVYtEHc7lUC+r+gkX4UJj4IGgnJ0ISaeIbq8Tnun5HJwyb
         voX/eqyNqO5AoEHlAm7xXD2d8n4fkqo18L2FzgAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 32/50] bnxt_en: Release PCI regions when DMA mask setup fails during probe.
Date:   Tue,  1 Dec 2020 09:53:31 +0100
Message-Id: <20201201084648.993802795@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084644.803812112@linuxfoundation.org>
References: <20201201084644.803812112@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit c54bc3ced5106663c2f2b44071800621f505b00e ]

Jump to init_err_release to cleanup.  bnxt_unmap_bars() will also be
called but it will do nothing if the BARs are not mapped yet.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/1605858271-8209-1-git-send-email-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6ed1d7c86cfea..ea2a539e6e0f7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7213,7 +7213,7 @@ static int bnxt_init_board(struct pci_dev *pdev, struct net_device *dev)
 	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)) != 0) {
 		dev_err(&pdev->dev, "System does not support DMA, aborting\n");
 		rc = -EIO;
-		goto init_err_disable;
+		goto init_err_release;
 	}
 
 	pci_set_master(pdev);
-- 
2.27.0



