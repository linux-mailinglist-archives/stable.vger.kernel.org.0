Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8EF656FDF6
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbiGKKCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234454AbiGKKCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 06:02:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680529593;
        Mon, 11 Jul 2022 02:28:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F20AAB80E6D;
        Mon, 11 Jul 2022 09:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E045C34115;
        Mon, 11 Jul 2022 09:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531720;
        bh=USo+M3DHAhHc2pbi1o05Z2x2BwKbfW9LYqYjyf340dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yqs249eQu6FiIRg0Yhok7F8tSTNPRVNf8Gy/PnVKnQrFRgEJ9sHiuA+cyVghsLmp4
         awc7Uj7sB5JQTZUQobzB4QMWKhmmUxGKUouVVw0vERRJxG6aBWpRWU9myh6Q3WgOC6
         gHl6i6n6yc4pHBqhKKeyoXf/C0CL9uqOzyGctWtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Norbert Zulinski <norbertx.zulinski@intel.com>,
        Jan Sokolowski <jan.sokolowski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 206/230] i40e: Fix VFs MAC Address change on VM
Date:   Mon, 11 Jul 2022 11:07:42 +0200
Message-Id: <20220711090609.948014233@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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
index 6c1e668f4ebf..d78ac5e7f658 100644
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



