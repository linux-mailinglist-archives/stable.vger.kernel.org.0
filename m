Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E11136446B
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241151AbhDSN1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:27:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241555AbhDSN0K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:26:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5110613F8;
        Mon, 19 Apr 2021 13:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838475;
        bh=Q9PmBSu0qKPwb4l7y24tf65jKLRG+SjuFW7S7c60LWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I6dXAcHyFjdJnDmyyzFuOKZLimFqL/cj/CY50241H+FPwQaTBGYKMt87ELECK9f+9
         M7qA1LhdHOZ55tH+2pDWRxwgJ0WfRB5z4hMMZcXS/IEhsx0n9RYeL4SJn1S0I2WDtc
         gpDJWC+jG31G15qrV3liSoEMg5GlNsVz1t7bnys8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Pan <lijunp213@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 62/73] ibmvnic: remove duplicate napi_schedule call in open function
Date:   Mon, 19 Apr 2021 15:06:53 +0200
Message-Id: <20210419130525.832654414@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130523.802169214@linuxfoundation.org>
References: <20210419130523.802169214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Pan <lijunp213@gmail.com>

commit 7c451f3ef676c805a4b77a743a01a5c21a250a73 upstream.

Remove the unnecessary napi_schedule() call in __ibmvnic_open() since
interrupt_rx() calls napi_schedule_prep/__napi_schedule during every
receive interrupt.

Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
Signed-off-by: Lijun Pan <lijunp213@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1088,11 +1088,6 @@ static int __ibmvnic_open(struct net_dev
 
 	netif_tx_start_all_queues(netdev);
 
-	if (prev_state == VNIC_CLOSED) {
-		for (i = 0; i < adapter->req_rx_queues; i++)
-			napi_schedule(&adapter->napi[i]);
-	}
-
 	adapter->state = VNIC_OPEN;
 	return rc;
 }


