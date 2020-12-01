Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943512C9A06
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 09:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbgLAIyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:54:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:57660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727670AbgLAIyw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:54:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E30C221FF;
        Tue,  1 Dec 2020 08:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606812829;
        bh=Lp4j60jAjeWnw7tqIzJTb7/dkrXJIFmQGxKlGCYuCbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RQMZXReeqwNYzAYHYM+SWZt1FBVikLmResFn/AllcMGrFCpo9aRBl0DzumIEkktaz
         zm/np/DRfIS1Ugoyero/iOhGbO04zO1TwNAChY9xpvomYO1zxYAD4gTXeQGfPhBpi9
         BcJw4RWtKHR4W+uHLOv3b+GgINc2afH30uAQTzFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 15/24] bnxt_en: Release PCI regions when DMA mask setup fails during probe.
Date:   Tue,  1 Dec 2020 09:53:21 +0100
Message-Id: <20201201084638.509434706@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084637.754785180@linuxfoundation.org>
References: <20201201084637.754785180@linuxfoundation.org>
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
index aff1a23078903..250ecbcca019f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5199,7 +5199,7 @@ static int bnxt_init_board(struct pci_dev *pdev, struct net_device *dev)
 	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)) != 0) {
 		dev_err(&pdev->dev, "System does not support DMA, aborting\n");
 		rc = -EIO;
-		goto init_err_disable;
+		goto init_err_release;
 	}
 
 	pci_set_master(pdev);
-- 
2.27.0



