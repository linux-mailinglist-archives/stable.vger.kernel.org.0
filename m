Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07131FB8D1
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732099AbgFPPxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:53:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732447AbgFPPxO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:53:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AEF021532;
        Tue, 16 Jun 2020 15:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322794;
        bh=Y30ZBQNG3mszmrEQPnFxg46/oMSsg75n3uKrSV01Gnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ThNmxeSRK5Gws0xBLOauFokFYaJ4BZcH/XV8dWHCPkWV2CQBeVgxTenaA6jchv83D
         FCx90H+qtVU67kxoBclFkzLRsz59+42JQz6XVolvnCQ4YYp/HGxdKpXD/jSaLlmclQ
         Dq/q15OTvrq5jsm0/v2+Xs/yPQQdZWZSBrftZk+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 107/161] net: mvneta: do not redirect frames during reconfiguration
Date:   Tue, 16 Jun 2020 17:34:57 +0200
Message-Id: <20200616153111.457746369@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 62a502cc91f97e3ffd312d9b42e8d01a137c63ff ]

Disable frames injection in mvneta_xdp_xmit routine during hw
re-configuration in order to avoid hardware hangs

Fixes: b0a43db9087a ("net: mvneta: add XDP_TX support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvneta.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -418,11 +418,17 @@ struct mvneta_pcpu_port {
 	u32			cause_rx_tx;
 };
 
+enum {
+	__MVNETA_DOWN,
+};
+
 struct mvneta_port {
 	u8 id;
 	struct mvneta_pcpu_port __percpu	*ports;
 	struct mvneta_pcpu_stats __percpu	*stats;
 
+	unsigned long state;
+
 	int pkt_size;
 	void __iomem *base;
 	struct mvneta_rx_queue *rxqs;
@@ -2066,6 +2072,9 @@ mvneta_xdp_xmit(struct net_device *dev,
 	int i, drops = 0;
 	u32 ret;
 
+	if (unlikely(test_bit(__MVNETA_DOWN, &pp->state)))
+		return -ENETDOWN;
+
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
 		return -EINVAL;
 
@@ -3489,12 +3498,16 @@ static void mvneta_start_dev(struct mvne
 
 	phylink_start(pp->phylink);
 	netif_tx_start_all_queues(pp->dev);
+
+	clear_bit(__MVNETA_DOWN, &pp->state);
 }
 
 static void mvneta_stop_dev(struct mvneta_port *pp)
 {
 	unsigned int cpu;
 
+	set_bit(__MVNETA_DOWN, &pp->state);
+
 	phylink_stop(pp->phylink);
 
 	if (!pp->neta_armada3700) {


