Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF7E378703
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbhEJLMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235837AbhEJLGR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:06:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D30CD61492;
        Mon, 10 May 2021 10:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644191;
        bh=tP1U7H4312HGX/MWFARpFwLuhVw15lE1SvLcNcr+1OQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m8QB/Oj/tJVnNcK2dFrR3W9qZsEmVAWgQzhqY5yidoFHjCfDGCvlttjK2JWY5K4J9
         ZFuyZDvRRrXDXzVPMlSsp4ou3gRN/bXCTin6fDmEBvCG8OnVs0OeHLqBTtEXglloFc
         dqDK1q8AmEgr3SY3NX7BQwZvf9cW1GIObDKnZtSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Trevor Hemsley <themsley@voiceflex.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 290/342] sfc: farch: fix TX queue lookup in TX flush done handling
Date:   Mon, 10 May 2021 12:21:20 +0200
Message-Id: <20210510102019.696821592@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

commit 5b1faa92289b53cad654123ed2bc8e10f6ddd4ac upstream.

We're starting from a TXQ instance number ('qid'), not a TXQ type, so
 efx_get_tx_queue() is inappropriate (and could return NULL, leading
 to panics).

Fixes: 12804793b17c ("sfc: decouple TXQ type from label")
Reported-by: Trevor Hemsley <themsley@voiceflex.com>
Cc: stable@vger.kernel.org
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/farch.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/sfc/farch.c
+++ b/drivers/net/ethernet/sfc/farch.c
@@ -1081,16 +1081,16 @@ static void
 efx_farch_handle_tx_flush_done(struct efx_nic *efx, efx_qword_t *event)
 {
 	struct efx_tx_queue *tx_queue;
+	struct efx_channel *channel;
 	int qid;
 
 	qid = EFX_QWORD_FIELD(*event, FSF_AZ_DRIVER_EV_SUBDATA);
 	if (qid < EFX_MAX_TXQ_PER_CHANNEL * (efx->n_tx_channels + efx->n_extra_tx_channels)) {
-		tx_queue = efx_get_tx_queue(efx, qid / EFX_MAX_TXQ_PER_CHANNEL,
-					    qid % EFX_MAX_TXQ_PER_CHANNEL);
-		if (atomic_cmpxchg(&tx_queue->flush_outstanding, 1, 0)) {
+		channel = efx_get_tx_channel(efx, qid / EFX_MAX_TXQ_PER_CHANNEL);
+		tx_queue = channel->tx_queue + (qid % EFX_MAX_TXQ_PER_CHANNEL);
+		if (atomic_cmpxchg(&tx_queue->flush_outstanding, 1, 0))
 			efx_farch_magic_event(tx_queue->channel,
 					      EFX_CHANNEL_MAGIC_TX_DRAIN(tx_queue));
-		}
 	}
 }
 


