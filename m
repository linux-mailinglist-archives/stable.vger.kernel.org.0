Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE0937CA72
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238461AbhELQaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:30:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236722AbhELQWz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:22:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79A4761D95;
        Wed, 12 May 2021 15:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834425;
        bh=6jbx8f/0Gz8nba8YAg5+OSMl+C5x1aVC6pWPyNWnZ00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uyKdVy90qxyl89Q9ZuacjXgZcLPeqi2nqzG2hpMyCuL3UwUKvq38BOelyu8Yc2tzt
         IroP5BGMcl8K1MhKlRsLbp0QLCRGcEfODKgQ/z+fBCtnTMZ410A4zPKQNZGxqdt//Z
         g6wafCG8FTfX7Tbl4OU2O6HnAzNxs3XsO95JjOp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 538/601] sfc: ef10: fix TX queue lookup in TX event handling
Date:   Wed, 12 May 2021 16:50:15 +0200
Message-Id: <20210512144845.577539719@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

[ Upstream commit 172e269edfce34bac7c61c15551816bda4b0f140 ]

We're starting from a TXQ label, not a TXQ type, so
 efx_channel_get_tx_queue() is inappropriate.  This worked by chance,
 because labels and types currently match on EF10, but we shouldn't
 rely on that.

Fixes: 12804793b17c ("sfc: decouple TXQ type from label")
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ef10.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index da6886dcac37..4fa72b573c17 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -2928,8 +2928,7 @@ efx_ef10_handle_tx_event(struct efx_channel *channel, efx_qword_t *event)
 
 	/* Get the transmit queue */
 	tx_ev_q_label = EFX_QWORD_FIELD(*event, ESF_DZ_TX_QLABEL);
-	tx_queue = efx_channel_get_tx_queue(channel,
-					    tx_ev_q_label % EFX_MAX_TXQ_PER_CHANNEL);
+	tx_queue = channel->tx_queue + (tx_ev_q_label % EFX_MAX_TXQ_PER_CHANNEL);
 
 	if (!tx_queue->timestamping) {
 		/* Transmit completion */
-- 
2.30.2



