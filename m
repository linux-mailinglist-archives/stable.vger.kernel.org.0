Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89EED664B29
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239444AbjAJSjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239643AbjAJSia (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:38:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78419496F4
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:33:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 243E0B818FF
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4D0C433D2;
        Tue, 10 Jan 2023 18:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375634;
        bh=TSA+NxmmsuExvj62j4Sm8/wAeX2Hy8yaMNj1kKNWnfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s3KVb1sq/0Q2iu3wkfns6OclcnP1aQvwvUjqMG+EMh7TK2S7RUED+TCNA4l4fq8RC
         ioCIA5YJ64HdxRBFoe+3koYq6o+Or054K7giSWKi3ciwTExj0rV0Ln9XPW91JGivQz
         +jsG+TM7Oe6g3UaXLNd+yLBn1d3FB2SPfUTXLQRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Arinzon <darinzon@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 235/290] net: ena: Set default value for RX interrupt moderation
Date:   Tue, 10 Jan 2023 19:05:27 +0100
Message-Id: <20230110180040.122438423@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Arinzon <darinzon@amazon.com>

[ Upstream commit e712f3e4920b3a1a5e6b536827d118e14862896c ]

RX ring can be NULL in XDP use cases where only TX queues
are configured. In this scenario, the RX interrupt moderation
value sent to the device remains in its default value of 0.

In this change, setting the default value of the RX interrupt
moderation to be the same as of the TX.

Fixes: 548c4940b9f1 ("net: ena: Implement XDP_TX action")
Signed-off-by: David Arinzon <darinzon@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 8f1b205e7333..b1533a45f645 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1836,8 +1836,9 @@ static void ena_adjust_adaptive_rx_intr_moderation(struct ena_napi *ena_napi)
 static void ena_unmask_interrupt(struct ena_ring *tx_ring,
 					struct ena_ring *rx_ring)
 {
+	u32 rx_interval = tx_ring->smoothed_interval;
 	struct ena_eth_io_intr_reg intr_reg;
-	u32 rx_interval = 0;
+
 	/* Rx ring can be NULL when for XDP tx queues which don't have an
 	 * accompanying rx_ring pair.
 	 */
-- 
2.35.1



