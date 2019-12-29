Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94FA012C78E
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730533AbfL2Rnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:43:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:51280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730532AbfL2Rnl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:43:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 674D8206A4;
        Sun, 29 Dec 2019 17:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641420;
        bh=f6ZhVK1eiA0UrK8GlBaWaGhwXlBztdh25sCCQyIOgPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J2aDsUdvIom8cyFiGhT8zCYN+DxxRqVSNKGgeUcjCMtW/noNbgzZnS13O7dtMBetf
         ACKvqacoOp5rqATlO70nE5Oz3GIpSDrtjj6XGXp0OISnsQHkOJ4fAuRe2pyO2NigY0
         ESr8sL5CLRY7tTz4yTAzFhE5vo8IuENExxiveA7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arthur Kiyanovski <akiyano@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 021/434] net: ena: fix issues in setting interrupt moderation params in ethtool
Date:   Sun, 29 Dec 2019 18:21:14 +0100
Message-Id: <20191229172703.553315832@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

[ Upstream commit 41c53caa5a61ebc9221b71cc37f4a90549f1121d ]

Issue 1:
--------
Reproduction steps:
1. sudo ethtool -C eth0 rx-usecs 128
2. sudo ethtool -C eth0 adaptive-rx on
3. sudo ethtool -C eth0 adaptive-rx off
4. ethtool -c eth0

expected output: rx-usecs 128
actual output: rx-usecs 0

Reason for issue:
In stage 3, ethtool userspace calls first the ena_get_coalesce() handler
to get the current value of all properties, and then the ena_set_coalesce()
handler. When ena_get_coalesce() is called the adaptive interrupt
moderation is still on. There is an if in the code that returns the
rx_coalesce_usecs only if the adaptive interrupt moderation is off.
And since it is still on, rx_coalesce_usecs is not set, meaning it
stays 0.

Solution to issue:
Remove this if static interrupt moderation intervals have nothing to do
with dynamic ones.

Issue 2:
--------
Reproduction steps:
1. sudo ethtool -C eth0 adaptive-rx on
2. sudo ethtool -C eth0 rx-usecs 128
3. ethtool -c eth0

expected output: rx-usecs 128
actual output: rx-usecs 0

Reason for issue:
In stage 2, when ena_set_coalesce() is called, the handler tests if
rx adaptive interrupt moderation is on, and if it is, it returns before
getting to the part in the function that sets the rx non-adaptive
interrupt moderation interval.

Solution to issue:
Remove the return from the function when rx adaptive interrupt moderation
is on.

Also cleaned up the fixed code in ena_set_coalesce by grouping together
adaptive interrupt moderation toggling, and using && instead of nested
ifs.

Fixes: b3db86dc4b82 ("net: ena: reimplement set/get_coalesce()")
Fixes: 0eda847953d8 ("net: ena: fix retrieval of nonadaptive interrupt moderation intervals")
Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -315,10 +315,9 @@ static int ena_get_coalesce(struct net_d
 		ena_com_get_nonadaptive_moderation_interval_tx(ena_dev) *
 			ena_dev->intr_delay_resolution;
 
-	if (!ena_com_get_adaptive_moderation_enabled(ena_dev))
-		coalesce->rx_coalesce_usecs =
-			ena_com_get_nonadaptive_moderation_interval_rx(ena_dev)
-			* ena_dev->intr_delay_resolution;
+	coalesce->rx_coalesce_usecs =
+		ena_com_get_nonadaptive_moderation_interval_rx(ena_dev)
+		* ena_dev->intr_delay_resolution;
 
 	coalesce->use_adaptive_rx_coalesce =
 		ena_com_get_adaptive_moderation_enabled(ena_dev);
@@ -367,12 +366,6 @@ static int ena_set_coalesce(struct net_d
 
 	ena_update_tx_rings_intr_moderation(adapter);
 
-	if (coalesce->use_adaptive_rx_coalesce) {
-		if (!ena_com_get_adaptive_moderation_enabled(ena_dev))
-			ena_com_enable_adaptive_moderation(ena_dev);
-		return 0;
-	}
-
 	rc = ena_com_update_nonadaptive_moderation_interval_rx(ena_dev,
 							       coalesce->rx_coalesce_usecs);
 	if (rc)
@@ -380,10 +373,13 @@ static int ena_set_coalesce(struct net_d
 
 	ena_update_rx_rings_intr_moderation(adapter);
 
-	if (!coalesce->use_adaptive_rx_coalesce) {
-		if (ena_com_get_adaptive_moderation_enabled(ena_dev))
-			ena_com_disable_adaptive_moderation(ena_dev);
-	}
+	if (coalesce->use_adaptive_rx_coalesce &&
+	    !ena_com_get_adaptive_moderation_enabled(ena_dev))
+		ena_com_enable_adaptive_moderation(ena_dev);
+
+	if (!coalesce->use_adaptive_rx_coalesce &&
+	    ena_com_get_adaptive_moderation_enabled(ena_dev))
+		ena_com_disable_adaptive_moderation(ena_dev);
 
 	return 0;
 }


