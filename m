Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9648033B670
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbhCON5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231207AbhCON5T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D242264EF0;
        Mon, 15 Mar 2021 13:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816639;
        bh=kQUkM0FiOwOORrfwDF8PLigJXM3f6iK6it+5VrLkPAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=05ih5YIqMeMpQ2zV3eXq5t0lMWUFEZluCA6p7MhPuJoxtL0PgHk+hUnU9WQUzFknl
         hVNO2ZC+bL/XOkt7ZtjB4bPBMMBoaHubKVaEOiQ5Wihl80Pn8TzmjB6Vs+iG+uufnf
         uBMdJE10uO8oZSkH9t8CPPchM7gyzoT0ik79sGDI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Suchanek <msuchanek@suse.de>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 027/290] ibmvnic: Fix possibly uninitialized old_num_tx_queues variable warning.
Date:   Mon, 15 Mar 2021 14:52:00 +0100
Message-Id: <20210315135542.847424658@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Michal Suchanek <msuchanek@suse.de>

commit 6881b07fdd24850def1f03761c66042b983ff86e upstream.

GCC 7.5 reports:
../drivers/net/ethernet/ibm/ibmvnic.c: In function 'ibmvnic_reset_init':
../drivers/net/ethernet/ibm/ibmvnic.c:5373:51: warning: 'old_num_tx_queues' may be used uninitialized in this function [-Wmaybe-uninitialized]
../drivers/net/ethernet/ibm/ibmvnic.c:5373:6: warning: 'old_num_rx_queues' may be used uninitialized in this function [-Wmaybe-uninitialized]

The variable is initialized only if(reset) and used only if(reset &&
something) so this is a false positive. However, there is no reason to
not initialize the variables unconditionally avoiding the warning.

Fixes: 635e442f4a48 ("ibmvnic: merge ibmvnic_reset_init and ibmvnic_init")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Reviewed-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5176,16 +5176,14 @@ static int ibmvnic_reset_init(struct ibm
 {
 	struct device *dev = &adapter->vdev->dev;
 	unsigned long timeout = msecs_to_jiffies(20000);
-	u64 old_num_rx_queues, old_num_tx_queues;
+	u64 old_num_rx_queues = adapter->req_rx_queues;
+	u64 old_num_tx_queues = adapter->req_tx_queues;
 	int rc;
 
 	adapter->from_passive_init = false;
 
-	if (reset) {
-		old_num_rx_queues = adapter->req_rx_queues;
-		old_num_tx_queues = adapter->req_tx_queues;
+	if (reset)
 		reinit_completion(&adapter->init_done);
-	}
 
 	adapter->init_done_rc = 0;
 	rc = ibmvnic_send_crq_init(adapter);


