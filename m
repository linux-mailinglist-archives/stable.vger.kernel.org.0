Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218F05480A9
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 09:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbiFMHfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 03:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233642AbiFMHfe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 03:35:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE59B46
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 00:35:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52978B80D21
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 07:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE661C34114;
        Mon, 13 Jun 2022 07:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655105731;
        bh=kh/NdX1m9Qt2zXY0Eg3hFCCf5IH0O/+6CUgROEBqJ8E=;
        h=Subject:To:Cc:From:Date:From;
        b=AXmeEZZ5fqUn86is5rvcec4mjHUzQTAhRFeCdlQbEmO0bQlOvPI0Y5CpHwyOJobdU
         DqPQlIyG7D9dqMMQ/ZX4zHQ1D/0JE7+3tefrBB1ncCUE7Rl+d/BvEP4N5tFl9566Wc
         dyYg1qoZeckmILrEC/Ka9jR9gUPXyUIgVTsP9hFM=
Subject: FAILED: patch "[PATCH] ixgbe: fix unexpected VLAN Rx in promisc mode on VF" failed to apply to 4.9-stable tree
To:     olivier.matz@6wind.com, anthony.l.nguyen@intel.com,
        konrad0.jankowski@intel.com, nicolas.dichtel@6wind.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Jun 2022 09:35:28 +0200
Message-ID: <165510572856201@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7bb0fb7c63df95d6027dc50d6af3bc3bbbc25483 Mon Sep 17 00:00:00 2001
From: Olivier Matz <olivier.matz@6wind.com>
Date: Wed, 6 Apr 2022 11:52:52 +0200
Subject: [PATCH] ixgbe: fix unexpected VLAN Rx in promisc mode on VF
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When the promiscuous mode is enabled on a VF, the IXGBE_VMOLR_VPE
bit (VLAN Promiscuous Enable) is set. This means that the VF will
receive packets whose VLAN is not the same than the VLAN of the VF.

For instance, in this situation:

┌────────┐    ┌────────┐    ┌────────┐
│        │    │        │    │        │
│        │    │        │    │        │
│     VF0├────┤VF1  VF2├────┤VF3     │
│        │    │        │    │        │
└────────┘    └────────┘    └────────┘
   VM1           VM2           VM3

vf 0:  vlan 1000
vf 1:  vlan 1000
vf 2:  vlan 1001
vf 3:  vlan 1001

If we tcpdump on VF3, we see all the packets, even those transmitted
on vlan 1000.

This behavior prevents to bridge VF1 and VF2 in VM2, because it will
create a loop: packets transmitted on VF1 will be received by VF2 and
vice-versa, and bridged again through the software bridge.

This patch remove the activation of VLAN Promiscuous when a VF enables
the promiscuous mode. However, the IXGBE_VMOLR_UPE bit (Unicast
Promiscuous) is kept, so that a VF receives all packets that has the
same VLAN, whatever the destination MAC address.

Fixes: 8443c1a4b192 ("ixgbe, ixgbevf: Add new mbox API xcast mode")
Cc: stable@vger.kernel.org
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Olivier Matz <olivier.matz@6wind.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index 8d108a78941b..d4e63f0644c3 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -1208,9 +1208,9 @@ static int ixgbe_update_vf_xcast_mode(struct ixgbe_adapter *adapter,
 			return -EPERM;
 		}
 
-		disable = 0;
+		disable = IXGBE_VMOLR_VPE;
 		enable = IXGBE_VMOLR_BAM | IXGBE_VMOLR_ROMPE |
-			 IXGBE_VMOLR_MPE | IXGBE_VMOLR_UPE | IXGBE_VMOLR_VPE;
+			 IXGBE_VMOLR_MPE | IXGBE_VMOLR_UPE;
 		break;
 	default:
 		return -EOPNOTSUPP;

