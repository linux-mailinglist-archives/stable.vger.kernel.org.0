Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF28328F7B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241792AbhCATwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:52:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:55154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242158AbhCAToA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:44:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C35D164F82;
        Mon,  1 Mar 2021 17:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618514;
        bh=8S6MAqoxU/zLtKh55N2UPFazpdKXsWMUE6is00r90cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wavHcf+MtNekOVbBWwzLmplb8HTWbyNOKnfChf/0sr8Y9BotsZE5oE98rSdF1omQG
         mluBTr+/gtTEk6JronkD4eqB5zOt1F3gaHO9cSJ8dDuHD0ckrrblijUAntiJ0lKfgm
         OpFV4OOAXUG+u3AhjP8p6Dshb0O/lZOJrs60TDvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Abdul Haleem <abdhalee@in.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/663] ibmvnic: Set to CLOSED state even on error
Date:   Mon,  1 Mar 2021 17:05:45 +0100
Message-Id: <20210301161146.531139506@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

[ Upstream commit d4083d3c00f60a09ad82e3bf17ff57fec69c8aa6 ]

If set_link_state() fails for any reason, we still cleanup the adapter
state and cannot recover from a partial close anyway. So set the adapter
to CLOSED state. That way if a new soft/hard reset is processed, the
adapter will remain in the CLOSED state until the next ibmvnic_open().

Fixes: 01d9bd792d16 ("ibmvnic: Reorganize device close")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Reported-by: Abdul Haleem <abdhalee@in.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index ee16e0e4fa5fc..d789c3cb7f87b 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1329,10 +1329,8 @@ static int __ibmvnic_close(struct net_device *netdev)
 
 	adapter->state = VNIC_CLOSING;
 	rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_DN);
-	if (rc)
-		return rc;
 	adapter->state = VNIC_CLOSED;
-	return 0;
+	return rc;
 }
 
 static int ibmvnic_close(struct net_device *netdev)
-- 
2.27.0



