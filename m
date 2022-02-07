Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E414ABA56
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238386AbiBGLZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:25:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343558AbiBGLJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:09:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB85C043181;
        Mon,  7 Feb 2022 03:09:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 497FDB80EC3;
        Mon,  7 Feb 2022 11:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFE9C004E1;
        Mon,  7 Feb 2022 11:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232145;
        bh=sSN5IaaNkR+bNNzEnIm5DAhmzKX7oOdxJ9V2k3QJHgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jz99Pwx4TsGkCc7VeyC4wjhIeGm1UR5tm8zU53pJtpZ9ZuYsgll8zNdTk5A90GR3A
         KX56ZH2HcR6FnJq0NdcXpPHHOUNtbLQA2BX2mSTgoKTb1FFRDLHZFSXL+2805IzhmF
         Mr7hZOPnlClakt9WjHDy7q568Jod6xeyeUcYgI2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 30/48] net: amd-xgbe: Fix skb data length underflow
Date:   Mon,  7 Feb 2022 12:06:03 +0100
Message-Id: <20220207103753.325503466@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103752.341184175@linuxfoundation.org>
References: <20220207103752.341184175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

commit 5aac9108a180fc06e28d4e7fb00247ce603b72ee upstream.

There will be BUG_ON() triggered in include/linux/skbuff.h leading to
intermittent kernel panic, when the skb length underflow is detected.

Fix this by dropping the packet if such length underflows are seen
because of inconsistencies in the hardware descriptors.

Fixes: 622c36f143fc ("amd-xgbe: Fix jumbo MTU processing on newer hardware")
Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20220127092003.2812745-1-Shyam-sundar.S-k@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -1968,6 +1968,14 @@ read_again:
 			buf2_len = xgbe_rx_buf2_len(rdata, packet, len);
 			len += buf2_len;
 
+			if (buf2_len > rdata->rx.buf.dma_len) {
+				/* Hardware inconsistency within the descriptors
+				 * that has resulted in a length underflow.
+				 */
+				error = 1;
+				goto skip_data;
+			}
+
 			if (!skb) {
 				skb = xgbe_create_skb(pdata, napi, rdata,
 						      buf1_len);
@@ -1997,8 +2005,10 @@ skip_data:
 		if (!last || context_next)
 			goto read_again;
 
-		if (!skb)
+		if (!skb || error) {
+			dev_kfree_skb(skb);
 			goto next_packet;
+		}
 
 		/* Be sure we don't exceed the configured MTU */
 		max_len = netdev->mtu + ETH_HLEN;


