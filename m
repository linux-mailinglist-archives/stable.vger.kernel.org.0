Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605B2531961
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241222AbiEWRcs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241390AbiEWR0p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:26:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1576719EA;
        Mon, 23 May 2022 10:21:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0A0160C07;
        Mon, 23 May 2022 17:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B6AC385A9;
        Mon, 23 May 2022 17:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326403;
        bh=JoPtU68O5a47132Y5jVvQFSns2yuUntzeYmZPcEaBfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wWhBjVUn/73iLUmLtOMUVMoHUX+UrWAFTsCIjGavRJ+vSNBqD+j11+PR3AuXSzmf9
         zNMZ72d5MBF4Lm5JoK6wOzKkZ0/cc9Hafp0MLGjfofS4mVYheV0LVlGGhHTIizHQdt
         qHE4VaVZtgnkidDF9unO2B5N7cqV3If4n30dzT/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/132] net: ipa: record proper RX transaction count
Date:   Mon, 23 May 2022 19:04:39 +0200
Message-Id: <20220523165834.768895142@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit d8290cbe1111105f92f0c8ab455bec8bf98d0630 ]

Each time we are notified that some number of transactions on an RX
channel has completed, we record the number of bytes that have been
transferred since the previous notification.  We also track the
number of transactions completed, but that is not currently being
calculated correctly; we're currently counting the number of such
notifications, but each notification can represent many transaction
completions.  Fix this.

Fixes: 650d1603825d8 ("soc: qcom: ipa: the generic software interface")
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/gsi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index a2fcdb1abdb9..a734e5576729 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1370,9 +1370,10 @@ static void gsi_evt_ring_rx_update(struct gsi_evt_ring *evt_ring, u32 index)
 	struct gsi_event *event_done;
 	struct gsi_event *event;
 	struct gsi_trans *trans;
+	u32 trans_count = 0;
 	u32 byte_count = 0;
-	u32 old_index;
 	u32 event_avail;
+	u32 old_index;
 
 	trans_info = &channel->trans_info;
 
@@ -1393,6 +1394,7 @@ static void gsi_evt_ring_rx_update(struct gsi_evt_ring *evt_ring, u32 index)
 	do {
 		trans->len = __le16_to_cpu(event->len);
 		byte_count += trans->len;
+		trans_count++;
 
 		/* Move on to the next event and transaction */
 		if (--event_avail)
@@ -1404,7 +1406,7 @@ static void gsi_evt_ring_rx_update(struct gsi_evt_ring *evt_ring, u32 index)
 
 	/* We record RX bytes when they are received */
 	channel->byte_count += byte_count;
-	channel->trans_count++;
+	channel->trans_count += trans_count;
 }
 
 /* Initialize a ring, including allocating DMA memory for its entries */
-- 
2.35.1



