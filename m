Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA6E29C593
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1753669AbgJ0OBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:01:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411651AbgJ0OBY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:01:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3EE722202;
        Tue, 27 Oct 2020 14:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807283;
        bh=eNqI4I4kiQ1KvcRJ+NmcfrVoNL3GnkpktsSWrFMNXgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XpyKXKBJF99gg66jZ5peiS31+pnvARoNdymy+z+6RHdKjvCc65WK7/ja7kN5XOEEj
         fKQxCrMn67T89UMqL1vx8qIwjBNq7NcrMHQvy4ZLDlKtncuhrVbtjiZfAI2eRj1qJN
         iZchbb0L4Zf9cFGZXNQ6G8Arzq4gDPbI8o+owDfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Valentin Vidic <vvidic@valentin-vidic.from.hr>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 110/112] net: korina: cast KSEG0 address to pointer in kfree
Date:   Tue, 27 Oct 2020 14:50:20 +0100
Message-Id: <20201027134905.753733650@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Vidic <vvidic@valentin-vidic.from.hr>

[ Upstream commit 3bd57b90554b4bb82dce638e0668ef9dc95d3e96 ]

Fixes gcc warning:

passing argument 1 of 'kfree' makes pointer from integer without a cast

Fixes: 3af5f0f5c74e ("net: korina: fix kfree of rx/tx descriptor array")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
Link: https://lore.kernel.org/r/20201018184255.28989-1-vvidic@valentin-vidic.from.hr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/korina.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index 3954c80f70fcb..b491de946a0e6 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -1188,7 +1188,7 @@ static int korina_probe(struct platform_device *pdev)
 	return rc;
 
 probe_err_register:
-	kfree(KSEG0ADDR(lp->td_ring));
+	kfree((struct dma_desc *)KSEG0ADDR(lp->td_ring));
 probe_err_td_ring:
 	iounmap(lp->tx_dma_regs);
 probe_err_dma_tx:
@@ -1208,7 +1208,7 @@ static int korina_remove(struct platform_device *pdev)
 	iounmap(lp->eth_regs);
 	iounmap(lp->rx_dma_regs);
 	iounmap(lp->tx_dma_regs);
-	kfree(KSEG0ADDR(lp->td_ring));
+	kfree((struct dma_desc *)KSEG0ADDR(lp->td_ring));
 
 	unregister_netdev(bif->dev);
 	free_netdev(bif->dev);
-- 
2.25.1



