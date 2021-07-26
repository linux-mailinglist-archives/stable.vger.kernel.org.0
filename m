Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243523D6013
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237053AbhGZPUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:20:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237048AbhGZPUf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:20:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3A4D60240;
        Mon, 26 Jul 2021 16:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315264;
        bh=a6YrQZv5LKpL75iQ4TZKKOxnc3Ip/xvuy4H7IeblRfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zX46pRXr6qHDgDgDXlRKUyaeGnAniZq+GdCTLcC2W8B4PItFi0Hl3naj2ojBpP++A
         ruZbIMHCexVAYmhGkiiEfjmWfgIVIXQNUkOXgSDyubJ4d5FCTwbJVWam7u97orW/FK
         mkzMu/XbbLi9Jj0ViOhVMg8sLzbKRBokdTrwT0vE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shahjada Abul Husain <shahjada@chelsio.com>,
        Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/167] cxgb4: fix IRQ free race during driver unload
Date:   Mon, 26 Jul 2021 17:37:41 +0200
Message-Id: <20210726153840.318306049@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shahjada Abul Husain <shahjada@chelsio.com>

[ Upstream commit 015fe6fd29c4b9ac0f61b8c4455ef88e6018b9cc ]

IRQs are requested during driver's ndo_open() and then later
freed up in disable_interrupts() during driver unload.
A race exists where driver can set the CXGB4_FULL_INIT_DONE
flag in ndo_open() after the disable_interrupts() in driver
unload path checks it, and hence misses calling free_irq().

Fix by unregistering netdevice first and sync with driver's
ndo_open(). This ensures disable_interrupts() checks the flag
correctly and frees up the IRQs properly.

Fixes: b37987e8db5f ("cxgb4: Disable interrupts and napi before unregistering netdev")
Signed-off-by: Shahjada Abul Husain <shahjada@chelsio.com>
Signed-off-by: Raju Rangoju <rajur@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c    | 18 ++++++++++--------
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c |  3 +++
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 8be525c5e2e4..6698afad4379 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -2643,6 +2643,9 @@ static void detach_ulds(struct adapter *adap)
 {
 	unsigned int i;
 
+	if (!is_uld(adap))
+		return;
+
 	mutex_lock(&uld_mutex);
 	list_del(&adap->list_node);
 
@@ -7145,10 +7148,13 @@ static void remove_one(struct pci_dev *pdev)
 		 */
 		destroy_workqueue(adapter->workq);
 
-		if (is_uld(adapter)) {
-			detach_ulds(adapter);
-			t4_uld_clean_up(adapter);
-		}
+		detach_ulds(adapter);
+
+		for_each_port(adapter, i)
+			if (adapter->port[i]->reg_state == NETREG_REGISTERED)
+				unregister_netdev(adapter->port[i]);
+
+		t4_uld_clean_up(adapter);
 
 		adap_free_hma_mem(adapter);
 
@@ -7156,10 +7162,6 @@ static void remove_one(struct pci_dev *pdev)
 
 		cxgb4_free_mps_ref_entries(adapter);
 
-		for_each_port(adapter, i)
-			if (adapter->port[i]->reg_state == NETREG_REGISTERED)
-				unregister_netdev(adapter->port[i]);
-
 		debugfs_remove_recursive(adapter->debugfs_root);
 
 		if (!is_t4(adapter->params.chip))
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
index 743af9e654aa..17faac715882 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
@@ -581,6 +581,9 @@ void t4_uld_clean_up(struct adapter *adap)
 {
 	unsigned int i;
 
+	if (!is_uld(adap))
+		return;
+
 	mutex_lock(&uld_mutex);
 	for (i = 0; i < CXGB4_ULD_MAX; i++) {
 		if (!adap->uld[i].handle)
-- 
2.30.2



