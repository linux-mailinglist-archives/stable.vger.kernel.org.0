Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B07D13714BD
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 14:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233749AbhECMAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 08:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233697AbhECMAZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 08:00:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E63F6127A;
        Mon,  3 May 2021 11:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620043172;
        bh=eH2TP2b7Fa5KFE8RWMtappvPyTif86uUFcSpFEef3n0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lyqNsXSNPgSZNwV/xhO37wFa9LIZ661hvmrb9hRiiMJY11yNWyxcSUlKBpx3ATYwL
         UXLSYz55BX8zZzdSzy5avgcMJ7IUbBKDuf2DBjcq42g2i5w9E+GN3KajoFsNgg5yUz
         TBKQKWwvkoBOqniNMypQ8DjziCVEhj+yHYYwKz98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Tom Seewald <tseewald@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 25/69] qlcnic: Add null check after calling netdev_alloc_skb
Date:   Mon,  3 May 2021 13:56:52 +0200
Message-Id: <20210503115736.2104747-26-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Seewald <tseewald@gmail.com>

The function qlcnic_dl_lb_test() currently calls netdev_alloc_skb()
without checking afterwards that the allocation succeeded. Fix this by
checking if the skb is NULL and returning an error in such a case.
Breaking out of the loop if the skb is NULL is not correct as no error
would be reported to the caller and no message would be printed for the
user.

Cc: David S. Miller <davem@davemloft.net>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Tom Seewald <tseewald@gmail.com>
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

