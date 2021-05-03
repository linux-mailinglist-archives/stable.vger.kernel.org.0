Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273B23714B9
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 14:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbhECMA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 08:00:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233590AbhECMAW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 08:00:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDC9561185;
        Mon,  3 May 2021 11:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620043169;
        bh=A8MdzO5tJoC/I0YqqZ1NCiDzDifexm4ATd4RR1/f6lU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TlWPNygnSMtj68bZ5gkKmk1jZor5RCwFk89i5JtlQwq4wRim6CTGW6Gl0tAg/fRGo
         Iyh0dpVfykgk0AYHNQfb4GUbVUMcNAyuJuQtAGoc1pmFiUjGSXlQfjpPC/iMgTs4uJ
         vV/Yfg9L7W3AKJzRaCvNf685+pIwxZem9MyNwyeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aditya Pakki <pakki001@umn.edu>,
        "David S . Miller" <davem@davemloft.net>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 24/69] Revert "qlcnic: Avoid potential NULL pointer dereference"
Date:   Mon,  3 May 2021 13:56:51 +0200
Message-Id: <20210503115736.2104747-25-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
index d8a3ecaed3fc..985cf8cb2ec0 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
@@ -1047,8 +1047,6 @@ int qlcnic_do_lb_test(struct qlcnic_adapter *adapter, u8 mode)
 
 	for (i = 0; i < QLCNIC_NUM_ILB_PKT; i++) {
 		skb = netdev_alloc_skb(adapter->netdev, QLCNIC_ILB_PKT_SIZE);
-		if (!skb)
-			break;
 		qlcnic_create_loopback_buff(skb->data, adapter->mac_addr);
 		skb_put(skb, QLCNIC_ILB_PKT_SIZE);
 		adapter->ahw->diag_cnt = 0;
-- 
2.31.1

