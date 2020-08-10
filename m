Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7D22408D5
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbgHJPZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:25:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728561AbgHJPZl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:25:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D42862078E;
        Mon, 10 Aug 2020 15:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073140;
        bh=Rz7iaYAsvM6wCeSLHRNbTUW22QBpt6gfuRDeVPmYiNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uzlb7AKT2/cu7jHRFmujRLKKVr4c/2jHuZVnE3Dd+QBlVewfF+w2SOwwwRQCUgtm3
         fuC49qlgaWrSgGGF0SDSMeVERY0ETwyHciybAy4nE3dGhwTba+Cn+MFP3X0N0S1BsX
         WnJpOy1PCu8xu+n5w9J3kpLe9O5X3+aoB3Depd24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Rafael P." <rparrazo@redhat.com>,
        Dean Nelson <dnelson@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 71/79] net: thunderx: use spin_lock_bh in nicvf_set_rx_mode_task()
Date:   Mon, 10 Aug 2020 17:21:30 +0200
Message-Id: <20200810151815.735215655@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit bab9693a9a8c6dd19f670408ec1e78e12a320682 ]

A dead lock was triggered on thunderx driver:

        CPU0                    CPU1
        ----                    ----
   [01] lock(&(&nic->rx_mode_wq_lock)->rlock);
                           [11] lock(&(&mc->mca_lock)->rlock);
                           [12] lock(&(&nic->rx_mode_wq_lock)->rlock);
   [02] <Interrupt> lock(&(&mc->mca_lock)->rlock);

The path for each is:

  [01] worker_thread() -> process_one_work() -> nicvf_set_rx_mode_task()
  [02] mld_ifc_timer_expire()
  [11] ipv6_add_dev() -> ipv6_dev_mc_inc() -> igmp6_group_added() ->
  [12] dev_mc_add() -> __dev_set_rx_mode() -> nicvf_set_rx_mode()

To fix it, it needs to disable bh on [1], so that the timer on [2]
wouldn't be triggered until rx_mode_wq_lock is released. So change
to use spin_lock_bh() instead of spin_lock().

Thanks to Paolo for helping with this.

v1->v2:
  - post to netdev.

Reported-by: Rafael P. <rparrazo@redhat.com>
Tested-by: Dean Nelson <dnelson@redhat.com>
Fixes: 469998c861fa ("net: thunderx: prevent concurrent data re-writing by nicvf_set_rx_mode")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cavium/thunder/nicvf_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -2041,11 +2041,11 @@ static void nicvf_set_rx_mode_task(struc
 	/* Save message data locally to prevent them from
 	 * being overwritten by next ndo_set_rx_mode call().
 	 */
-	spin_lock(&nic->rx_mode_wq_lock);
+	spin_lock_bh(&nic->rx_mode_wq_lock);
 	mode = vf_work->mode;
 	mc = vf_work->mc;
 	vf_work->mc = NULL;
-	spin_unlock(&nic->rx_mode_wq_lock);
+	spin_unlock_bh(&nic->rx_mode_wq_lock);
 
 	__nicvf_set_rx_mode_task(mode, mc, nic);
 }


