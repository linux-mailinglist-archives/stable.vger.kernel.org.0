Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E5632882C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhCARfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:35:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:52092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238426AbhCAR1E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:27:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12EF065082;
        Mon,  1 Mar 2021 16:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617429;
        bh=YOdh5EiaUA7wRJmPPCou7vees5a19kSHPusgQM1AUis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2qQV7Po7OB67JZ1h5+ryH9hik/VQpu7qv+qxdCGOJLqqlbap9DLn80BVzW9ZNpRax
         uiemuYB7fPbIdRzITQlCSUkbAYdop/yB/5v59q6zymCXwHIxSoCLlKHsusciYXnYC0
         BUS6Ht7xWe3MM6GT+tsuU5duEnopMbisufAgZ3YE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Pan <ljp@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 063/340] ibmvnic: add memory barrier to protect long term buffer
Date:   Mon,  1 Mar 2021 17:10:07 +0100
Message-Id: <20210301161051.422059075@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Pan <ljp@linux.ibm.com>

[ Upstream commit 42557dab78edc8235aba5b441f2eb35f725a0ede ]

dma_rmb() barrier is added to load the long term buffer before copying
it to socket buffer; and dma_wmb() barrier is added to update the
long term buffer before it being accessed by VIOS (virtual i/o server).

Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
Acked-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5b5d488c2f374..901883a44a320 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1518,6 +1518,9 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		skb_copy_from_linear_data(skb, dst, skb->len);
 	}
 
+	/* post changes to long_term_buff *dst before VIOS accessing it */
+	dma_wmb();
+
 	tx_pool->consumer_index =
 	    (tx_pool->consumer_index + 1) % tx_pool->num_buffers;
 
@@ -2340,6 +2343,8 @@ restart_poll:
 		offset = be16_to_cpu(next->rx_comp.off_frame_data);
 		flags = next->rx_comp.flags;
 		skb = rx_buff->skb;
+		/* load long_term_buff before copying to skb */
+		dma_rmb();
 		skb_copy_to_linear_data(skb, rx_buff->data + offset,
 					length);
 
-- 
2.27.0



