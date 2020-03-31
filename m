Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4427E198F78
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730567AbgCaJDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:03:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730616AbgCaJDk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:03:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28A6220787;
        Tue, 31 Mar 2020 09:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645419;
        bh=Zf31paX7k2ZkrtIcuW+qjbnpvFLPskIxAlURiEL6dX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wgkYENoCXgtCMTaClTb9z/G6PHFkGIvhRSpJgoheJYb11J7vo64W1cYIZpi+2KzBy
         rbSu4PDifiifQfyrDEUUwdKMiUD+p2QuaL/ZVL8y20Z5nCoT8tKrZ4l2SYeti0TcHe
         uCoMCYuKAKt7wjId3hf4CXROwvoxozXfkMdVSSzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameeh Jubran <sameehj@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 047/170] net: ena: fix incorrect setting of the number of msix vectors
Date:   Tue, 31 Mar 2020 10:57:41 +0200
Message-Id: <20200331085429.420618706@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

[ Upstream commit ce1f352162828ba07470328828a32f47aa759020 ]

Overview:
We don't frequently change the msix vectors throughout the life cycle of
the driver. We do so in two functions: ena_probe() and ena_restore().
ena_probe() is only called when the driver is loaded. ena_restore() on the
other hand is called during device reset / resume operations.

We use num_io_queues for calculating and allocating the number of msix
vectors. At ena_probe() this value is equal to max_num_io_queues and thus
this is not an issue, however ena_restore() might be called after the
number of io queues has changed.

A possible bug scenario is as follows:

* Change number of queues from 8 to 4.
  (num_io_queues = 4, max_num_io_queues = 8, msix_vecs = 9,)
* Trigger reset occurs -> ena_restore is called.
  (num_io_queues = 4, max_num_io_queues =8 , msix_vecs = 5)
* Change number of queues from 4 to 6.
  (num_io_queues = 6, max_num_io_queues = 8, msix_vecs = 5)
* The driver will reset due to failure of check_for_rx_interrupt_queue()

Fix:
This can be easily fixed by always using max_num_io_queues to init the
msix_vecs, since this number won't change as opposed to num_io_queues.

Fixes: 4d19266022ec ("net: ena: multiple queue creation related cleanups")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1346,7 +1346,7 @@ static int ena_enable_msix(struct ena_ad
 	}
 
 	/* Reserved the max msix vectors we might need */
-	msix_vecs = ENA_MAX_MSIX_VEC(adapter->num_io_queues);
+	msix_vecs = ENA_MAX_MSIX_VEC(adapter->max_num_io_queues);
 	netif_dbg(adapter, probe, adapter->netdev,
 		  "trying to enable MSI-X, vectors %d\n", msix_vecs);
 


