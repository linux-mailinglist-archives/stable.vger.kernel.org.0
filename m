Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A844728B883
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390161AbgJLNxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:53:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731549AbgJLNrG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:47:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B676021D7F;
        Mon, 12 Oct 2020 13:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510399;
        bh=sDVmi4QymjyKKOUibsw5V7hvYNGAgBABqBFagZtpbNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wnAIlPBdYWzlpHSlIX2OBfuCn+owVKDHmF7DYeXAxjOji4Dxt5hDONoJrdx9qYkAV
         CErYdSvFAzYesWd0dXu0iYzfjzyKUhVMd3dhVDeTAIz02A4KZAAAijgW0L9LymDz14
         3S/VUAMYESSRSIwNMaUT+amTTIgb0OgeztzVZ/AY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hariprasad Kelam <hkelam@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 081/124] octeontx2-pf: Fix the device state on error
Date:   Mon, 12 Oct 2020 15:31:25 +0200
Message-Id: <20201012133150.781562055@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 1ea0166da0509e987caa42c30a6a71f2c6ca1875 ]

Currently in otx2_open on failure of nix_lf_start
transmit queues are not stopped which are already
started in link_event. Since the tx queues are not
stopped network stack still try's to send the packets
leading to driver crash while access the device resources.

Fixes: 50fe6c02e ("octeontx2-pf: Register and handle link notifications")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 75a8c407e815c..5d620a39ea802 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1560,10 +1560,13 @@ int otx2_open(struct net_device *netdev)
 
 	err = otx2_rxtx_enable(pf, true);
 	if (err)
-		goto err_free_cints;
+		goto err_tx_stop_queues;
 
 	return 0;
 
+err_tx_stop_queues:
+	netif_tx_stop_all_queues(netdev);
+	netif_carrier_off(netdev);
 err_free_cints:
 	otx2_free_cints(pf, qidx);
 	vec = pci_irq_vector(pf->pdev,
-- 
2.25.1



