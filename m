Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD3220E85B
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgF2WGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:06:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbgF2SfT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17A1D24170;
        Mon, 29 Jun 2020 15:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443947;
        bh=34dyPVdeFg/qO3TlEhfhP7V9iu5OMl+FVa3uPJqFPrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=upSYItexZM6D2ivENzSY+dn1AUqvg4fgriaByFQFXAeAxoICzpa3MT9UJCCl8/in9
         Aol4MCrCtLHnVJ4J8M+dONlN2BR91FSSSzchZIvqQtrPbeUIjdozu42ExmGjzcjw0l
         9m7Dd2GCl8VYh9xD2pE34xX5QnMAiFoEyiHHBmNE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 049/265] ionic: update the queue count on open
Date:   Mon, 29 Jun 2020 11:14:42 -0400
Message-Id: <20200629151818.2493727-50-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit fa48494cce5f6360b0f8683cdf258fb45c666287 ]

Let the network stack know the real number of queues that
we are using.

v2: added error checking

Fixes: 49d3b493673a ("ionic: disable the queues on link down")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 7aa037c3fe020..2729b0bb12739 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1653,6 +1653,14 @@ int ionic_open(struct net_device *netdev)
 	if (err)
 		goto err_out;
 
+	err = netif_set_real_num_tx_queues(netdev, lif->nxqs);
+	if (err)
+		goto err_txrx_deinit;
+
+	err = netif_set_real_num_rx_queues(netdev, lif->nxqs);
+	if (err)
+		goto err_txrx_deinit;
+
 	/* don't start the queues until we have link */
 	if (netif_carrier_ok(netdev)) {
 		err = ionic_start_queues(lif);
-- 
2.25.1

