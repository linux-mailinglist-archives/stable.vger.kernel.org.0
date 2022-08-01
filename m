Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A265868BC
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbiHALxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbiHALwY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:52:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F0141D31;
        Mon,  1 Aug 2022 04:49:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AB65612AB;
        Mon,  1 Aug 2022 11:49:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733CCC433C1;
        Mon,  1 Aug 2022 11:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354588;
        bh=syElmNdy7sQXbgh+vwp8MESXfii229x3m0DwxRR+DOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aYF+0rwuxR3XQUKafhR5eXP40nndU7ty2txv0G9znrhUUFZaAC6w8ym+K3/OoqSHp
         LJ9iWklWNzz4AhT12zb9Um9bCLYxfdD6iJ4eF2N9g0YOO48qGiW53nXlcUsPuPOGbV
         NrgPc3cXMiAkG64b9JPtJTyQuNFXkcOhyIu95udM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.10 15/65] ice: do not setup vlan for loopback VSI
Date:   Mon,  1 Aug 2022 13:46:32 +0200
Message-Id: <20220801114134.321409206@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
References: <20220801114133.641770326@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

commit cc019545a238518fa9da1e2a889f6e1bb1005a63 upstream.

Currently loopback test is failiing due to the error returned from
ice_vsi_vlan_setup(). Skip calling it when preparing loopback VSI.

Fixes: 0e674aeb0b77 ("ice: Add handler for ethtool selftest")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5203,10 +5203,12 @@ int ice_vsi_cfg(struct ice_vsi *vsi)
 	if (vsi->netdev) {
 		ice_set_rx_mode(vsi->netdev);
 
-		err = ice_vsi_vlan_setup(vsi);
+		if (vsi->type != ICE_VSI_LB) {
+			err = ice_vsi_vlan_setup(vsi);
 
-		if (err)
-			return err;
+			if (err)
+				return err;
+		}
 	}
 	ice_vsi_cfg_dcb_rings(vsi);
 


