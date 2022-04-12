Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8144FD867
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239658AbiDLHc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353654AbiDLHZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5008243EC8;
        Tue, 12 Apr 2022 00:03:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF4B160B2B;
        Tue, 12 Apr 2022 07:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD72C385A1;
        Tue, 12 Apr 2022 07:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746992;
        bh=ZmVg6nnJgLJvWNdDIU3iS7vr3yUm9E+6YUq+JKx8918=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zITbxr7gtPXKHNUhlN4NcWWPndU3wCGnirXoh39n3YjQL/YjwJtbSP2q/ctde9G4c
         obrUgZANtGE4nTcGJhzxl5LoA4xFcakv4HNwt6Y5yYo19Sx7VJbI9lTCL5iDRTchWa
         46JiBhtbYqeyaLdwiKtTG+eqowqC0wzP2LFGP84o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ivan Vecera <ivecera@redhat.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alice Michael <alice.michael@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 164/285] ice: Clear default forwarding VSI during VSI release
Date:   Tue, 12 Apr 2022 08:30:21 +0200
Message-Id: <20220412062948.404140197@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit bd8c624c0cd59de0032752ba3001c107bba97f7b ]

VSI is set as default forwarding one when promisc mode is set for
PF interface, when PF is switched to switchdev mode or when VF
driver asks to enable allmulticast or promisc mode for the VF
interface (when vf-true-promisc-support priv flag is off).
The third case is buggy because in that case VSI associated with
VF remains as default one after VF removal.

Reproducer:
1. Create VF
   echo 1 > sys/class/net/ens7f0/device/sriov_numvfs
2. Enable allmulticast or promisc mode on VF
   ip link set ens7f0v0 allmulticast on
   ip link set ens7f0v0 promisc on
3. Delete VF
   echo 0 > sys/class/net/ens7f0/device/sriov_numvfs
4. Try to enable promisc mode on PF
   ip link set ens7f0 promisc on

Although it looks that promisc mode on PF is enabled the opposite
is true because ice_vsi_sync_fltr() responsible for IFF_PROMISC
handling first checks if any other VSI is set as default forwarding
one and if so the function does not do anything. At this point
it is not possible to enable promisc mode on PF without re-probe
device.

To resolve the issue this patch clear default forwarding VSI
during ice_vsi_release() when the VSI to be released is the default
one.

Fixes: 01b5e89aab49 ("ice: Add VF promiscuous support")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Alice Michael <alice.michael@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index edba96845baf..e39e299e79a4 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3113,6 +3113,8 @@ int ice_vsi_release(struct ice_vsi *vsi)
 		}
 	}
 
+	if (ice_is_vsi_dflt_vsi(pf->first_sw, vsi))
+		ice_clear_dflt_vsi(pf->first_sw);
 	ice_fltr_remove_all(vsi);
 	ice_rm_vsi_lan_cfg(vsi->port_info, vsi->idx);
 	err = ice_rm_vsi_rdma_cfg(vsi->port_info, vsi->idx);
-- 
2.35.1



