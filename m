Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C07A0177F4B
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729542AbgCCRtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:49:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:57188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731823AbgCCRtu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:49:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C95220CC7;
        Tue,  3 Mar 2020 17:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257789;
        bh=RBjNpK8Qs+hQfI47cgTFrU6KM7ouFwPOh+BzvMklbxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XWmurU9V/U8yW2pYQMs14B+IM+7lwwHQKZ1kQR3v+EUpQ6GTLPKxJxDwSwKxCwfi3
         CleoQ4cN1Ln9KlmBjTjQn9yc3GMeMJM0elb7yIvMUv0s6jk2BF3c7BDy2FcL8j8TmL
         MEOpJHw3DbTKYdp6UeEs71T3NT0uuvL6Ml5LCEuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Vu-Brugier <cvubrugier@fastmail.fm>,
        Igor Russkikh <irusskikh@marvell.com>,
        Pavel Belous <pbelous@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 129/176] net: atlantic: fix use after free kasan warn
Date:   Tue,  3 Mar 2020 18:43:13 +0100
Message-Id: <20200303174319.649509816@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Belous <pbelous@marvell.com>

commit a4980919ad6a7be548d499bc5338015e1a9191c6 upstream.

skb->len is used to calculate statistics after xmit invocation.

Under a stress load it may happen that skb will be xmited,
rx interrupt will come and skb will be freed, all before xmit function
is even returned.

Eventually, skb->len will access unallocated area.

Moving stats calculation into tx_clean routine.

Fixes: 018423e90bee ("net: ethernet: aquantia: Add ring support code")
Reported-by: Christophe Vu-Brugier <cvubrugier@fastmail.fm>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Pavel Belous <pbelous@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c  |    4 ----
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c |    7 +++++--
 2 files changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -655,10 +655,6 @@ int aq_nic_xmit(struct aq_nic_s *self, s
 	if (likely(frags)) {
 		err = self->aq_hw_ops->hw_ring_tx_xmit(self->aq_hw,
 						       ring, frags);
-		if (err >= 0) {
-			++ring->stats.tx.packets;
-			ring->stats.tx.bytes += skb->len;
-		}
 	} else {
 		err = NETDEV_TX_BUSY;
 	}
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -272,9 +272,12 @@ bool aq_ring_tx_clean(struct aq_ring_s *
 			}
 		}
 
-		if (unlikely(buff->is_eop))
-			dev_kfree_skb_any(buff->skb);
+		if (unlikely(buff->is_eop)) {
+			++self->stats.rx.packets;
+			self->stats.tx.bytes += buff->skb->len;
 
+			dev_kfree_skb_any(buff->skb);
+		}
 		buff->pa = 0U;
 		buff->eop_index = 0xffffU;
 		self->sw_head = aq_ring_next_dx(self, self->sw_head);


