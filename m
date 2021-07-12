Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6EA3C46B3
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235465AbhGLG2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:28:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235360AbhGLG0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:26:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74CDF61108;
        Mon, 12 Jul 2021 06:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071022;
        bh=OAm+OdohTizo4+AtkBDsESXWOtWNHrNT39VbjAB9Rj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tosmKAtBGELU14/AvD7LHA9hwECKi4b81WxKWDFm3M9hbdtWgUYJNAn0QwSE8H7wh
         lFL9nPpCxapnu+lJbMSo6P8bRIL9dvFLs5vTIEtsfHc/FTy1SOlwlLoSHg9HVuiday
         BkjtfZqTo8RPnxCgw4ODv1GSZV/IfDxe2cJxSrcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bailey Forrest <bcf@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 240/348] gve: Fix swapped vars when fetching max queues
Date:   Mon, 12 Jul 2021 08:10:24 +0200
Message-Id: <20210712060734.299270294@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bailey Forrest <bcf@google.com>

[ Upstream commit 1db1a862a08f85edc36aad091236ac9b818e949e ]

Fixes: 893ce44df565 ("gve: Add basic driver framework for Compute Engine Virtual NIC")
Signed-off-by: Bailey Forrest <bcf@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 6ea0975d74a1..1c4b35b1b359 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1118,8 +1118,8 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	gve_write_version(&reg_bar->driver_version);
 	/* Get max queues to alloc etherdev */
-	max_rx_queues = ioread32be(&reg_bar->max_tx_queues);
-	max_tx_queues = ioread32be(&reg_bar->max_rx_queues);
+	max_tx_queues = ioread32be(&reg_bar->max_tx_queues);
+	max_rx_queues = ioread32be(&reg_bar->max_rx_queues);
 	/* Alloc and setup the netdev and priv */
 	dev = alloc_etherdev_mqs(sizeof(*priv), max_tx_queues, max_rx_queues);
 	if (!dev) {
-- 
2.30.2



