Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A68F86A3D
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404250AbfHHTHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:07:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404681AbfHHTHc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:07:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BEA5214C6;
        Thu,  8 Aug 2019 19:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291251;
        bh=UPWNm89fVyI/H2Z+QI/QaH6Ahsgr7FbuohmiZ8pZtX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CBFWKLUfNyS/Tqcu8uIAtZ5aq4BGkYfpAVCx/Ke6RL4QSPqiFXh90x9riK92qRI+O
         V0vl4ToZhwyWQqP+PcjiiawV7ueji9n3Vq2PyafSdMuwYm1DATSuptBKJnzNuZh46r
         3Mr5i6okaPDPTIxIiVR7sQchwckHtp9/morfPJD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 09/56] bnx2x: Disable multi-cos feature.
Date:   Thu,  8 Aug 2019 21:04:35 +0200
Message-Id: <20190808190453.239926499@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
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
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -1934,8 +1934,7 @@ u16 bnx2x_select_queue(struct net_device
 	}
 
 	/* select a non-FCoE queue */
-	return netdev_pick_tx(dev, skb, NULL) %
-	       (BNX2X_NUM_ETH_QUEUES(bp) * bp->max_cos);
+	return netdev_pick_tx(dev, skb, NULL) % (BNX2X_NUM_ETH_QUEUES(bp));
 }
 
 void bnx2x_set_num_queues(struct bnx2x *bp)


