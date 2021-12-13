Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF8F47289D
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236343AbhLMKOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:14:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44358 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239771AbhLMJ5y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:57:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 443D5B80E7A;
        Mon, 13 Dec 2021 09:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A18C34602;
        Mon, 13 Dec 2021 09:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389472;
        bh=anaYCRf9rJ3zXGTVKfWIsIw4C9o8BeinwzDfcQpXx/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HNi1N29soTgrhCEbRUOtOvvpx8+TUnWSLpWoh5F6MdWWo+y3LDsvNDvPBB/r89/Up
         wXJo9AGx8f6GqYK57j3i16ZEVsXh18vpf3ek8d8mo4Qz4ruFSZ4olYLs5MoGYkglAm
         CQ8DsHkpt2ULVBtat0urZB7LBa6xCWVAdphmcLjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Chopra <manishc@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 106/171] qede: validate non LSO skb length
Date:   Mon, 13 Dec 2021 10:30:21 +0100
Message-Id: <20211213092948.619729882@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manish Chopra <manishc@marvell.com>

commit 8e227b198a55859bf790dc7f4b1e30c0859c6756 upstream.

Although it is unlikely that stack could transmit a non LSO
skb with length > MTU, however in some cases or environment such
occurrences actually resulted into firmware asserts due to packet
length being greater than the max supported by the device (~9700B).

This patch adds the safeguard for such odd cases to avoid firmware
asserts.

v2: Added "Fixes" tag with one of the initial driver commit
    which enabled the TX traffic actually (as this was probably
    day1 issue which was discovered recently by some customer
    environment)

Fixes: a2ec6172d29c ("qede: Add support for link")
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Alok Prasad <palok@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Link: https://lore.kernel.org/r/20211203174413.13090-1-manishc@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qede/qede_fp.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1643,6 +1643,13 @@ netdev_tx_t qede_start_xmit(struct sk_bu
 			data_split = true;
 		}
 	} else {
+		if (unlikely(skb->len > ETH_TX_MAX_NON_LSO_PKT_LEN)) {
+			DP_ERR(edev, "Unexpected non LSO skb length = 0x%x\n", skb->len);
+			qede_free_failed_tx_pkt(txq, first_bd, 0, false);
+			qede_update_tx_producer(txq);
+			return NETDEV_TX_OK;
+		}
+
 		val |= ((skb->len & ETH_TX_DATA_1ST_BD_PKT_LEN_MASK) <<
 			 ETH_TX_DATA_1ST_BD_PKT_LEN_SHIFT);
 	}


