Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F14824F7DE
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728946AbgHXJWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:22:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730363AbgHXIyr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:54:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C50A207D3;
        Mon, 24 Aug 2020 08:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259286;
        bh=KvW2rz2zbwbkT+LXyYl4TUn0AOswUOmA+ZKF95S8iKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HoglygKaVzpR58G924SMUjBo0vjP5i4jdD5Qd9E6elBCIyzC3fAnHJKFpszh1GJJO
         AEHDLH7jhK9qyeqlAYt8PVVGM+CnuWS//Kdy3UXiBjxthZXRure63qYW6YPaE6FNy4
         l24B2cwgu6ZroE3Zo0oB8PedJk0b5K2g+RyfeeTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 43/50] hv_netvsc: Fix the queue_mapping in netvsc_vf_xmit()
Date:   Mon, 24 Aug 2020 10:31:44 +0200
Message-Id: <20200824082354.226087780@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082351.823243923@linuxfoundation.org>
References: <20200824082351.823243923@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

[ Upstream commit c3d897e01aef8ddc43149e4d661b86f823e3aae7 ]

netvsc_vf_xmit() / dev_queue_xmit() will call VF NIC’s ndo_select_queue
or netdev_pick_tx() again. They will use skb_get_rx_queue() to get the
queue number, so the “skb->queue_mapping - 1” will be used. This may
cause the last queue of VF not been used.

Use skb_record_rx_queue() here, so that the skb_get_rx_queue() called
later will get the correct queue number, and VF will be able to use
all queues.

Fixes: b3bf5666a510 ("hv_netvsc: defer queue selection to VF")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/netvsc_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 10c3480c2da89..dbc6c9ed1c8f8 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -500,7 +500,7 @@ static int netvsc_vf_xmit(struct net_device *net, struct net_device *vf_netdev,
 	int rc;
 
 	skb->dev = vf_netdev;
-	skb->queue_mapping = qdisc_skb_cb(skb)->slave_dev_queue_mapping;
+	skb_record_rx_queue(skb, qdisc_skb_cb(skb)->slave_dev_queue_mapping);
 
 	rc = dev_queue_xmit(skb);
 	if (likely(rc == NET_XMIT_SUCCESS || rc == NET_XMIT_CN)) {
-- 
2.25.1



