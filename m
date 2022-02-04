Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0844A960E
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239285AbiBDJWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:22:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357509AbiBDJVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:21:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD35C061751;
        Fri,  4 Feb 2022 01:21:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC68AB836EF;
        Fri,  4 Feb 2022 09:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB67C004E1;
        Fri,  4 Feb 2022 09:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966500;
        bh=qOJ6whip6kE3To8wzXTaEVKxv041YSfcDKIcXA478C0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XBnACFGs3XAOEW8a8qCbWIT7YclBO9g3tXa98psrSj4HzmzD9qDILTU5pEgXYGEt+
         o8dVvxwwr1cTvfJc4aLglO8V+PWiRtbXpYrqNlf7XaSziY/KZHmOZYQrnjynCMMrPc
         l7QgdaijPMN9Wo66T40+ZwFyy/wb/ApdmXi6atzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 19/25] net: amd-xgbe: Fix skb data length underflow
Date:   Fri,  4 Feb 2022 10:20:26 +0100
Message-Id: <20220204091914.902444262@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091914.280602669@linuxfoundation.org>
References: <20220204091914.280602669@linuxfoundation.org>
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
@@ -2559,6 +2559,14 @@ read_again:
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
@@ -2588,8 +2596,10 @@ skip_data:
 		if (!last || context_next)
 			goto read_again;
 
-		if (!skb)
+		if (!skb || error) {
+			dev_kfree_skb(skb);
 			goto next_packet;
+		}
 
 		/* Be sure we don't exceed the configured MTU */
 		max_len = netdev->mtu + ETH_HLEN;


