Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D761CAB91
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbgEHMos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:44:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729202AbgEHMor (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:44:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01BB62495D;
        Fri,  8 May 2020 12:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941887;
        bh=psonYFf9hU6wFvrc9mKlATNkP3WUjRmyLfDJ49xKdDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gzBNNSqI1P2mb4FbvfC22JAwqRIXj4Gmd5+WGwhF/8TxkKuEdY1blfLSC2gl2ReVi
         lWg8wskhAXyoOQOJiZHFeHYQd36kIpPrDkk7Iotf1uywFiWuimM5Vt8YjKqClrHakS
         Jhr25Sglu5CRSTQuCMGZBwzha0GBmVWsoNpwoUHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 212/312] net/mlx4_core: Fix potential corruption in counters database
Date:   Fri,  8 May 2020 14:33:23 +0200
Message-Id: <20200508123139.331825370@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

commit 6b94bab0ee8d5def6a2aac0ef6204ee6e24386b6 upstream.

The error flow in procedure handle_existing_counter() is wrong.

The procedure should exit after encountering the error, not continue
as if everything is OK.

Fixes: 68230242cdbc ('net/mlx4_core: Add port attribute when tracking counters')
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -918,11 +918,13 @@ static int handle_existing_counter(struc
 
 	spin_lock_irq(mlx4_tlock(dev));
 	r = find_res(dev, counter_index, RES_COUNTER);
-	if (!r || r->owner != slave)
+	if (!r || r->owner != slave) {
 		ret = -EINVAL;
-	counter = container_of(r, struct res_counter, com);
-	if (!counter->port)
-		counter->port = port;
+	} else {
+		counter = container_of(r, struct res_counter, com);
+		if (!counter->port)
+			counter->port = port;
+	}
 
 	spin_unlock_irq(mlx4_tlock(dev));
 	return ret;


