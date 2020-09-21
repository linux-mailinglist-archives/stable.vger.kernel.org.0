Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96650272DE6
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbgIUQnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:43:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729627AbgIUQnl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:43:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D85C2235F9;
        Mon, 21 Sep 2020 16:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706620;
        bh=wCsmuPbGbJM63pvtALvnH6DRs9jI0ld3dXBH2vdA0ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZEsOj6g+p17upxmNHox+2ZFTC0yeVWBght49Awkq6LPJXCLRnzKoeNT9QSkBYNT0X
         diwxbd0t4u0Wqs+ifSkrrVL3QnYRxIv7IO4OiwIQpprYyVWGJk8eVk1g44Ys+AZdoh
         os5oxcsHWPyNLsnbmjGOZZkzzTplAoWKwz3V0QDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 006/118] hv_netvsc: Remove "unlikely" from netvsc_select_queue
Date:   Mon, 21 Sep 2020 18:26:58 +0200
Message-Id: <20200921162036.639173063@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

commit 4d820543c54c47a2bd3c95ddbf52f83c89a219a0 upstream.

When using vf_ops->ndo_select_queue, the number of queues of VF is
usually bigger than the synthetic NIC. This condition may happen
often.
Remove "unlikely" from the comparison of ndev->real_num_tx_queues.

Fixes: b3bf5666a510 ("hv_netvsc: defer queue selection to VF")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/hyperv/netvsc_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -367,7 +367,7 @@ static u16 netvsc_select_queue(struct ne
 	}
 	rcu_read_unlock();
 
-	while (unlikely(txq >= ndev->real_num_tx_queues))
+	while (txq >= ndev->real_num_tx_queues)
 		txq -= ndev->real_num_tx_queues;
 
 	return txq;


