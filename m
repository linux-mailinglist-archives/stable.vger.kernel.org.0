Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39657586A1A
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbiHAMMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234661AbiHAMLl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:11:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7576FA32;
        Mon,  1 Aug 2022 04:57:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89E58B81170;
        Mon,  1 Aug 2022 11:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E590BC433D6;
        Mon,  1 Aug 2022 11:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355022;
        bh=KwPQhO7TU6/iLNAcx6NoF3WPVIN8mKMpEzoii8Yvj9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RxCTwdbFK56CjkPJpEojQnjs7nEO8Zn66kbwGc/CJJR6jycjU1KPKxFcoSFkeBL/7
         agHz4Qlg57j3aDemAZsmyME9kHJDyjPABJ+Al+VYIStrmNo/I7HW6qEaHv6BHYl4Gm
         IDV44cGl591tTmkXia2j4GpUnS1cdQa1Og4bX+Wo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.18 27/88] ice: Fix max VLANs available for VF
Date:   Mon,  1 Aug 2022 13:46:41 +0200
Message-Id: <20220801114139.265301380@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
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

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

commit 1e308c6fb7127371f48a0fb9770ea0b30a6b5698 upstream.

Legacy VLAN implementation allows for untrusted VF to have 8 VLAN
filters, not counting VLAN 0 filters. Current VLAN_V2 implementation
lowers available filters for VF, by counting in VLAN 0 filter for both
TPIDs.
Fix this by counting only non zero VLAN filters.
Without this patch, untrusted VF would not be able to access 8 VLAN
filters.

Fixes: cc71de8fa133 ("ice: Add support for VIRTCHNL_VF_OFFLOAD_VLAN_V2")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -2966,7 +2966,8 @@ ice_vc_validate_add_vlan_filter_list(str
 				     struct virtchnl_vlan_filtering_caps *vfc,
 				     struct virtchnl_vlan_filter_list_v2 *vfl)
 {
-	u16 num_requested_filters = vsi->num_vlan + vfl->num_elements;
+	u16 num_requested_filters = ice_vsi_num_non_zero_vlans(vsi) +
+		vfl->num_elements;
 
 	if (num_requested_filters > vfc->max_filters)
 		return false;


