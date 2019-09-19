Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1A5FB8722
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405479AbfISWJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:09:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405473AbfISWJl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:09:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE45421928;
        Thu, 19 Sep 2019 22:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930980;
        bh=RvzhxzUs3oaoGtjI+qyUhG9SuYuCbVBTNsG965Kl+pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bTNRNKp65I68xHopAGZKvVgRdrljB/QmxpQUeKn1rD89xmAmIWf6cB3B42OgbTWng
         byoZizUC7c5patYzMQQfWQkgO5267wM4nUxTlD/S19Dymqzkm3cI/zhL3W4FBKzJaq
         ZF7gHzTecfTMeGjeThcLmRrampGkUOxL707Ta2xU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abdul Haleem <abdhalee@linux.vnet.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 085/124] ibmvnic: Do not process reset during or after device removal
Date:   Fri, 20 Sep 2019 00:02:53 +0200
Message-Id: <20190919214822.119965729@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>

[ Upstream commit 36f1031c51a2538e5558fb44c6d6b88f98d3c0f2 ]

Currently, the ibmvnic driver will not schedule device resets
if the device is being removed, but does not check the device
state before the reset is actually processed. This leads to a race
where a reset is scheduled with a valid device state but is
processed after the driver has been removed, resulting in an oops.

Fix this by checking the device state before processing a queued
reset event.

Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Tested-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index cebd20f3128d4..fa4bb940665c2 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1983,6 +1983,10 @@ static void __ibmvnic_reset(struct work_struct *work)
 
 	rwi = get_next_rwi(adapter);
 	while (rwi) {
+		if (adapter->state == VNIC_REMOVING ||
+		    adapter->state == VNIC_REMOVED)
+			goto out;
+
 		if (adapter->force_reset_recovery) {
 			adapter->force_reset_recovery = false;
 			rc = do_hard_reset(adapter, rwi, reset_state);
@@ -2007,7 +2011,7 @@ static void __ibmvnic_reset(struct work_struct *work)
 		netdev_dbg(adapter->netdev, "Reset failed\n");
 		free_all_rwi(adapter);
 	}
-
+out:
 	adapter->resetting = false;
 	if (we_lock_rtnl)
 		rtnl_unlock();
-- 
2.20.1



