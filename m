Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3333AEF8D
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbhFUQkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:40:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232036AbhFUQie (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:38:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9199161432;
        Mon, 21 Jun 2021 16:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292968;
        bh=AgmqPuQ4vC79VvfKyzfKHbZ4/sVKbO2NrtcCYZJUiUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ex/FlZkuqZWWUc6r1NuVNhliWc75rD1MT/ex8pdWU3N9mmDi1Tga7Ebb5zOd3pcBI
         k6Di/vi6A03n1YTyydjl4gsaKnit30ifZ9B83+ZyhWlNArE7lxTUD42sYCqhd5peke
         mDwR+tzwH9nrkzH3RZI/FV0Nb/FL5uXmigjw5GMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 049/178] alx: Fix an error handling path in alx_probe()
Date:   Mon, 21 Jun 2021 18:14:23 +0200
Message-Id: <20210621154924.024650881@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 33e381448cf7a05d76ac0b47d4a6531ecd0e5c53 ]

If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
call, as already done in the remove function.

Fixes: ab69bde6b2e9 ("alx: add a simple AR816x/AR817x device driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/atheros/alx/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 9e02f8864593..5e90df42b201 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1849,6 +1849,7 @@ out_free_netdev:
 	free_netdev(netdev);
 out_pci_release:
 	pci_release_mem_regions(pdev);
+	pci_disable_pcie_error_reporting(pdev);
 out_pci_disable:
 	pci_disable_device(pdev);
 	return err;
-- 
2.30.2



