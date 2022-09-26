Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4F165EA0DA
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236248AbiIZKm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236255AbiIZKk7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:40:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D6A4D4CD;
        Mon, 26 Sep 2022 03:24:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA69960B5E;
        Mon, 26 Sep 2022 10:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCA4C433C1;
        Mon, 26 Sep 2022 10:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187845;
        bh=wnuHQaDecdsgn7LCuASgdHmwxkjgrjE5924QvXbP/6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mrNj3gSXIuOkmPhcYQVML6hQJF4MqkVmxLkL2nsRIl63GRcKyk1XxfqAaeJ1vreU+
         8ZRpDj/EuyRjp24LdKl0RQXPyWH6jGOOymEekAJbpiRQfTR0vyenAcSjPXWjLFrA+g
         64JxUvKUrY7KkRoIm8R1D++gk6fi6t8fNg5MVZzo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Jaron <michalx.jaron@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/120] i40e: Fix VF set max MTU size
Date:   Mon, 26 Sep 2022 12:11:52 +0200
Message-Id: <20220926100753.917494339@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Jaron <michalx.jaron@intel.com>

[ Upstream commit 372539def2824c43b6afe2403045b140f65c5acc ]

Max MTU sent to VF is set to 0 during memory allocation. It cause
that max MTU on VF is changed to IAVF_MAX_RXBUFFER and does not
depend on data from HW.

Set max_mtu field in virtchnl_vf_resource struct to inform
VF in GET_VF_RESOURCES msg what size should be max frame.

Fixes: dab86afdbbd1 ("i40e/i40evf: Change the way we limit the maximum frame size for Rx")
Signed-off-by: Michal Jaron <michalx.jaron@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 4080fdacca4c..16f5baafbbd5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1873,6 +1873,25 @@ static void i40e_del_qch(struct i40e_vf *vf)
 	}
 }
 
+/**
+ * i40e_vc_get_max_frame_size
+ * @vf: pointer to the VF
+ *
+ * Max frame size is determined based on the current port's max frame size and
+ * whether a port VLAN is configured on this VF. The VF is not aware whether
+ * it's in a port VLAN so the PF needs to account for this in max frame size
+ * checks and sending the max frame size to the VF.
+ **/
+static u16 i40e_vc_get_max_frame_size(struct i40e_vf *vf)
+{
+	u16 max_frame_size = vf->pf->hw.phy.link_info.max_frame_size;
+
+	if (vf->port_vlan_id)
+		max_frame_size -= VLAN_HLEN;
+
+	return max_frame_size;
+}
+
 /**
  * i40e_vc_get_vf_resources_msg
  * @vf: pointer to the VF info
@@ -1973,6 +1992,7 @@ static int i40e_vc_get_vf_resources_msg(struct i40e_vf *vf, u8 *msg)
 	vfres->max_vectors = pf->hw.func_caps.num_msix_vectors_vf;
 	vfres->rss_key_size = I40E_HKEY_ARRAY_SIZE;
 	vfres->rss_lut_size = I40E_VF_HLUT_ARRAY_SIZE;
+	vfres->max_mtu = i40e_vc_get_max_frame_size(vf);
 
 	if (vf->lan_vsi_idx) {
 		vfres->vsi_res[0].vsi_id = vf->lan_vsi_id;
-- 
2.35.1



