Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B154638EF51
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234308AbhEXP4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:56:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234223AbhEXP4D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:56:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FBCB61444;
        Mon, 24 May 2021 15:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870950;
        bh=QZ30t+MKU3DCIDBaL96ONqEHSTHbyu3sKGvIJPTmEHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sjy9FeZ08+BF2NsP6b/cSW7K1nmhBkRbTn8AHsvBPUq2idHvoARMYrG/SVG7mIEI3
         q2is6Ez8IKcikN7jWunehh0KF1Xpfqs4CZrjs/r4i1PQeYvUlhmdkPRp2hvuQ7bbqE
         VGmGb+uMSyzUmpIaireLfANzIFdzyCDOTGYx4a7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Tom Seewald <tseewald@gmail.com>
Subject: [PATCH 5.10 093/104] qlcnic: Add null check after calling netdev_alloc_skb
Date:   Mon, 24 May 2021 17:26:28 +0200
Message-Id: <20210524152335.930940415@linuxfoundation.org>
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

From: Tom Seewald <tseewald@gmail.com>

commit 84460f01cba382553199bc1361f69a872d5abed4 upstream.

The function qlcnic_dl_lb_test() currently calls netdev_alloc_skb()
without checking afterwards that the allocation succeeded. Fix this by
checking if the skb is NULL and returning an error in such a case.
Breaking out of the loop if the skb is NULL is not correct as no error
would be reported to the caller and no message would be printed for the
user.

Cc: David S. Miller <davem@davemloft.net>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Tom Seewald <tseewald@gmail.com>
Link: https://lore.kernel.org/r/20210503115736.2104747-26-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
@@ -1047,6 +1047,8 @@ int qlcnic_do_lb_test(struct qlcnic_adap
 
 	for (i = 0; i < QLCNIC_NUM_ILB_PKT; i++) {
 		skb = netdev_alloc_skb(adapter->netdev, QLCNIC_ILB_PKT_SIZE);
+		if (!skb)
+			goto error;
 		qlcnic_create_loopback_buff(skb->data, adapter->mac_addr);
 		skb_put(skb, QLCNIC_ILB_PKT_SIZE);
 		adapter->ahw->diag_cnt = 0;
@@ -1070,6 +1072,7 @@ int qlcnic_do_lb_test(struct qlcnic_adap
 			cnt++;
 	}
 	if (cnt != i) {
+error:
 		dev_err(&adapter->pdev->dev,
 			"LB Test: failed, TX[%d], RX[%d]\n", i, cnt);
 		if (mode != QLCNIC_ILB_MODE)


