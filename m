Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2B429B48F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1790060AbgJ0PDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:03:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1790054AbgJ0PDk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:03:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9189B206E5;
        Tue, 27 Oct 2020 15:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811020;
        bh=ozxkbFFenR9Y7zzU2twX5o755Tjx9+u4UuqQpLoXqVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2VEzJPUHYUqY9XXDVtgziP8lKlQYltaez3qQNupchc8jXAOArvN5kusCNU90IM5Ii
         X86DBL+EPUnG0EvmFtXcShmXy1bA/zFyVtLWZo+O77JcVdK24eV/Zzarb9Qdo10cdw
         5/pumsmgzrhHwH9reSzrbLDhs/pY5vsRaY2wgNRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Valentin Vidic <vvidic@valentin-vidic.from.hr>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 314/633] net: korina: fix kfree of rx/tx descriptor array
Date:   Tue, 27 Oct 2020 14:50:57 +0100
Message-Id: <20201027135537.406884535@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
index 03e034918d147..af441d699a57a 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -1113,7 +1113,7 @@ static int korina_probe(struct platform_device *pdev)
 	return rc;
 
 probe_err_register:
-	kfree(lp->td_ring);
+	kfree(KSEG0ADDR(lp->td_ring));
 probe_err_td_ring:
 	iounmap(lp->tx_dma_regs);
 probe_err_dma_tx:
@@ -1133,6 +1133,7 @@ static int korina_remove(struct platform_device *pdev)
 	iounmap(lp->eth_regs);
 	iounmap(lp->rx_dma_regs);
 	iounmap(lp->tx_dma_regs);
+	kfree(KSEG0ADDR(lp->td_ring));
 
 	unregister_netdev(bif->dev);
 	free_netdev(bif->dev);
-- 
2.25.1



