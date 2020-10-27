Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC09929C66D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2899824AbgJ0SRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:17:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756148AbgJ0OLg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:11:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24E182072D;
        Tue, 27 Oct 2020 14:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807896;
        bh=+uVjqd8EewbGxslAp/7jN1hEYDFE9SY/OTvdMeaZc5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wx8oFbRncCCgP/LfgiG4aeIrWC16BhCw1/NUsIpcXaCQk8e+csezkZbs0b99YkUUb
         4r0z7Xk84YlSVBlqds1B+DQlEuQsQVJxNpAIUbfm2f+5PpHnxI5mnEMSywCB9hAEpl
         5x31zXB4K0cXsVzgp0m08fYLd5dlYK+kkg3GSFB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Valentin Vidic <vvidic@valentin-vidic.from.hr>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 082/191] net: korina: fix kfree of rx/tx descriptor array
Date:   Tue, 27 Oct 2020 14:48:57 +0100
Message-Id: <20201027134913.628106689@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Vidic <vvidic@valentin-vidic.from.hr>

[ Upstream commit 3af5f0f5c74ecbaf757ef06c3f80d56751277637 ]

kmalloc returns KSEG0 addresses so convert back from KSEG1
in kfree. Also make sure array is freed when the driver is
unloaded from the kernel.

Fixes: ef11291bcd5f ("Add support the Korina (IDT RC32434) Ethernet MAC")
Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/korina.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index 3c0a6451273df..1357d464e8c43 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -1188,7 +1188,7 @@ static int korina_probe(struct platform_device *pdev)
 	return rc;
 
 probe_err_register:
-	kfree(lp->td_ring);
+	kfree(KSEG0ADDR(lp->td_ring));
 probe_err_td_ring:
 	iounmap(lp->tx_dma_regs);
 probe_err_dma_tx:
@@ -1208,6 +1208,7 @@ static int korina_remove(struct platform_device *pdev)
 	iounmap(lp->eth_regs);
 	iounmap(lp->rx_dma_regs);
 	iounmap(lp->tx_dma_regs);
+	kfree(KSEG0ADDR(lp->td_ring));
 
 	unregister_netdev(bif->dev);
 	free_netdev(bif->dev);
-- 
2.25.1



