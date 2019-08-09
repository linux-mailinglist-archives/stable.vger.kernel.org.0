Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD97F87BCF
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407242AbfHINrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:47:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407237AbfHINrV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:47:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F34D2171F;
        Fri,  9 Aug 2019 13:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358440;
        bh=VsUmP/kU2gDB6qlR1FWH3MP5F0sOQc0IFcrb/hQNgU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LokyGOdBlVwobPZisTG0WCj4twPl5xKTAYlgX/wpR8eAGtmCPjI2UGesAaCx62jSO
         PuY/PjrTKdMcoji8FhSQFC39medLpAFPfL7HyX9rTCPIyg8Ry1YDzeqkEWooKfMDee
         6LasTEPOyLtRyjFnpyIHGojiLLqpU/DvgGYu7GUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 25/32] bnx2x: Disable multi-cos feature.
Date:   Fri,  9 Aug 2019 15:45:28 +0200
Message-Id: <20190809133923.742613826@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809133922.945349906@linuxfoundation.org>
References: <20190809133922.945349906@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>

[ Upstream commit d1f0b5dce8fda09a7f5f04c1878f181d548e42f5 ]

Commit 3968d38917eb ("bnx2x: Fix Multi-Cos.") which enabled multi-cos
feature after prolonged time in driver added some regression causing
numerous issues (sudden reboots, tx timeout etc.) reported by customers.
We plan to backout this commit and submit proper fix once we have root
cause of issues reported with this feature enabled.

Fixes: 3968d38917eb ("bnx2x: Fix Multi-Cos.")
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -1939,7 +1939,7 @@ u16 bnx2x_select_queue(struct net_device
 	}
 
 	/* select a non-FCoE queue */
-	return fallback(dev, skb) % (BNX2X_NUM_ETH_QUEUES(bp) * bp->max_cos);
+	return fallback(dev, skb) % (BNX2X_NUM_ETH_QUEUES(bp));
 }
 
 void bnx2x_set_num_queues(struct bnx2x *bp)


