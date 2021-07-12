Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B923C5425
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346884AbhGLH5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:57:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244199AbhGLHw6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:52:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E6E9610FB;
        Mon, 12 Jul 2021 07:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076209;
        bh=51sHy3bhoALP3+EQcat70uFH9WrQV/g67kmV6WlglbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rqFoLm1pp2Y7sN/xzPm3R2k2vonbFsnGgT3FRB8GfjCvO1dopUWT/wuSt08HPv+sj
         fe3APBPxl+45G003o9LiPLPkMMXPwKYvtWph+nNiKD8ydSnOmYdyBwR7/rVSaRFTYJ
         cklMX/0m1T1dhgz6j37LDsdb6xOsq5OEKmNNCJQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b80c9959009a9325cdff@syzkaller.appspotmail.com,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 545/800] ieee802154: hwsim: Fix memory leak in hwsim_add_one
Date:   Mon, 12 Jul 2021 08:09:28 +0200
Message-Id: <20210712061025.326695674@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit 28a5501c3383f0e6643012c187b7c2027ef42aea ]

No matter from hwsim_remove or hwsim_del_radio_nl, hwsim_del fails to
remove the entry in the edges list. Take the example below, phy0, phy1
and e0 will be deleted, resulting in e1 not freed and accessed in the
future.

              hwsim_phys
                  |
    ------------------------------
    |                            |
phy0 (edges)                 phy1 (edges)
   ----> e1 (idx = 1)             ----> e0 (idx = 0)

Fix this by deleting and freeing all the entries in the edges list
between hwsim_edge_unsubscribe_me and list_del(&phy->list).

Reported-by: syzbot+b80c9959009a9325cdff@syzkaller.appspotmail.com
Fixes: 1c9f4a3fce77 ("ieee802154: hwsim: fix rcu handling")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Acked-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210616020901.2759466-1-mudongliangabcd@gmail.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 366eaae3550a..baa7e21b7f4f 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -824,12 +824,17 @@ err_pib:
 static void hwsim_del(struct hwsim_phy *phy)
 {
 	struct hwsim_pib *pib;
+	struct hwsim_edge *e;
 
 	hwsim_edge_unsubscribe_me(phy);
 
 	list_del(&phy->list);
 
 	rcu_read_lock();
+	list_for_each_entry_rcu(e, &phy->edges, list) {
+		list_del_rcu(&e->list);
+		hwsim_free_edge(e);
+	}
 	pib = rcu_dereference(phy->pib);
 	rcu_read_unlock();
 
-- 
2.30.2



