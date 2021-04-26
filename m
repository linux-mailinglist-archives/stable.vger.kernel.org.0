Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC5F36AE1A
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbhDZHll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:41:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233567AbhDZHjp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:39:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C96961152;
        Mon, 26 Apr 2021 07:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422682;
        bh=YlWBcBgIfiPCKrYK/0SepKj02YGc7U2b3kT2ZXTNTlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XsXiuEVxQ8SrAQ5InY3LMAYLUv0VMo3PHVbHnPeQ/D1ReMQYC3MkjrJUcyxCe74Gp
         L88K9laQ9Y8DbN18sxh8s3Gm/oJcQAu5enTPq82HjjK8lizJ2H7ogF6wCyKDy3/hRV
         W0s87obgcs7Uwaues0jrQS8AmKst5mjuAMko9pRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Pan <lijunp213@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 38/57] ibmvnic: remove duplicate napi_schedule call in do_reset function
Date:   Mon, 26 Apr 2021 09:29:35 +0200
Message-Id: <20210426072821.861100755@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072820.568997499@linuxfoundation.org>
References: <20210426072820.568997499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Pan <lijunp213@gmail.com>

commit d3a6abccbd272aea7dc2c6f984bb5a2c11278e44 upstream.

During adapter reset, do_reset/do_hard_reset calls ibmvnic_open(),
which will calls napi_schedule if previous state is VNIC_CLOSED
(i.e, the reset case, and "ifconfig down" case). So there is no need
for do_reset to call napi_schedule again at the end of the function
though napi_schedule will neglect the request if napi is already
scheduled.

Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
Signed-off-by: Lijun Pan <lijunp213@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1760,7 +1760,7 @@ static int do_reset(struct ibmvnic_adapt
 	u64 old_num_rx_queues, old_num_tx_queues;
 	u64 old_num_rx_slots, old_num_tx_slots;
 	struct net_device *netdev = adapter->netdev;
-	int i, rc;
+	int rc;
 
 	netdev_dbg(adapter->netdev, "Re-setting driver (%d)\n",
 		   rwi->reset_reason);
@@ -1878,10 +1878,6 @@ static int do_reset(struct ibmvnic_adapt
 	/* refresh device's multicast list */
 	ibmvnic_set_multi(netdev);
 
-	/* kick napi */
-	for (i = 0; i < adapter->req_rx_queues; i++)
-		napi_schedule(&adapter->napi[i]);
-
 	if (adapter->reset_reason != VNIC_RESET_FAILOVER &&
 	    adapter->reset_reason != VNIC_RESET_CHANGE_PARAM) {
 		call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);


