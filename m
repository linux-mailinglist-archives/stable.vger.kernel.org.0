Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1702869B9BD
	for <lists+stable@lfdr.de>; Sat, 18 Feb 2023 12:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjBRLZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Feb 2023 06:25:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjBRLZG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Feb 2023 06:25:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9E11420D
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 03:25:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08F1960AEF
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 11:25:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A37C433D2;
        Sat, 18 Feb 2023 11:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676719504;
        bh=/CNVWg1MSLDdzQ7Czw/B5eMJxoI4U6tlQPCKgXXzmYQ=;
        h=Subject:To:Cc:From:Date:From;
        b=MWYP7BwfweQa1Ct1Wt2HeIhYCRgTEgmAnZX96ZCpxqlm6F8LQLJQUoc62LNjDxpdL
         hSZHmXke2ZmDUsnSbjTGIBoc3sJNHe8v+FZ6jZgdQThXECzDTRWSnTv1kzaGqFzN5b
         CJCw0Er8JPK9tXUBzuzMQzX7JWdYEaI9Q/jhNAfw=
Subject: FAILED: patch "[PATCH] ixgbe: add double of VLAN header when computing the max MTU" failed to apply to 4.19-stable tree
To:     kernelxing@tencent.com, alexanderduyck@fb.com,
        anthony.l.nguyen@intel.com, chandanx.rout@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 18 Feb 2023 12:25:01 +0100
Message-ID: <1676719501194167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

0967bf837784 ("ixgbe: add double of VLAN header when computing the max MTU")
f9cd6a4418ba ("ixgbe: allow to increase MTU to 3K with XDP enabled")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0967bf837784a11c65d66060623a74e65211af0b Mon Sep 17 00:00:00 2001
From: Jason Xing <kernelxing@tencent.com>
Date: Thu, 9 Feb 2023 10:41:28 +0800
Subject: [PATCH] ixgbe: add double of VLAN header when computing the max MTU

Include the second VLAN HLEN into account when computing the maximum
MTU size as other drivers do.

Fixes: fabf1bce103a ("ixgbe: Prevent unsupported configurations with XDP")
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index bc68b8f2176d..8736ca4b2628 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -73,6 +73,8 @@
 #define IXGBE_RXBUFFER_4K    4096
 #define IXGBE_MAX_RXBUFFER  16384  /* largest size for a single descriptor */
 
+#define IXGBE_PKT_HDR_PAD   (ETH_HLEN + ETH_FCS_LEN + (VLAN_HLEN * 2))
+
 /* Attempt to maximize the headroom available for incoming frames.  We
  * use a 2K buffer for receives and need 1536/1534 to store the data for
  * the frame.  This leaves us with 512 bytes of room.  From that we need
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 25ca329f7d3c..4507fba8747a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6801,8 +6801,7 @@ static int ixgbe_change_mtu(struct net_device *netdev, int new_mtu)
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 
 	if (ixgbe_enabled_xdp_adapter(adapter)) {
-		int new_frame_size = new_mtu + ETH_HLEN + ETH_FCS_LEN +
-				     VLAN_HLEN;
+		int new_frame_size = new_mtu + IXGBE_PKT_HDR_PAD;
 
 		if (new_frame_size > ixgbe_max_xdp_frame_size(adapter)) {
 			e_warn(probe, "Requested MTU size is not supported with XDP\n");

