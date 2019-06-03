Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15FD932C1B
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbfFCJNk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:13:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727887AbfFCJNi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:13:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA08D27EB0;
        Mon,  3 Jun 2019 09:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553218;
        bh=91c/7Vw0o7uW7vB6jdWbVqPOLMj6YQ1zYZM9AcHEjYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oLTBHuHufjct1pV87yNf2vSDVNizbsgJQ84XNqnH0DxWhBwFTayhD/lrrb5H5rfww
         LjpcIc6MSSCVTR7ZNl7tVoBLrAw9G7cLXp4KFMWHkGywL6OdiGsOTkQApTLcF+acqQ
         tOCxFJT+ohbxH8/TLh57c0HRwy67cUUHLIWOVmhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rakesh Hemnani <rhemnani@fb.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 27/40] bnxt_en: Fix aggregation buffer leak under OOM condition.
Date:   Mon,  3 Jun 2019 11:09:20 +0200
Message-Id: <20190603090524.265305338@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090522.617635820@linuxfoundation.org>
References: <20190603090522.617635820@linuxfoundation.org>
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
@@ -1640,6 +1640,8 @@ static int bnxt_rx_pkt(struct bnxt *bp,
 		skb = bnxt_copy_skb(bnapi, data_ptr, len, dma_addr);
 		bnxt_reuse_rx_data(rxr, cons, data);
 		if (!skb) {
+			if (agg_bufs)
+				bnxt_reuse_rx_agg_bufs(cpr, cp_cons, agg_bufs);
 			rc = -ENOMEM;
 			goto next_rx;
 		}


