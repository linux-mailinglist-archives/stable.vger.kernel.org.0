Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921793C4EF4
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240646AbhGLHW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:22:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245003AbhGLHTS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:19:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 886E9613C7;
        Mon, 12 Jul 2021 07:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074190;
        bh=mnc3HnjhywSJDp5rW3/0SkA46lf//5+ozcBkRiPDFUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QTEOGlpnndzpi1LwfYoa55+V+tdme6ss46T/jUewcFyBbNU+NUuiY5SZedp5MEA/x
         92RBBYYykg83t4m+zMDkG3AMwcYxmN8y7a9uzKhIl6GfGo8l8l8kWXjmJAfqTF5axg
         YVtfPHh+Svfbn6eru/54gEryjGWVdk3NxxPHqeow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bailey Forrest <bcf@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 496/700] gve: Fix swapped vars when fetching max queues
Date:   Mon, 12 Jul 2021 08:09:39 +0200
Message-Id: <20210712061029.266539291@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index bbc423e93122..79cefe85a799 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1295,8 +1295,8 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
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



