Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE7ACD753
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbfJFR1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:27:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728422AbfJFR1E (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:27:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F255F2077B;
        Sun,  6 Oct 2019 17:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382824;
        bh=ian+tWN6G0IstqirvWiqzGhkZLYP1MXNMkLKu3P74B8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2m1qYlcCPmWTH73naGHBdCdDTPAtEahqm277imaQL2K1v7XN3c0W7XDrjWaesrHLZ
         ZqDEtQOwGhWG9ALigCVUBtbuERjSWTXZ7OPDik9brN8PcB73T9LaWW1d86qMXtGMPO
         e862ZDaxkOisfYbrCwIQSMKGxXhL9Bb71fnCqDCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 54/68] net: qlogic: Fix memory leak in ql_alloc_large_buffers
Date:   Sun,  6 Oct 2019 19:21:30 +0200
Message-Id: <20191006171132.917617857@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171108.150129403@linuxfoundation.org>
References: <20191006171108.150129403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 1acb8f2a7a9f10543868ddd737e37424d5c36cf4 ]

In ql_alloc_large_buffers, a new skb is allocated via netdev_alloc_skb.
This skb should be released if pci_dma_mapping_error fails.

Fixes: 0f8ab89e825f ("qla3xxx: Check return code from pci_map_single() in ql_release_to_lrg_buf_free_list(), ql_populate_free_queue(), ql_alloc_large_buffers(), and ql3xxx_send()")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qla3xxx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -2787,6 +2787,7 @@ static int ql_alloc_large_buffers(struct
 				netdev_err(qdev->ndev,
 					   "PCI mapping failed with error: %d\n",
 					   err);
+				dev_kfree_skb_irq(skb);
 				ql_free_large_buffers(qdev);
 				return -ENOMEM;
 			}


