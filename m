Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD1E38EF1E
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235099AbhEXP4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:56:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233948AbhEXPzR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:55:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC1E8613EC;
        Mon, 24 May 2021 15:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870901;
        bh=jOnDoxmspj9SjDmdYXhqZUq8W3p4xYiZD0ZTkhyPojU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bV1vOyxrBbgXrGDcn8Gkr/nXbbVMLSeA/GcihYPK2pBlMHncIDHDHy7Odc/ruKEFp
         HUtAcs61C5x/GW8yADeYR5IBEeOGRUMV/pEFUaARbUp0hwlQbwvNV9LwHVR9KPmTw3
         ei6Z1VXhj5+dWiE0HdVM6fmIH5bN26wZK+vGzTSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 085/104] Revert "qlcnic: Avoid potential NULL pointer dereference"
Date:   Mon, 24 May 2021 17:26:20 +0200
Message-Id: <20210524152335.665940570@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit b95b57dfe7a142bf2446548eb7f49340fd73e78b upstream.

This reverts commit 5bf7295fe34a5251b1d241b9736af4697b590670.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

This commit does not properly detect if an error happens because the
logic after this loop will not detect that there was a failed
allocation.

Cc: Aditya Pakki <pakki001@umn.edu>
Cc: David S. Miller <davem@davemloft.net>
Fixes: 5bf7295fe34a ("qlcnic: Avoid potential NULL pointer dereference")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-25-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
@@ -1047,8 +1047,6 @@ int qlcnic_do_lb_test(struct qlcnic_adap
 
 	for (i = 0; i < QLCNIC_NUM_ILB_PKT; i++) {
 		skb = netdev_alloc_skb(adapter->netdev, QLCNIC_ILB_PKT_SIZE);
-		if (!skb)
-			break;
 		qlcnic_create_loopback_buff(skb->data, adapter->mac_addr);
 		skb_put(skb, QLCNIC_ILB_PKT_SIZE);
 		adapter->ahw->diag_cnt = 0;


