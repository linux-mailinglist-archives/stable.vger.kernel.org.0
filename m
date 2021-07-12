Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9FB3C4A2E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238651AbhGLGtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:49:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238026AbhGLGsW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:48:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FE15611BF;
        Mon, 12 Jul 2021 06:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072234;
        bh=qqMAMaqcH6jEQvAeHnqpoXh+2VO3CcBbepX3VWXZwLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OJrnVy5S+ILAmRgMYUwJnJxNYMmiTl/m7QORqa0f1Ebsmrljp28dw6tN58Z16n6ch
         jzvZY+ferzJT7pT9TNATMuAab7fB1mcljA6UK5hTScZs1HcHf6M+tYSaOgU4dSzkgy
         +uSYJFKgj3frISDrPuiqDD208P05AcMFmzK3L58U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bailey Forrest <bcf@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 411/593] gve: Fix swapped vars when fetching max queues
Date:   Mon, 12 Jul 2021 08:09:31 +0200
Message-Id: <20210712060933.129271340@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index d6e35421d8f7..3a74e4645ce6 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1286,8 +1286,8 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
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



