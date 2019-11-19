Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2A3D101727
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731122AbfKSFsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:48:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:45488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731414AbfKSFsw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:48:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98DD020721;
        Tue, 19 Nov 2019 05:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142532;
        bh=J6ZEfStz5DT4isXE9ce7olgvh3mbHLrQijoXZCL5OSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gDK1oibrS2sxO3gEh9Gm36slPM8G8U7SzwY/V7c9iiJ88EtgugGC9iETdrvtvqEnr
         coxngEL8+UWd5U5PpMj3fbzoOP3aurk7Q0guXEA3AijjJUXc64XBViREEVSTcvq2nd
         vxvAx/ft6b3u8EIyVUzNwe948HQQll6Sp9m7Tnso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 112/239] llc: avoid blocking in llc_sap_close()
Date:   Tue, 19 Nov 2019 06:18:32 +0100
Message-Id: <20191119051328.074556262@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 9708d2b5b7c648e8e0a40d11e8cea12f6277f33c ]

llc_sap_close() is called by llc_sap_put() which
could be called in BH context in llc_rcv(). We can't
block in BH.

There is no reason to block it here, kfree_rcu() should
be sufficient.

Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/llc.h  | 1 +
 net/llc/llc_core.c | 4 +---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/net/llc.h b/include/net/llc.h
index 890a87318014d..df282d9b40170 100644
--- a/include/net/llc.h
+++ b/include/net/llc.h
@@ -66,6 +66,7 @@ struct llc_sap {
 	int sk_count;
 	struct hlist_nulls_head sk_laddr_hash[LLC_SK_LADDR_HASH_ENTRIES];
 	struct hlist_head sk_dev_hash[LLC_SK_DEV_HASH_ENTRIES];
+	struct rcu_head rcu;
 };
 
 static inline
diff --git a/net/llc/llc_core.c b/net/llc/llc_core.c
index 260b3dc1b4a2a..64d4bef04e730 100644
--- a/net/llc/llc_core.c
+++ b/net/llc/llc_core.c
@@ -127,9 +127,7 @@ void llc_sap_close(struct llc_sap *sap)
 	list_del_rcu(&sap->node);
 	spin_unlock_bh(&llc_sap_list_lock);
 
-	synchronize_rcu();
-
-	kfree(sap);
+	kfree_rcu(sap, rcu);
 }
 
 static struct packet_type llc_packet_type __read_mostly = {
-- 
2.20.1



