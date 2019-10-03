Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E156FCA208
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730437AbfJCQBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:01:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731765AbfJCQBU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:01:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2EC721A4C;
        Thu,  3 Oct 2019 16:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118479;
        bh=n7VZmOmiAaJuzqtEgcUqvu4Su2EMXV+PJoK997lsM9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xAF3rB/TrRJB32x5gA6Duntb57ngOBBXuQPMAsKtptVVD8eWQdxVgLn6pfR/0zjsB
         mkWLHnL4KXiX2CAGvCme3j8L8pM/uJM8+eQmD1ke8yMOOAUy/Y5ak2QlDvChAz1MOA
         7eWGPkl9kY/cqWIWt1lxb9nooH+ube1TXBPwv+PE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiumei Mu <xmu@redhat.com>,
        Fei Liu <feliu@redhat.com>, Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 025/129] macsec: drop skb sk before calling gro_cells_receive
Date:   Thu,  3 Oct 2019 17:52:28 +0200
Message-Id: <20191003154330.743447692@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154318.081116689@linuxfoundation.org>
References: <20191003154318.081116689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit ba56d8ce38c8252fff5b745db3899cf092578ede ]

Fei Liu reported a crash when doing netperf on a topo of macsec
dev over veth:

  [  448.919128] refcount_t: underflow; use-after-free.
  [  449.090460] Call trace:
  [  449.092895]  refcount_sub_and_test+0xb4/0xc0
  [  449.097155]  tcp_wfree+0x2c/0x150
  [  449.100460]  ip_rcv+0x1d4/0x3a8
  [  449.103591]  __netif_receive_skb_core+0x554/0xae0
  [  449.108282]  __netif_receive_skb+0x28/0x78
  [  449.112366]  netif_receive_skb_internal+0x54/0x100
  [  449.117144]  napi_gro_complete+0x70/0xc0
  [  449.121054]  napi_gro_flush+0x6c/0x90
  [  449.124703]  napi_complete_done+0x50/0x130
  [  449.128788]  gro_cell_poll+0x8c/0xa8
  [  449.132351]  net_rx_action+0x16c/0x3f8
  [  449.136088]  __do_softirq+0x128/0x320

The issue was caused by skb's true_size changed without its sk's
sk_wmem_alloc increased in tcp/skb_gro_receive(). Later when the
skb is being freed and the skb's truesize is subtracted from its
sk's sk_wmem_alloc in tcp_wfree(), underflow occurs.

macsec is calling gro_cells_receive() to receive a packet, which
actually requires skb->sk to be NULL. However when macsec dev is
over veth, it's possible the skb->sk is still set if the skb was
not unshared or expanded from the peer veth.

ip_rcv() is calling skb_orphan() to drop the skb's sk for tproxy,
but it is too late for macsec's calling gro_cells_receive(). So
fix it by dropping the skb's sk earlier on rx path of macsec.

Fixes: 5491e7c6b1a9 ("macsec: enable GRO and RPS on macsec devices")
Reported-by: Xiumei Mu <xmu@redhat.com>
Reported-by: Fei Liu <feliu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macsec.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1240,6 +1240,7 @@ deliver:
 		macsec_rxsa_put(rx_sa);
 	macsec_rxsc_put(rx_sc);
 
+	skb_orphan(skb);
 	ret = gro_cells_receive(&macsec->gro_cells, skb);
 	if (ret == NET_RX_SUCCESS)
 		count_rx(dev, skb->len);


