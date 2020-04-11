Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 838D81A50BA
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgDKMUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:20:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728760AbgDKMUe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:20:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D0F4206A1;
        Sat, 11 Apr 2020 12:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607634;
        bh=ZFRKu7T0QMH0e1Z2flWLRUedFO+7KJpENq+wTe3F1AQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xXLG4gmVFUuisE+XVi46ONWmBc1RQMBegcmbmFuYj8m4DyC3yFPsu6qFfO9OZHrkS
         ljtjDNIhP1e5nG2wtm0Ul4+Qg7DN06Urn1GNqTIu1Zd1h3paXcYOsyDvcFaP+ChlxK
         hbfCl39PkTLMo0CDqBUzCnX8GBA7UDXABykb0UQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 14/38] cxgb4: free MQPRIO resources in shutdown path
Date:   Sat, 11 Apr 2020 14:09:51 +0200
Message-Id: <20200411115500.799950568@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115459.324496182@linuxfoundation.org>
References: <20200411115459.324496182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

[ Upstream commit cef8dac96bc108633f5090bb3a9988d734dc1ee0 ]

Perform missing MQPRIO resource cleanup in PCI shutdown path. Also,
fix MQPRIO MSIX bitmap leak in resource cleanup.

Fixes: b1396c2bd675 ("cxgb4: parse and configure TC-MQPRIO offload")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c      |    4 +++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c |   23 +++++++++++++++++++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h |    1 
 3 files changed, 28 insertions(+)

--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -6681,6 +6681,10 @@ static void shutdown_one(struct pci_dev
 			if (adapter->port[i]->reg_state == NETREG_REGISTERED)
 				cxgb_close(adapter->port[i]);
 
+		rtnl_lock();
+		cxgb4_mqprio_stop_offload(adapter);
+		rtnl_unlock();
+
 		if (is_uld(adapter)) {
 			detach_ulds(adapter);
 			t4_uld_clean_up(adapter);
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
@@ -301,6 +301,7 @@ static void cxgb4_mqprio_free_hw_resourc
 			cxgb4_clear_msix_aff(eorxq->msix->vec,
 					     eorxq->msix->aff_mask);
 			free_irq(eorxq->msix->vec, &eorxq->rspq);
+			cxgb4_free_msix_idx_in_bmap(adap, eorxq->msix->idx);
 		}
 
 		free_rspq_fl(adap, &eorxq->rspq, &eorxq->fl);
@@ -611,6 +612,28 @@ out:
 	return ret;
 }
 
+void cxgb4_mqprio_stop_offload(struct adapter *adap)
+{
+	struct cxgb4_tc_port_mqprio *tc_port_mqprio;
+	struct net_device *dev;
+	u8 i;
+
+	if (!adap->tc_mqprio || !adap->tc_mqprio->port_mqprio)
+		return;
+
+	for_each_port(adap, i) {
+		dev = adap->port[i];
+		if (!dev)
+			continue;
+
+		tc_port_mqprio = &adap->tc_mqprio->port_mqprio[i];
+		if (!tc_port_mqprio->mqprio.qopt.num_tc)
+			continue;
+
+		cxgb4_mqprio_disable_offload(dev);
+	}
+}
+
 int cxgb4_init_tc_mqprio(struct adapter *adap)
 {
 	struct cxgb4_tc_port_mqprio *tc_port_mqprio, *port_mqprio;
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h
@@ -38,6 +38,7 @@ struct cxgb4_tc_mqprio {
 
 int cxgb4_setup_tc_mqprio(struct net_device *dev,
 			  struct tc_mqprio_qopt_offload *mqprio);
+void cxgb4_mqprio_stop_offload(struct adapter *adap);
 int cxgb4_init_tc_mqprio(struct adapter *adap);
 void cxgb4_cleanup_tc_mqprio(struct adapter *adap);
 #endif /* __CXGB4_TC_MQPRIO_H__ */


