Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC63056FBF9
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbiGKJhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232956AbiGKJg4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:36:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E576B1263D;
        Mon, 11 Jul 2022 02:19:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93F47B80833;
        Mon, 11 Jul 2022 09:19:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F225BC34115;
        Mon, 11 Jul 2022 09:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531150;
        bh=SbQjTmkrJEcRV6QDAy0fMtAN5mBYr4UruzKauaQHEWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hnWobTUqrpUNoh4yIc7ZOAH1Csn45+4icUWx7/pwYtD9ozeufpTWafkPfdBz9n0FD
         0QhYJ3YMKAs7l7gGWPUuomtIvpUn0RsDLEtwOZdtNcHgVGZi6VX45DHvROjELsQfFH
         axJFG08r/krb4NEnre+BoNRNuoZ3Jl6t/9rl05Ho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Norbert Zulinski <norbertx.zulinski@intel.com>,
        Jan Sokolowski <jan.sokolowski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 079/112] i40e: Fix VFs MAC Address change on VM
Date:   Mon, 11 Jul 2022 11:07:19 +0200
Message-Id: <20220711090551.814223026@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Norbert Zulinski <norbertx.zulinski@intel.com>

[ Upstream commit fed0d9f13266a22ce1fc9a97521ef9cdc6271a23 ]

Clear VF MAC from parent PF and remove VF filter from VSI when both
conditions are true:
-VIRTCHNL_VF_OFFLOAD_USO is not used
-VM MAC was not set from PF level

It affects older version of IAVF and it allow them to change MAC
Address on VM, newer IAVF won't change their behaviour.

Previously it wasn't possible to change VF's MAC Address on VM
because there is flag on IAVF driver that won't allow to
change MAC Address if this address is given from PF driver.

Fixes: 155f0ac2c96b ("iavf: allow permanent MAC address to change")
Signed-off-by: Norbert Zulinski <norbertx.zulinski@intel.com>
Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 033ea71763e3..86b0f21287dc 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2147,6 +2147,10 @@ static int i40e_vc_get_vf_resources_msg(struct i40e_vf *vf, u8 *msg)
 		/* VFs only use TC 0 */
 		vfres->vsi_res[0].qset_handle
 					  = le16_to_cpu(vsi->info.qs_handle[0]);
+		if (!(vf->driver_caps & VIRTCHNL_VF_OFFLOAD_USO) && !vf->pf_set_mac) {
+			i40e_del_mac_filter(vsi, vf->default_lan_addr.addr);
+			eth_zero_addr(vf->default_lan_addr.addr);
+		}
 		ether_addr_copy(vfres->vsi_res[0].default_mac_addr,
 				vf->default_lan_addr.addr);
 	}
-- 
2.35.1



