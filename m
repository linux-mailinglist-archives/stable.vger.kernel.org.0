Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC06B106BA7
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbfKVKqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:46:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:53208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729622AbfKVKqN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:46:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28DE120730;
        Fri, 22 Nov 2019 10:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419572;
        bh=YoAQqpCpMdIlQ80ZmYkZIXm+v4XVPdSGfske2Le15so=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLtsKLmvCAP969A9sKV66ZtU7xzPze6eICkCusQP4qtTBmpCkWomWOowmoKwRsBuB
         EWZepPvnZ3XGD+LIWV8az7cAowL7SeL++elr2+/2HZ5HmVb5qcAZaisnzazoaXk1HD
         y2F3vK+lWr6Jn1TAiHnGwYorsQ3vobs5TH6NjyLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Wei Liu <wei.liu2@citrix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 156/222] net: xen-netback: fix return type of ndo_start_xmit function
Date:   Fri, 22 Nov 2019 11:28:16 +0100
Message-Id: <20191122100913.961717661@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit a9ca7f17c6d240e269a24cbcd76abf9a940309dd ]

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, so make sure the implementation in
this driver has returns 'netdev_tx_t' value, and change the function
return type to netdev_tx_t.

Found by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Wei Liu <wei.liu2@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/interface.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index e1f47b6ea3b76..46008f2845502 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -171,7 +171,8 @@ static u16 xenvif_select_queue(struct net_device *dev, struct sk_buff *skb,
 	return vif->hash.mapping[skb_get_hash_raw(skb) % size];
 }
 
-static int xenvif_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t
+xenvif_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct xenvif *vif = netdev_priv(dev);
 	struct xenvif_queue *queue = NULL;
-- 
2.20.1



