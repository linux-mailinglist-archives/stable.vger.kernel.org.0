Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8EEC3A93B
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388717AbfFIREw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:04:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388708AbfFIREv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:04:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC217204EC;
        Sun,  9 Jun 2019 17:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099890;
        bh=GjVXWI5uFsHjJy1lIN7cw1Uy7BYptXLdzYnGD3AQQQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CqCpeHBHCFnFMCvjHyxKJ4b7HHDtYdfZ4HyQDq3Hab+iS3om8mhvBdpy8nWTrgjCr
         db/LYhCSWNCnNDeI/n3i305dzPct7AbqYhSAacBXqJO56+y3aD7sXNoAkkboCWLfXz
         CCT1/+scG3WwWareL7BgGwF+mSdVtVz7c0dsMaJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rakesh Hemnani <rhemnani@fb.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 186/241] bnxt_en: Fix aggregation buffer leak under OOM condition.
Date:   Sun,  9 Jun 2019 18:42:08 +0200
Message-Id: <20190609164153.260173588@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 296d5b54163964b7ae536b8b57dfbd21d4e868e1 ]

For every RX packet, the driver replenishes all buffers used for that
packet and puts them back into the RX ring and RX aggregation ring.
In one code path where the RX packet has one RX buffer and one or more
aggregation buffers, we missed recycling the aggregation buffer(s) if
we are unable to allocate a new SKB buffer.  This leads to the
aggregation ring slowly running out of buffers over time.  Fix it
by properly recycling the aggregation buffers.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Reported-by: Rakesh Hemnani <rhemnani@fb.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1140,6 +1140,8 @@ static int bnxt_rx_pkt(struct bnxt *bp,
 		skb = bnxt_copy_skb(bnapi, data, len, dma_addr);
 		bnxt_reuse_rx_data(rxr, cons, data);
 		if (!skb) {
+			if (agg_bufs)
+				bnxt_reuse_rx_agg_bufs(bnapi, cp_cons, agg_bufs);
 			rc = -ENOMEM;
 			goto next_rx;
 		}


