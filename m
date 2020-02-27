Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC0E4171B14
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732591AbgB0N7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:59:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:60658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732590AbgB0N7R (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:59:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9220B24691;
        Thu, 27 Feb 2020 13:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811956;
        bh=bjDSwfu4eejKeiVNGo3zOWZARMf3vjVe0uMdiILHoqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hCt8S50L6VUvG3418Gf4okByHB0uBEPlKu+CyRpA1WfUF0DQZ9TllHIHkI9BSGB+a
         PZh7qlm8PMpQxC/bzIGFxQ2HduRXPkiBBmmGnrjinZHML1j5DK2Uk4LmHwAQtHkqjy
         JWcltqtfnHObyGVMaHX/tMB5eaGtpzuGXeSDodGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Firo Yang <firo.yang@suse.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 167/237] enic: prevent waking up stopped tx queues over watchdog reset
Date:   Thu, 27 Feb 2020 14:36:21 +0100
Message-Id: <20200227132308.752414569@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Firo Yang <firo.yang@suse.com>

[ Upstream commit 0f90522591fd09dd201065c53ebefdfe3c6b55cb ]

Recent months, our customer reported several kernel crashes all
preceding with following message:
NETDEV WATCHDOG: eth2 (enic): transmit queue 0 timed out
Error message of one of those crashes:
BUG: unable to handle kernel paging request at ffffffffa007e090

After analyzing severl vmcores, I found that most of crashes are
caused by memory corruption. And all the corrupted memory areas
are overwritten by data of network packets. Moreover, I also found
that the tx queues were enabled over watchdog reset.

After going through the source code, I found that in enic_stop(),
the tx queues stopped by netif_tx_disable() could be woken up over
a small time window between netif_tx_disable() and the
napi_disable() by the following code path:
napi_poll->
  enic_poll_msix_wq->
     vnic_cq_service->
        enic_wq_service->
           netif_wake_subqueue(enic->netdev, q_number)->
              test_and_clear_bit(__QUEUE_STATE_DRV_XOFF, &txq->state)
In turn, upper netowrk stack could queue skb to ENIC NIC though
enic_hard_start_xmit(). And this might introduce some race condition.

Our customer comfirmed that this kind of kernel crash doesn't occur over
90 days since they applied this patch.

Signed-off-by: Firo Yang <firo.yang@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cisco/enic/enic_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -1972,10 +1972,10 @@ static int enic_stop(struct net_device *
 		napi_disable(&enic->napi[i]);
 
 	netif_carrier_off(netdev);
-	netif_tx_disable(netdev);
 	if (vnic_dev_get_intr_mode(enic->vdev) == VNIC_DEV_INTR_MODE_MSIX)
 		for (i = 0; i < enic->wq_count; i++)
 			napi_disable(&enic->napi[enic_cq_wq(enic, i)]);
+	netif_tx_disable(netdev);
 
 	if (!enic_is_dynamic(enic) && !enic_is_sriov_vf(enic))
 		enic_dev_del_station_addr(enic);


