Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEFD84B4818
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244395AbiBNJhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:37:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245678AbiBNJgz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:36:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9582652F2;
        Mon, 14 Feb 2022 01:34:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE52860DFD;
        Mon, 14 Feb 2022 09:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB65C340E9;
        Mon, 14 Feb 2022 09:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831293;
        bh=0fE79SdwcNyQs1yHs10c3OBhLkh0vjzSbISpnacRTzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KCkAfOXVUzoRpP5M3SOxDxyTsr+rr9Qb40MMlBc957FWlDbVzh4zWFW0AZU79ppoG
         TJmkRddxBvTGINX2sJvv8qrNzuiEg83v0u6FrdLA22nO0ntW0d8rfJC907OCm3Y1J2
         unSUXqxe3mr0OBwdDEl5s5fRMdedVcVn+h66wsJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Mendoza-Jonas <samjonas@amazon.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 26/49] ixgbevf: Require large buffers for build_skb on 82599VF
Date:   Mon, 14 Feb 2022 10:25:52 +0100
Message-Id: <20220214092449.155813435@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092448.285381753@linuxfoundation.org>
References: <20220214092448.285381753@linuxfoundation.org>
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
index 7f94b445595ce..befb906acb205 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -1964,14 +1964,15 @@ static void ixgbevf_set_rx_buffer_len(struct ixgbevf_adapter *adapter,
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



