Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E2523A68D
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgHCMYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:24:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727959AbgHCMYT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:24:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8AC5204EC;
        Mon,  3 Aug 2020 12:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457458;
        bh=tnA5metbErLAKcEHgtuI0o1BmjiXJ/B/RWf3dyXgMOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kAuGxLGbA1OPdNpeJfHmut7QMU6KFlFeOoNIAfa6+6VGMobrh2ebpbiiFMMk+FoNK
         OhFTxZqvE9j7aU8JP/fb+JqmpZq3cfeOnjdtJMszPkhYGgzGDZYu0wwxfgrjqhUHER
         NCs8wGGuM9CQMs+UoCZdR2BeY8D7gUTLO78jk/yU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Falcon <tlfalcon@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 075/120] ibmvnic: Fix IRQ mapping disposal in error path
Date:   Mon,  3 Aug 2020 14:18:53 +0200
Message-Id: <20200803121906.464775237@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>

[ Upstream commit 27a2145d6f826d1fad9de06ac541b1016ced3427 ]

RX queue IRQ mappings are disposed in both the TX IRQ and RX IRQ
error paths. Fix this and dispose of TX IRQ mappings correctly in
case of an error.

Fixes: ea22d51a7831 ("ibmvnic: simplify and improve driver probe function")
Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 0fd7eae25fe9d..5afb3c9c52d20 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3206,7 +3206,7 @@ req_rx_irq_failed:
 req_tx_irq_failed:
 	for (j = 0; j < i; j++) {
 		free_irq(adapter->tx_scrq[j]->irq, adapter->tx_scrq[j]);
-		irq_dispose_mapping(adapter->rx_scrq[j]->irq);
+		irq_dispose_mapping(adapter->tx_scrq[j]->irq);
 	}
 	release_sub_crqs(adapter, 1);
 	return rc;
-- 
2.25.1



