Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D82824F89C
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgHXJfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:35:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729649AbgHXItE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:49:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9945F204FD;
        Mon, 24 Aug 2020 08:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258943;
        bh=Wh6sT37MzZ5crsokFE5tf1ZxGjZm1aGj9OgnT/9kwyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hxvLzLp/oE+guqOazVHIo4M6p1AWFgDinxIgD6BAFRGYgCWduXHTN6otLbbJ8sFL4
         ArXwQJJS0jv91nKu/Pu3GLkzg6YqPHIUEKFDHb2I1oT67DBBsyoOLYB5gixq3pabRC
         UWO/Qv3yfEegej1K+hlRcW4aJ3IDW1NATxV6mcZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 100/107] hv_netvsc: Fix the queue_mapping in netvsc_vf_xmit()
Date:   Mon, 24 Aug 2020 10:31:06 +0200
Message-Id: <20200824082410.035303327@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082405.020301642@linuxfoundation.org>
References: <20200824082405.020301642@linuxfoundation.org>
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
index 24bb721a12bc0..42eb7a7ecd96b 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -501,7 +501,7 @@ static int netvsc_vf_xmit(struct net_device *net, struct net_device *vf_netdev,
 	int rc;
 
 	skb->dev = vf_netdev;
-	skb->queue_mapping = qdisc_skb_cb(skb)->slave_dev_queue_mapping;
+	skb_record_rx_queue(skb, qdisc_skb_cb(skb)->slave_dev_queue_mapping);
 
 	rc = dev_queue_xmit(skb);
 	if (likely(rc == NET_XMIT_SUCCESS || rc == NET_XMIT_CN)) {
-- 
2.25.1



