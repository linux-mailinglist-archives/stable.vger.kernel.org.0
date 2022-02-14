Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDBAB4B476A
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244831AbiBNJms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:42:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245556AbiBNJlk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:41:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F9F65824;
        Mon, 14 Feb 2022 01:37:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8726AB80DC8;
        Mon, 14 Feb 2022 09:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4EBEC340EF;
        Mon, 14 Feb 2022 09:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831454;
        bh=hBXwcKH8k+zEpg1EUB7WTJMbXB/JJNlZlsdTHpX67CY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UUGV+d9BBa+bUNUiA0tWzCtz5Qy9hE9x5Pm7JJTSN18H6ALtmjsCz+mhCUxlkdmBN
         Jez9vUvHz7ZyPGtlwE8+UfhvF3Tkb/NUqzjALj1jwJLq+IPTqNZ+8BHdFMGcZulgq8
         s+xNjVPNrw3SCW+8G92Ng/MGk+7VJFjXdchLL0wA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Mendoza-Jonas <samjonas@amazon.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 40/71] ixgbevf: Require large buffers for build_skb on 82599VF
Date:   Mon, 14 Feb 2022 10:26:08 +0100
Message-Id: <20220214092453.385324672@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
References: <20220214092452.020713240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Mendoza-Jonas <samjonas@amazon.com>

[ Upstream commit fe68195daf34d5dddacd3f93dd3eafc4beca3a0e ]

>From 4.17 onwards the ixgbevf driver uses build_skb() to build an skb
around new data in the page buffer shared with the ixgbe PF.
This uses either a 2K or 3K buffer, and offsets the DMA mapping by
NET_SKB_PAD + NET_IP_ALIGN. When using a smaller buffer RXDCTL is set to
ensure the PF does not write a full 2K bytes into the buffer, which is
actually 2K minus the offset.

However on the 82599 virtual function, the RXDCTL mechanism is not
available. The driver attempts to work around this by using the SET_LPE
mailbox method to lower the maximm frame size, but the ixgbe PF driver
ignores this in order to keep the PF and all VFs in sync[0].

This means the PF will write up to the full 2K set in SRRCTL, causing it
to write NET_SKB_PAD + NET_IP_ALIGN bytes past the end of the buffer.
With 4K pages split into two buffers, this means it either writes
NET_SKB_PAD + NET_IP_ALIGN bytes past the first buffer (and into the
second), or NET_SKB_PAD + NET_IP_ALIGN bytes past the end of the DMA
mapping.

Avoid this by only enabling build_skb when using "large" buffers (3K).
These are placed in each half of an order-1 page, preventing the PF from
writing past the end of the mapping.

[0]: Technically it only ever raises the max frame size, see
ixgbe_set_vf_lpe() in ixgbe_sriov.c

Fixes: f15c5ba5b6cd ("ixgbevf: add support for using order 1 pages to receive large frames")
Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index be8e6d4e376ec..9bd02766a4bcc 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -1979,14 +1979,15 @@ static void ixgbevf_set_rx_buffer_len(struct ixgbevf_adapter *adapter,
 	if (adapter->flags & IXGBEVF_FLAGS_LEGACY_RX)
 		return;
 
-	set_ring_build_skb_enabled(rx_ring);
+	if (PAGE_SIZE < 8192)
+		if (max_frame > IXGBEVF_MAX_FRAME_BUILD_SKB)
+			set_ring_uses_large_buffer(rx_ring);
 
-	if (PAGE_SIZE < 8192) {
-		if (max_frame <= IXGBEVF_MAX_FRAME_BUILD_SKB)
-			return;
+	/* 82599 can't rely on RXDCTL.RLPML to restrict the size of the frame */
+	if (adapter->hw.mac.type == ixgbe_mac_82599_vf && !ring_uses_large_buffer(rx_ring))
+		return;
 
-		set_ring_uses_large_buffer(rx_ring);
-	}
+	set_ring_build_skb_enabled(rx_ring);
 }
 
 /**
-- 
2.34.1



