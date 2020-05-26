Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6BD11E2B88
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403798AbgEZTGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:06:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390814AbgEZTGD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:06:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17C4B20776;
        Tue, 26 May 2020 19:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519963;
        bh=k1pYullWqpInfsxDo6wY0GeaN+fOQTMAQ/FTViw8IwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y1ltvxEViEe4ASyGoPwY2+LfymGHpE3mtSmw+GOKz0mzT0w9ci0BQ0HsR8y+wdLLA
         9VdPjxdZE10kCgqBwU3jHT5KHFWNgkFKaJHbJw8h1S5xOn6tqzrt5A4X2n/tsTUg8y
         nSv0aTeD38N6qGX9OG4gGdEP77WSQYipsBe3T3YM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arjun Vynipadath <arjun@chelsio.com>,
        Ganesh Goudar <ganeshgr@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 60/81] cxgb4: free mac_hlist properly
Date:   Tue, 26 May 2020 20:53:35 +0200
Message-Id: <20200526183933.717662881@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183923.108515292@linuxfoundation.org>
References: <20200526183923.108515292@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arjun Vynipadath <arjun@chelsio.com>

[ Upstream commit 2a8d84bf513823ba398f4b2dec41b8decf4041af ]

The locally maintained list for tracking hash mac table was
not freed during driver remove.

Signed-off-by: Arjun Vynipadath <arjun@chelsio.com>
Signed-off-by: Ganesh Goudar <ganeshgr@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index c81d6c330548..c334b6206871 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -2296,6 +2296,8 @@ static int cxgb_up(struct adapter *adap)
 
 static void cxgb_down(struct adapter *adapter)
 {
+	struct hash_mac_addr *entry, *tmp;
+
 	cancel_work_sync(&adapter->tid_release_task);
 	cancel_work_sync(&adapter->db_full_task);
 	cancel_work_sync(&adapter->db_drop_task);
@@ -2304,6 +2306,12 @@ static void cxgb_down(struct adapter *adapter)
 
 	t4_sge_stop(adapter);
 	t4_free_sge_resources(adapter);
+
+	list_for_each_entry_safe(entry, tmp, &adapter->mac_hlist, list) {
+		list_del(&entry->list);
+		kfree(entry);
+	}
+
 	adapter->flags &= ~FULL_INIT_DONE;
 }
 
-- 
2.25.1



