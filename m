Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C110638EE3F
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234484AbhEXPrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:47:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234631AbhEXPo1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:44:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4150D61452;
        Mon, 24 May 2021 15:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870564;
        bh=spKPCrO0sL/Gh3g1hk1TvU51aq5+aqlImPb+KmLLB0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SjWPflEtIHCbNcU4V44kQAdXKLRzxt697qeKFJlY9VAXvqzkCRzmVO2IcSmr338ox
         nMArdJHHcO7FhBljzY8kCTlFPgRPDwUqmu14LpSMwaOZVjSd3GuFiLeAqioNwtckhB
         YUat59bikoW7h5JgzUMDyPPPwH5/td4FEjDOO4NM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Tom Seewald <tseewald@gmail.com>
Subject: [PATCH 4.19 44/49] qlcnic: Add null check after calling netdev_alloc_skb
Date:   Mon, 24 May 2021 17:25:55 +0200
Message-Id: <20210524152325.791989205@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152324.382084875@linuxfoundation.org>
References: <20210524152324.382084875@linuxfoundation.org>
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
@@ -1048,6 +1048,8 @@ int qlcnic_do_lb_test(struct qlcnic_adap
 
 	for (i = 0; i < QLCNIC_NUM_ILB_PKT; i++) {
 		skb = netdev_alloc_skb(adapter->netdev, QLCNIC_ILB_PKT_SIZE);
+		if (!skb)
+			goto error;
 		qlcnic_create_loopback_buff(skb->data, adapter->mac_addr);
 		skb_put(skb, QLCNIC_ILB_PKT_SIZE);
 		adapter->ahw->diag_cnt = 0;
@@ -1071,6 +1073,7 @@ int qlcnic_do_lb_test(struct qlcnic_adap
 			cnt++;
 	}
 	if (cnt != i) {
+error:
 		dev_err(&adapter->pdev->dev,
 			"LB Test: failed, TX[%d], RX[%d]\n", i, cnt);
 		if (mode != QLCNIC_ILB_MODE)


