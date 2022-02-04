Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB7A4A9660
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357859AbiBDJZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357595AbiBDJYa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:24:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1AFC06177A;
        Fri,  4 Feb 2022 01:24:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D34AB836B9;
        Fri,  4 Feb 2022 09:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59540C004E1;
        Fri,  4 Feb 2022 09:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966668;
        bh=fSmrUO2QO2mxwW/Q3DVpy091GpVKvail29v4IS7R+dU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oDS/m2KrhsYSLT6KbhBQGxzz8YyppL2bPL3sG6kHTnagRbfeKoBqHi/DarBbZJpcd
         gKtXOgmaIykGmkSx0a/CrWqt2R6p0npf6eo8Zr9F1LBZdQuPKt6Kf/DYBHEOssjX4V
         SsMdEXHGe4GxZBBvUYdxC3IsuyfDTK3pzO7CVqqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 25/32] net: amd-xgbe: Fix skb data length underflow
Date:   Fri,  4 Feb 2022 10:22:35 +0100
Message-Id: <20220204091916.090850152@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091915.247906930@linuxfoundation.org>
References: <20220204091915.247906930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
@@ -2557,6 +2557,14 @@ read_again:
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
@@ -2586,8 +2594,10 @@ skip_data:
 		if (!last || context_next)
 			goto read_again;
 
-		if (!skb)
+		if (!skb || error) {
+			dev_kfree_skb(skb);
 			goto next_packet;
+		}
 
 		/* Be sure we don't exceed the configured MTU */
 		max_len = netdev->mtu + ETH_HLEN;


