Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC794472560
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhLMJne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:43:34 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:34862 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235135AbhLMJkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:40:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E5924CE0E7C;
        Mon, 13 Dec 2021 09:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17CAC341C8;
        Mon, 13 Dec 2021 09:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388411;
        bh=AlUzJO9r50jKXcylDD9mcBhb/7FjCneZWkuEMinbNSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NTduYhNuP4aWNj50srBE66kZTsLJS+nFc5rB6An1GZFKEI6YELahHtT4YSpf3OsTZ
         WkGsKvuTfRzXrTExoW9QB1p6ywId4DeVV/mHuGDmSUx7i02I+4wnNQE3V+1E5qiNpn
         nflXxDTy1lvNSRIl8suPZ4BfhqX1shlnAfFHOv54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Chopra <manishc@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 41/74] qede: validate non LSO skb length
Date:   Mon, 13 Dec 2021 10:30:12 +0100
Message-Id: <20211213092932.193956427@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
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
@@ -1606,6 +1606,13 @@ netdev_tx_t qede_start_xmit(struct sk_bu
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


