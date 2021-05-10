Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E62837850A
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbhEJK6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:58:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230093AbhEJKxd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:53:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FCE56191A;
        Mon, 10 May 2021 10:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643287;
        bh=ReXTlROa2dmXApoHXaLjl227NwJNlQ2btegkFhmerT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JEINZzF6bfldWE/zWKCUksX1aK10JzE5fRH9Nn5CtUJ3sDOWvREFJjkQrOrp+F/7y
         ka8kzV5JPuL4ujsiwKded0AkeF6WgMqRVKSIfXbJB+Us6h/fs9FhNcRKsqBL2clceQ
         bXtr+siF9dw83hExSHBiM7UiIgcI7Xw4vFWByNJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 254/299] sfc: farch: fix TX queue lookup in TX event handling
Date:   Mon, 10 May 2021 12:20:51 +0200
Message-Id: <20210510102013.340268177@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

commit 83b09a1807415608b387c7bc748d329fefc5617e upstream.

We're starting from a TXQ label, not a TXQ type, so
 efx_channel_get_tx_queue() is inappropriate (and could return NULL,
 leading to panics).

Fixes: 12804793b17c ("sfc: decouple TXQ type from label")
Cc: stable@vger.kernel.org
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/farch.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/sfc/farch.c
+++ b/drivers/net/ethernet/sfc/farch.c
@@ -835,14 +835,14 @@ efx_farch_handle_tx_event(struct efx_cha
 		/* Transmit completion */
 		tx_ev_desc_ptr = EFX_QWORD_FIELD(*event, FSF_AZ_TX_EV_DESC_PTR);
 		tx_ev_q_label = EFX_QWORD_FIELD(*event, FSF_AZ_TX_EV_Q_LABEL);
-		tx_queue = efx_channel_get_tx_queue(
-			channel, tx_ev_q_label % EFX_MAX_TXQ_PER_CHANNEL);
+		tx_queue = channel->tx_queue +
+				(tx_ev_q_label % EFX_MAX_TXQ_PER_CHANNEL);
 		efx_xmit_done(tx_queue, tx_ev_desc_ptr);
 	} else if (EFX_QWORD_FIELD(*event, FSF_AZ_TX_EV_WQ_FF_FULL)) {
 		/* Rewrite the FIFO write pointer */
 		tx_ev_q_label = EFX_QWORD_FIELD(*event, FSF_AZ_TX_EV_Q_LABEL);
-		tx_queue = efx_channel_get_tx_queue(
-			channel, tx_ev_q_label % EFX_MAX_TXQ_PER_CHANNEL);
+		tx_queue = channel->tx_queue +
+				(tx_ev_q_label % EFX_MAX_TXQ_PER_CHANNEL);
 
 		netif_tx_lock(efx->net_dev);
 		efx_farch_notify_tx_desc(tx_queue);


