Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE324BBAF1
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 15:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbiBROuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 09:50:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236180AbiBROuz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 09:50:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC58D3FDAD
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 06:50:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 480F9617CB
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 14:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D8BC340E9;
        Fri, 18 Feb 2022 14:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645195836;
        bh=6JvDs1D9Tx/J0HyZBycDtQ2G54OqEPEqt6v4nXU7bYg=;
        h=Subject:To:Cc:From:Date:From;
        b=wxdc29dpvzD3PSdyECGUgfVXb+3qNihhlMZC9wFgOcJ8NQVSI0xnwZfDRnuIYF5qx
         8Joe1tVUmd9dBPNXzdrpY2aqXSK6T+5t0pNxww9rIuRv7KNCSfZea+Q0H3NloAxlmj
         2BCe+9dwxc2Nid7O4czn5LdWvrD/W37XJEEL+I9o=
Subject: FAILED: patch "[PATCH] ice: enable parsing IPSEC SPI headers for RSS" failed to apply to 5.16-stable tree
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, gurucharanx.g@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Feb 2022 15:50:19 +0100
Message-ID: <1645195819240128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 86006f996346e8a5a1ea80637ec949ceeea4ecbc Mon Sep 17 00:00:00 2001
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Date: Fri, 11 Feb 2022 09:14:18 -0800
Subject: [PATCH] ice: enable parsing IPSEC SPI headers for RSS

The COMMS package can enable the hardware parser to recognize IPSEC
frames with ESP header and SPI identifier.  If this package is available
and configured for loading in /lib/firmware, then the driver will
succeed in enabling this protocol type for RSS.

This in turn allows the hardware to hash over the SPI and use it to pick
a consistent receive queue for the same secure flow. Without this all
traffic is steered to the same queue for multiple traffic threads from
the same IP address. For that reason this is marked as a fix, as the
driver supports the model, but it wasn't enabled.

If the package is not available, adding this type will fail, but the
failure is ignored on purpose as it has no negative affect.

Fixes: c90ed40cefe1 ("ice: Enable writing hardware filtering tables")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 0c187cf04fcf..53256aca27c7 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1684,6 +1684,12 @@ static void ice_vsi_set_rss_flow_fld(struct ice_vsi *vsi)
 	if (status)
 		dev_dbg(dev, "ice_add_rss_cfg failed for sctp6 flow, vsi = %d, error = %d\n",
 			vsi_num, status);
+
+	status = ice_add_rss_cfg(hw, vsi_handle, ICE_FLOW_HASH_ESP_SPI,
+				 ICE_FLOW_SEG_HDR_ESP);
+	if (status)
+		dev_dbg(dev, "ice_add_rss_cfg failed for esp/spi flow, vsi = %d, error = %d\n",
+			vsi_num, status);
 }
 
 /**

