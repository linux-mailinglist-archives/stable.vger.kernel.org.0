Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4062E145665
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730964AbgAVN0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:26:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:47414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729163AbgAVN0e (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:26:34 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DBDC2467B;
        Wed, 22 Jan 2020 13:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699594;
        bh=9F+EXNeal2W7NUa/tq+TFrW6djEOpUYwVzyxkLEmiAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JOJs8BX8PMqyVtdGyoJ6KEAfwTMGUXOQl1CY2yJG1LxAQb+63/WqytaHpn5Mjtu+G
         HFZnnsFDmwbkp+hS9npSJ74pQ/USXM6vQy2tT4DXISFHpVdHVtIR3uElD+kjV9rUfe
         6Pvo5s/HpQFyQpYi4JtYex/E1zqQhVRITFcY9/rk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 153/222] net: systemport: Fixed queue mapping in internal ring map
Date:   Wed, 22 Jan 2020 10:28:59 +0100
Message-Id: <20200122092844.677212804@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 5a9ef19454cd5daec8041bc7c3c11deb7456d9a0 ]

We would not be transmitting using the correct SYSTEMPORT transmit queue
during ndo_select_queue() which looks up the internal TX ring map
because while establishing the mapping we would be off by 4, so for
instance, when we populate switch port mappings we would be doing:

switch port 0, queue 0 -> ring index #0
switch port 0, queue 1 -> ring index #1
...
switch port 0, queue 3 -> ring index #3
switch port 1, queue 0 -> ring index #8 (4 + 4 * 1)
...

instead of using ring index #4. This would cause our ndo_select_queue()
to use the fallback queue mechanism which would pick up an incorrect
ring for that switch port. Fix this by using the correct switch queue
number instead of SYSTEMPORT queue number.

Fixes: 25c440704661 ("net: systemport: Simplify queue mapping logic")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2323,7 +2323,7 @@ static int bcm_sysport_map_queues(struct
 		ring->switch_queue = qp;
 		ring->switch_port = port;
 		ring->inspect = true;
-		priv->ring_map[q + port * num_tx_queues] = ring;
+		priv->ring_map[qp + port * num_tx_queues] = ring;
 		qp++;
 	}
 
@@ -2338,7 +2338,7 @@ static int bcm_sysport_unmap_queues(stru
 	struct net_device *slave_dev;
 	unsigned int num_tx_queues;
 	struct net_device *dev;
-	unsigned int q, port;
+	unsigned int q, qp, port;
 
 	priv = container_of(nb, struct bcm_sysport_priv, dsa_notifier);
 	if (priv->netdev != info->master)
@@ -2364,7 +2364,8 @@ static int bcm_sysport_unmap_queues(stru
 			continue;
 
 		ring->inspect = false;
-		priv->ring_map[q + port * num_tx_queues] = NULL;
+		qp = ring->switch_queue;
+		priv->ring_map[qp + port * num_tx_queues] = NULL;
 	}
 
 	return 0;


