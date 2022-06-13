Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D725494E0
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240439AbiFMMt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357571AbiFMMtF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:49:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E7862BDA;
        Mon, 13 Jun 2022 04:11:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98F34B80EAA;
        Mon, 13 Jun 2022 11:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E832FC34114;
        Mon, 13 Jun 2022 11:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118711;
        bh=2kdVZxq7QhwiMhHg48ux5Jq1HvMBVruEQH6DiUTxjWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H9qkdvZmOX9fgYAiff3B8X/5v+sa54SBfCfHDkH/GFN/Rc62iBJn1f4LH0kBUBTvW
         p9udlEjT9HFWKgq1oZS9HsB/Mo1RNcYnTHkMbwRMvbbtnbY+Af9KJeqw9F5LDcJeKv
         0aXnIipHkCRZO14Ulza4AMU//cX/JB7qOYPmMB9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Olivier Matz <olivier.matz@6wind.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.10 162/172] ixgbe: fix unexpected VLAN Rx in promisc mode on VF
Date:   Mon, 13 Jun 2022 12:12:02 +0200
Message-Id: <20220613094923.179920710@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Olivier Matz <olivier.matz@6wind.com>

commit 7bb0fb7c63df95d6027dc50d6af3bc3bbbc25483 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -1181,9 +1181,9 @@ static int ixgbe_update_vf_xcast_mode(st
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


