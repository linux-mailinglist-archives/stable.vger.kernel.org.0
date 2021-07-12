Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240AE3C4E78
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242287AbhGLHTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:19:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243955AbhGLHRz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:17:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF13D6145A;
        Mon, 12 Jul 2021 07:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074107;
        bh=8eDjzXcloaE/8l5tgHAKTWdZoA2jNyk7sZYlVDT92Hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eg4sNwEeKbPPNI6/A0hpSmo+DTKujO2dpLeOuax3pZOTh4tuGcNxuWHxQnaMU2o/y
         MT6rzcWC2No23QN7luypZPFtlnKNPa6bvuNRLXKCQGYkl1MIEjDZC6+PtoqZc1moRY
         +Z2tX/ucCNxGPN2MTLG4uR8VSZ1KsoqkN5EWK+iM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b80c9959009a9325cdff@syzkaller.appspotmail.com,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 467/700] ieee802154: hwsim: Fix memory leak in hwsim_add_one
Date:   Mon, 12 Jul 2021 08:09:10 +0200
Message-Id: <20210712061026.270187715@linuxfoundation.org>
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
index 7a168170224a..6d479df2d9e5 100644
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



