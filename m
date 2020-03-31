Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39749198F7A
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730857AbgCaJDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:03:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730853AbgCaJDn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:03:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACC2E20B80;
        Tue, 31 Mar 2020 09:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645422;
        bh=wK2V//ipX04GClahuF3eGxYEeP8OuhNS+fo3Fgr+2yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OEyCm89Mw9J54XSahVJ8WSn3lbR+/MZ/31f7/GMHcXhqukBPOJbHFO9OTwjfu6NFD
         HaxqCJ6n3tVCr4pcEncDIGhN2We5HLcXueowCO1aLOi+qJHRwP4cuMnQfmF6Mr2A9p
         wWmYrFKmnMnD1QqiG1Yq1iIh2kHMWZCnBd61fSis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameeh Jubran <sameehj@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 048/170] net: ena: fix request of incorrect number of IRQ vectors
Date:   Tue, 31 Mar 2020 10:57:42 +0200
Message-Id: <20200331085429.519147945@linuxfoundation.org>
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

[ Upstream commit e02ae6ed51be3d28923bfd318ae57000f5643da5 ]

Bug:
In short the main issue is caused by the fact that the number of queues
is changed using ethtool after ena_probe() has been called and before
ena_up() was executed. Here is the full scenario in detail:

* ena_probe() is called when the driver is loaded, the driver is not up
  yet at the end of ena_probe().
* The number of queues is changed -> io_queue_count is changed as well -
  ena_up() is not called since the "dev_was_up" boolean in
  ena_update_queue_count() is false.
* ena_up() is called by the kernel (it's called asynchronously some
  time after ena_probe()). ena_setup_io_intr() is called by ena_up() and
  it uses io_queue_count to get the suitable irq lines for each msix
  vector. The function ena_request_io_irq() is called right after that
  and it uses msix_vecs - This value only changes during ena_probe() and
  ena_restore() - to request the irq vectors. This results in "Failed to
  request I/O IRQ" error for i > io_queue_count.

Numeric example:
* After ena_probe() io_queue_count = 8, msix_vecs = 9.
* The number of queues changes to 4 -> io_queue_count = 4, msix_vecs = 9.
* ena_up() is executed for the first time:
  ** ena_setup_io_intr() inits the vectors only up to io_queue_count.
  ** ena_request_io_irq() calls request_irq() and fails for i = 5.

How to reproduce:
simply run the following commands:
    sudo rmmod ena && sudo insmod ena.ko;
    sudo ethtool -L eth1 combined 3;

Fix:
Use ENA_MAX_MSIX_VEC(adapter->num_io_queues + adapter->xdp_num_queues)
instead of adapter->msix_vecs. We need to take XDP queues into
consideration as they need to have msix vectors assigned to them as well.
Note that the XDP cannot be attached before the driver is up and running
but in XDP mode the issue might occur when the number of queues changes
right after a reset trigger.
The ENA_MAX_MSIX_VEC simply adds one to the argument since the first msix
vector is reserved for management queue.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1444,6 +1444,7 @@ static int ena_request_mgmnt_irq(struct
 
 static int ena_request_io_irq(struct ena_adapter *adapter)
 {
+	u32 io_queue_count = adapter->num_io_queues;
 	unsigned long flags = 0;
 	struct ena_irq *irq;
 	int rc = 0, i, k;
@@ -1454,7 +1455,7 @@ static int ena_request_io_irq(struct ena
 		return -EINVAL;
 	}
 
-	for (i = ENA_IO_IRQ_FIRST_IDX; i < adapter->msix_vecs; i++) {
+	for (i = ENA_IO_IRQ_FIRST_IDX; i < ENA_MAX_MSIX_VEC(io_queue_count); i++) {
 		irq = &adapter->irq_tbl[i];
 		rc = request_irq(irq->vector, irq->handler, flags, irq->name,
 				 irq->data);
@@ -1495,6 +1496,7 @@ static void ena_free_mgmnt_irq(struct en
 
 static void ena_free_io_irq(struct ena_adapter *adapter)
 {
+	u32 io_queue_count = adapter->num_io_queues;
 	struct ena_irq *irq;
 	int i;
 
@@ -1505,7 +1507,7 @@ static void ena_free_io_irq(struct ena_a
 	}
 #endif /* CONFIG_RFS_ACCEL */
 
-	for (i = ENA_IO_IRQ_FIRST_IDX; i < adapter->msix_vecs; i++) {
+	for (i = ENA_IO_IRQ_FIRST_IDX; i < ENA_MAX_MSIX_VEC(io_queue_count); i++) {
 		irq = &adapter->irq_tbl[i];
 		irq_set_affinity_hint(irq->vector, NULL);
 		free_irq(irq->vector, irq->data);
@@ -1520,12 +1522,13 @@ static void ena_disable_msix(struct ena_
 
 static void ena_disable_io_intr_sync(struct ena_adapter *adapter)
 {
+	u32 io_queue_count = adapter->num_io_queues;
 	int i;
 
 	if (!netif_running(adapter->netdev))
 		return;
 
-	for (i = ENA_IO_IRQ_FIRST_IDX; i < adapter->msix_vecs; i++)
+	for (i = ENA_IO_IRQ_FIRST_IDX; i < ENA_MAX_MSIX_VEC(io_queue_count); i++)
 		synchronize_irq(adapter->irq_tbl[i].vector);
 }
 


