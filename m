Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2586419907E
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730660AbgCaJMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:12:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731784AbgCaJMS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:12:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFF5920675;
        Tue, 31 Mar 2020 09:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645938;
        bh=+SWvVj50SI0AtMxhq+kMQlX5o5yQc3CcDBwhaRxOaBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tfMeAJzxcWRa4wCP/Us69ORqmjd7exezEnU7CUuetde+vl32oSDNBbeeBPN/T1YGK
         Zu/D2JC1nUCjlE+JGohwwfvvt+OM6NxoMK48175gTFMFFnS//kw9BEX98Yl85nwJOQ
         8+sfcmUZap1Oe5AVuf4yD6oLyppESB5hQOHP0nYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 021/155] net: mvneta: Fix the case where the last poll did not process all rx
Date:   Tue, 31 Mar 2020 10:57:41 +0200
Message-Id: <20200331085420.763973822@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

[ Upstream commit 065fd83e1be2e1ba0d446a257fd86a3cc7bddb51 ]

For the case where the last mvneta_poll did not process all
RX packets, we need to xor the pp->cause_rx_tx or port->cause_rx_tx
before claculating the rx_queue.

Fixes: 2dcf75e2793c ("net: mvneta: Associate RX queues with each CPU")
Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvneta.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2804,11 +2804,10 @@ static int mvneta_poll(struct napi_struc
 	/* For the case where the last mvneta_poll did not process all
 	 * RX packets
 	 */
-	rx_queue = fls(((cause_rx_tx >> 8) & 0xff));
-
 	cause_rx_tx |= pp->neta_armada3700 ? pp->cause_rx_tx :
 		port->cause_rx_tx;
 
+	rx_queue = fls(((cause_rx_tx >> 8) & 0xff));
 	if (rx_queue) {
 		rx_queue = rx_queue - 1;
 		if (pp->bm_priv)


