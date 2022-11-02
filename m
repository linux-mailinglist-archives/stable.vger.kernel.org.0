Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523C16159D5
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiKBDTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiKBDTJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:19:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD481A81E
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:19:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCF8161729
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:19:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B299C433C1;
        Wed,  2 Nov 2022 03:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359147;
        bh=nKF4J2KJiJjboJMW7KSxUjQFTB8Pnwq1lHUUlVfydgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MvkbhbswVJLWZWW2ZuZLLk+Fe5o9/n4euw+2JIYbAtwEzq7M1/Ekufws0SWG5UD8E
         R905j/kGQTlpWBDfuXhYyyvHHlOVG0nNdkLlMGG2LvOklDns+ZJS1+Z6EcM+l9Khar
         2+4phz7W3M+12K75B2fccPYOMUjcQ0pnBvmDdhpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 84/91] net: enetc: survive memory pressure without crashing
Date:   Wed,  2 Nov 2022 03:34:07 +0100
Message-Id: <20221102022057.439693682@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 84ce1ca3fe9e1249bf21176ff162200f1c4e5ed1 ]

Under memory pressure, enetc_refill_rx_ring() may fail, and when called
during the enetc_open() -> enetc_setup_rxbdr() procedure, this is not
checked for.

An extreme case of memory pressure will result in exactly zero buffers
being allocated for the RX ring, and in such a case it is expected that
hardware drops all RX packets due to lack of buffers.

This does not happen, because the reset-default value of the consumer
and produces index is 0, and this makes the ENETC think that all buffers
have been initialized and that it owns them (when in reality none were).

The hardware guide explains this best:

| Configure the receive ring producer index register RBaPIR with a value
| of 0. The producer index is initially configured by software but owned
| by hardware after the ring has been enabled. Hardware increments the
| index when a frame is received which may consume one or more BDs.
| Hardware is not allowed to increment the producer index to match the
| consumer index since it is used to indicate an empty condition. The ring
| can hold at most RBLENR[LENGTH]-1 received BDs.
|
| Configure the receive ring consumer index register RBaCIR. The
| consumer index is owned by software and updated during operation of the
| of the BD ring by software, to indicate that any receive data occupied
| in the BD has been processed and it has been prepared for new data.
| - If consumer index and producer index are initialized to the same
|   value, it indicates that all BDs in the ring have been prepared and
|   hardware owns all of the entries.
| - If consumer index is initialized to producer index plus N, it would
|   indicate N BDs have been prepared. Note that hardware cannot start if
|   only a single buffer is prepared due to the restrictions described in
|   (2).
| - Software may write consumer index to match producer index anytime
|   while the ring is operational to indicate all received BDs prior have
|   been processed and new BDs prepared for hardware.

Normally, the value of rx_ring->rcir (consumer index) is brought in sync
with the rx_ring->next_to_use software index, but this only happens if
page allocation ever succeeded.

When PI==CI==0, the hardware appears to receive frames and write them to
DMA address 0x0 (?!), then set the READY bit in the BD.

The enetc_clean_rx_ring() function (and its XDP derivative) is naturally
not prepared to handle such a condition. It will attempt to process
those frames using the rx_swbd structure associated with index i of the
RX ring, but that structure is not fully initialized (enetc_new_page()
does all of that). So what happens next is undefined behavior.

To operate using no buffer, we must initialize the CI to PI + 1, which
will block the hardware from advancing the CI any further, and drop
everything.

The issue was seen while adding support for zero-copy AF_XDP sockets,
where buffer memory comes from user space, which can even decide to
supply no buffers at all (example: "xdpsock --txonly"). However, the bug
is present also with the network stack code, even though it would take a
very determined person to trigger a page allocation failure at the
perfect time (a series of ifup/ifdown under memory pressure should
eventually reproduce it given enough retries).

Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Link: https://lore.kernel.org/r/20221027182925.3256653-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 4af253825957..ca62c72eb772 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1241,7 +1241,12 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
 
 	enetc_rxbdr_wr(hw, idx, ENETC_RBBSR, ENETC_RXB_DMA_SIZE);
 
+	/* Also prepare the consumer index in case page allocation never
+	 * succeeds. In that case, hardware will never advance producer index
+	 * to match consumer index, and will drop all frames.
+	 */
 	enetc_rxbdr_wr(hw, idx, ENETC_RBPIR, 0);
+	enetc_rxbdr_wr(hw, idx, ENETC_RBCIR, 1);
 
 	/* enable Rx ints by setting pkt thr to 1 */
 	enetc_rxbdr_wr(hw, idx, ENETC_RBICR0, ENETC_RBICR0_ICEN | 0x1);
-- 
2.35.1



