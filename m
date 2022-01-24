Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAED499DB8
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1586126AbiAXWZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584644AbiAXWVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:21:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE896C0424FC;
        Mon, 24 Jan 2022 12:52:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6013B80CCF;
        Mon, 24 Jan 2022 20:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47EDC340E5;
        Mon, 24 Jan 2022 20:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057559;
        bh=cGkIIs7Swic0pBA9MwyHbRPpUVHZFwFdQXV7Danwej8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vRNKmVtXr6ufMLI92Qeeul+igG9+BHRTyqkMNRwVilVZXfGEPKXxYP8Nt7+CYsmJ/
         4iASBgoBDZ3HckdPWwDNzNgcihrUXf6xZoStAJN/quOCpN/h2pkpxspEo3nGoDwyKg
         mO79aYFmBi1eWInt7+4btba5dcR95+OLTcoxYXjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shujun Wang <wsj20369@163.com>,
        Slark Xiao <slark_xiao@163.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 831/846] net: wwan: Fix MRU mismatch issue which may lead to data connection lost
Date:   Mon, 24 Jan 2022 19:45:48 +0100
Message-Id: <20220124184129.575715171@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Slark Xiao <slark_xiao@163.com>

commit f542cdfa3083a309e3caafbbdf41490c4935492a upstream.

In pci_generic.c there is a 'mru_default' in struct mhi_pci_dev_info.
This value shall be used for whole mhi if it's given a value for a specific product.
But in function mhi_net_rx_refill_work(), it's still using hard code value MHI_DEFAULT_MRU.
'mru_default' shall have higher priority than MHI_DEFAULT_MRU.
And after checking, this change could help fix a data connection lost issue.

Fixes: 5c2c85315948 ("bus: mhi: pci-generic: configurable network interface MRU")
Signed-off-by: Shujun Wang <wsj20369@163.com>
Signed-off-by: Slark Xiao <slark_xiao@163.com>
Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wwan/mhi_wwan_mbim.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wwan/mhi_wwan_mbim.c b/drivers/net/wwan/mhi_wwan_mbim.c
index 71bf9b4f769f..6872782e8dd8 100644
--- a/drivers/net/wwan/mhi_wwan_mbim.c
+++ b/drivers/net/wwan/mhi_wwan_mbim.c
@@ -385,13 +385,13 @@ static void mhi_net_rx_refill_work(struct work_struct *work)
 	int err;
 
 	while (!mhi_queue_is_full(mdev, DMA_FROM_DEVICE)) {
-		struct sk_buff *skb = alloc_skb(MHI_DEFAULT_MRU, GFP_KERNEL);
+		struct sk_buff *skb = alloc_skb(mbim->mru, GFP_KERNEL);
 
 		if (unlikely(!skb))
 			break;
 
 		err = mhi_queue_skb(mdev, DMA_FROM_DEVICE, skb,
-				    MHI_DEFAULT_MRU, MHI_EOT);
+				    mbim->mru, MHI_EOT);
 		if (unlikely(err)) {
 			kfree_skb(skb);
 			break;
-- 
2.34.1



