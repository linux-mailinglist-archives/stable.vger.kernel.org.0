Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9FE69CE1E
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbjBTN4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:56:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbjBTN4E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:56:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF4018B39
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:55:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93A4CB80B96
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F15C433EF;
        Mon, 20 Feb 2023 13:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901356;
        bh=te7zXP6EkKtX6jk73NehfKyQ+gwhPqK+3RHycD9r2Ro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QEzvQlwsWZijBQLO9T1amtA8QDZ0k2c49p9GOHaO8yfLvY7x0nLeOocvgcbzGj1ok
         u/Bqiqmt7/rdkivi9Zsl2qBK6Knt1OOVTiQBGlzE9s1AjXhWU4vbbvKsaURqQjXvTr
         GlTwOIFPtKLfumm2Iao5rojvwg2FyCvQa5BjtPRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jason Xing <kernelxing@tencent.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 5.10 43/57] ixgbe: add double of VLAN header when computing the max MTU
Date:   Mon, 20 Feb 2023 14:36:51 +0100
Message-Id: <20230220133550.861833630@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133549.360169435@linuxfoundation.org>
References: <20230220133549.360169435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Xing <kernelxing@tencent.com>

commit 0967bf837784a11c65d66060623a74e65211af0b upstream.

Include the second VLAN HLEN into account when computing the maximum
MTU size as other drivers do.

Fixes: fabf1bce103a ("ixgbe: Prevent unsupported configurations with XDP")
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |    2 ++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    3 +--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -67,6 +67,8 @@
 #define IXGBE_RXBUFFER_4K    4096
 #define IXGBE_MAX_RXBUFFER  16384  /* largest size for a single descriptor */
 
+#define IXGBE_PKT_HDR_PAD   (ETH_HLEN + ETH_FCS_LEN + (VLAN_HLEN * 2))
+
 /* Attempt to maximize the headroom available for incoming frames.  We
  * use a 2K buffer for receives and need 1536/1534 to store the data for
  * the frame.  This leaves us with 512 bytes of room.  From that we need
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6752,8 +6752,7 @@ static int ixgbe_change_mtu(struct net_d
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 
 	if (ixgbe_enabled_xdp_adapter(adapter)) {
-		int new_frame_size = new_mtu + ETH_HLEN + ETH_FCS_LEN +
-				     VLAN_HLEN;
+		int new_frame_size = new_mtu + IXGBE_PKT_HDR_PAD;
 
 		if (new_frame_size > ixgbe_max_xdp_frame_size(adapter)) {
 			e_warn(probe, "Requested MTU size is not supported with XDP\n");


