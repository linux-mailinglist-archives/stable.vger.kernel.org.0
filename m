Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F302F139A
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731448AbhAKNLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:11:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:58908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731443AbhAKNLn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:11:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C34A22515;
        Mon, 11 Jan 2021 13:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370662;
        bh=uDKpZ9/xQLMGaaTQY81UYFTxD6iHtYVej1suSNWkwNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hp3s15Tx3+VAhu4UnZqLTKYKD2zI319zhF6Qvjk8amwo/mPAm6LdT5yrk6hoBlR16
         JjRZkEjNy4kUMhEnIOUwSsXUr+UHmy8grb15xTz9pahqd9rlHuOVzVh90Pv3LiJeVK
         j0+ijIB2OVm/lYI1inwRk53n5aSqwXwLtRiUvJCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 44/92] ionic: account for vlan tag len in rx buffer len
Date:   Mon, 11 Jan 2021 14:01:48 +0100
Message-Id: <20210111130041.268227610@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit 83469893204281ecf65d572bddf02de29a19787c ]

Let the FW know we have enough receive buffer space for the
vlan tag if it isn't stripped.

Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Link: https://lore.kernel.org/r/20201218215001.64696-1-snelson@pensando.io
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -257,7 +257,7 @@ void ionic_rx_fill(struct ionic_queue *q
 	unsigned int len;
 	unsigned int i;
 
-	len = netdev->mtu + ETH_HLEN;
+	len = netdev->mtu + ETH_HLEN + VLAN_HLEN;
 
 	for (i = ionic_q_space_avail(q); i; i--) {
 		skb = ionic_rx_skb_alloc(q, len, &dma_addr);


