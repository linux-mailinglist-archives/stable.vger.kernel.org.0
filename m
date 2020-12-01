Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7822D2C9B34
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbgLAJFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:05:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:41590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389028AbgLAJE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:04:58 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EA19221EB;
        Tue,  1 Dec 2020 09:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813482;
        bh=OVMWgln4or0cDJzFDwpO29MW4EsuAXvwB+vwDWbmbG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cWXcdiuN+8E4MtrUyp9CWstYd6rw7DTaej+LIlVOO55eoJhooda/TUJWFHHM6I8Dr
         3ztuH1ieCUYwU4JWgC3ltBR1ayfMULeI9N1NRwjdqSzZgcgZ6bAcQ3q2NnAG/0ZGCs
         QiRuZGP2iN7V2CAA07WVPFmoVeyhDZ300ZCWuTVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 53/98] bnxt_en: Release PCI regions when DMA mask setup fails during probe.
Date:   Tue,  1 Dec 2020 09:53:30 +0100
Message-Id: <20201201084657.701397651@linuxfoundation.org>
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
index d8e1d7a9196cd..7c8187d386756 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10827,7 +10827,7 @@ static int bnxt_init_board(struct pci_dev *pdev, struct net_device *dev)
 	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)) != 0) {
 		dev_err(&pdev->dev, "System does not support DMA, aborting\n");
 		rc = -EIO;
-		goto init_err_disable;
+		goto init_err_release;
 	}
 
 	pci_set_master(pdev);
-- 
2.27.0



