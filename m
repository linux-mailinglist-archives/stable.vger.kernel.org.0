Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96FD04ABB21
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384242AbiBGL0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:26:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379200AbiBGLQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:16:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC1AC0401D2;
        Mon,  7 Feb 2022 03:16:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96C4F61388;
        Mon,  7 Feb 2022 11:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702ADC004E1;
        Mon,  7 Feb 2022 11:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232567;
        bh=f4UB5JkafdnoULo47nnHjJN6Y59S8RmpFY8FXJOLDI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CqQ6E0Ru0zw4G+6Xy6/TFXxkPR8QZtvKErQZ6V5qdMKy04mrWODEfth5qnVJaXMkp
         CzbyWfD4N5FfyRpwmS+t0NiJi6LKaAzaF4hEiUmaiCksjjXKPu4ccpJc1RTlK1dyU1
         QuCXSRwYJI4+YjhGPBpdMQCzVb3rAztQfgfzQIIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 51/86] net: amd-xgbe: Fix skb data length underflow
Date:   Mon,  7 Feb 2022 12:06:14 +0100
Message-Id: <20220207103759.229341782@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
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
@@ -2768,6 +2768,14 @@ read_again:
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
@@ -2797,8 +2805,10 @@ skip_data:
 		if (!last || context_next)
 			goto read_again;
 
-		if (!skb)
+		if (!skb || error) {
+			dev_kfree_skb(skb);
 			goto next_packet;
+		}
 
 		/* Be sure we don't exceed the configured MTU */
 		max_len = netdev->mtu + ETH_HLEN;


