Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0032018B40B
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbgCSNGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:06:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727064AbgCSNGR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:06:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90E5A2076E;
        Thu, 19 Mar 2020 13:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623177;
        bh=tg4KSLlT4UUukes8K54LjRAKN0KEiCQaGJAx5zXBXQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t3eJonBCU2R/UVjQxd305g7Jr/5ZVQxHFg3w/gKWU9eSdCKOz82G++b1PYvj2lvsK
         TY2oXf1Ys+FbbRMg4rh8K/nJ5Z9mbVHrGk4pM4S6tPJlaBOEpmXShNdq8HL+nwtjN7
         8/5lwnj7eyZTfcUf3euuif/AMQIRHyD4mG2leJqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mahesh Bandewar <maheshb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 17/93] macvlan: add cond_resched() during multicast processing
Date:   Thu, 19 Mar 2020 13:59:21 +0100
Message-Id: <20200319123930.524401248@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123924.795019515@linuxfoundation.org>
References: <20200319123924.795019515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mahesh Bandewar <maheshb@google.com>

[ Upstream commit ce9a4186f9ac475c415ffd20348176a4ea366670 ]

The Rx bound multicast packets are deferred to a workqueue and
macvlan can also suffer from the same attack that was discovered
by Syzbot for IPvlan. This solution is not as effective as in
IPvlan. IPvlan defers all (Tx and Rx) multicast packet processing
to a workqueue while macvlan does this way only for the Rx. This
fix should address the Rx codition to certain extent.

Tx is still suseptible. Tx multicast processing happens when
.ndo_start_xmit is called, hence we cannot add cond_resched().
However, it's not that severe since the user which is generating
 / flooding will be affected the most.

Fixes: 412ca1550cbe ("macvlan: Move broadcasts into a work queue")
Signed-off-by: Mahesh Bandewar <maheshb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macvlan.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -306,6 +306,8 @@ static void macvlan_process_broadcast(st
 		rcu_read_unlock();
 
 		kfree_skb(skb);
+
+		cond_resched();
 	}
 }
 


