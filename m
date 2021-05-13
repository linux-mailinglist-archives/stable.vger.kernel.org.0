Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D877537FACB
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 17:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234906AbhEMPfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 11:35:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234916AbhEMPfb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 11:35:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82F61613C5;
        Thu, 13 May 2021 15:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620920062;
        bh=XPSnURxrytnJ78CN8RFRiBgauSBTIe1f7owo2PxFnkY=;
        h=Subject:To:From:Date:From;
        b=O8/TXD6c4v5uoDkxFrW8WsSfLhjoavyOvXFfFiv9Zy//I2315zfek4Qz7CfXvOf6a
         UNszXE8f92ZTZhpBuIZBpRkRm5OCfYQv8ERNlaiei1A5Ay5mdlpBfJirGWKCjw4dAd
         pYKR0smr30kZrduaCVH7Lq78rXpJ0fCcTaO8f3Gw=
Subject: patch "qlcnic: Add null check after calling netdev_alloc_skb" added to char-misc-linus
To:     tseewald@gmail.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 17:34:13 +0200
Message-ID: <1620920053604@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    qlcnic: Add null check after calling netdev_alloc_skb

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 84460f01cba382553199bc1361f69a872d5abed4 Mon Sep 17 00:00:00 2001
From: Tom Seewald <tseewald@gmail.com>
Date: Mon, 3 May 2021 13:56:52 +0200
Subject: qlcnic: Add null check after calling netdev_alloc_skb

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
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
index 985cf8cb2ec0..d8f0863b3934 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
@@ -1047,6 +1047,8 @@ int qlcnic_do_lb_test(struct qlcnic_adapter *adapter, u8 mode)
 
 	for (i = 0; i < QLCNIC_NUM_ILB_PKT; i++) {
 		skb = netdev_alloc_skb(adapter->netdev, QLCNIC_ILB_PKT_SIZE);
+		if (!skb)
+			goto error;
 		qlcnic_create_loopback_buff(skb->data, adapter->mac_addr);
 		skb_put(skb, QLCNIC_ILB_PKT_SIZE);
 		adapter->ahw->diag_cnt = 0;
@@ -1070,6 +1072,7 @@ int qlcnic_do_lb_test(struct qlcnic_adapter *adapter, u8 mode)
 			cnt++;
 	}
 	if (cnt != i) {
+error:
 		dev_err(&adapter->pdev->dev,
 			"LB Test: failed, TX[%d], RX[%d]\n", i, cnt);
 		if (mode != QLCNIC_ILB_MODE)
-- 
2.31.1


