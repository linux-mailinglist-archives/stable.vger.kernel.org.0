Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 675326D46EE
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbjDCOPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbjDCOPf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:15:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5D52C9E5
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:15:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F6C461CC1
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52835C4339B;
        Mon,  3 Apr 2023 14:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531323;
        bh=xoYnR4n68PX8w5dMyu+b2oRPsBIZKfQ3h8fN8Vh8khc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wnnNz+wOnIOQsn742FFvgw3U1Z1xRSoaJMn6UzmPctpgT4m+J2YnR5HjsmdNgIhsy
         1N2fYL+iLXS65rdlbkjZZAmQxOYYdRYaKeEvdnRZfV4Mu1xomfJ9bMl2y6j90gOfy1
         ngo82aMmkfFugivZXIbCE2wXh+ddzei3iwzz8ze4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Pawe=C5=82=20Jab=C5=82o=C5=84ski?= 
        <pawel.jablonski@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 02/84] i40evf: Change a VF mac without reloading the VF driver
Date:   Mon,  3 Apr 2023 16:08:03 +0200
Message-Id: <20230403140353.493716936@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paweł Jabłoński <pawel.jablonski@intel.com>

[ Upstream commit ae1e29f671b467f3e9e9aa2b82ee40e4300ea810 ]

Add possibility to change a VF mac address from host side
without reloading the VF driver on the guest side. Without
this patch it is not possible to change the VF mac because
executing i40evf_virtchnl_completion function with
VIRTCHNL_OP_GET_VF_RESOURCES opcode resets the VF mac
address to previous value.

Signed-off-by: Paweł Jabłoński <pawel.jablonski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Stable-dep-of: 32d57f667f87 ("iavf: fix inverted Rx hash condition leading to disabled hash")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c  |  8 +++++---
 drivers/net/ethernet/intel/i40evf/i40evf_virtchnl.c | 11 +++++++++--
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 240083201dbf4..1527c67b487b2 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2595,7 +2595,7 @@ static inline int i40e_check_vf_permission(struct i40e_vf *vf,
 		    !is_multicast_ether_addr(addr) && vf->pf_set_mac &&
 		    !ether_addr_equal(addr, vf->default_lan_addr.addr)) {
 			dev_err(&pf->pdev->dev,
-				"VF attempting to override administratively set MAC address, reload the VF driver to resume normal operation\n");
+				"VF attempting to override administratively set MAC address, bring down and up the VF interface to resume normal operation\n");
 			return -EPERM;
 		}
 	}
@@ -4019,9 +4019,11 @@ int i40e_ndo_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 			 mac, vf_id);
 	}
 
-	/* Force the VF driver stop so it has to reload with new MAC address */
+	/* Force the VF interface down so it has to bring up with new MAC
+	 * address
+	 */
 	i40e_vc_disable_vf(vf);
-	dev_info(&pf->pdev->dev, "Reload the VF driver to make this change effective.\n");
+	dev_info(&pf->pdev->dev, "Bring down and up the VF interface to make this change effective.\n");
 
 error_param:
 	return ret;
diff --git a/drivers/net/ethernet/intel/i40evf/i40evf_virtchnl.c b/drivers/net/ethernet/intel/i40evf/i40evf_virtchnl.c
index 94dabc9d89f73..6579dabab78cf 100644
--- a/drivers/net/ethernet/intel/i40evf/i40evf_virtchnl.c
+++ b/drivers/net/ethernet/intel/i40evf/i40evf_virtchnl.c
@@ -1362,8 +1362,15 @@ void i40evf_virtchnl_completion(struct i40evf_adapter *adapter,
 		memcpy(adapter->vf_res, msg, min(msglen, len));
 		i40evf_validate_num_queues(adapter);
 		i40e_vf_parse_hw_config(&adapter->hw, adapter->vf_res);
-		/* restore current mac address */
-		ether_addr_copy(adapter->hw.mac.addr, netdev->dev_addr);
+		if (is_zero_ether_addr(adapter->hw.mac.addr)) {
+			/* restore current mac address */
+			ether_addr_copy(adapter->hw.mac.addr, netdev->dev_addr);
+		} else {
+			/* refresh current mac address if changed */
+			ether_addr_copy(netdev->dev_addr, adapter->hw.mac.addr);
+			ether_addr_copy(netdev->perm_addr,
+					adapter->hw.mac.addr);
+		}
 		i40evf_process_config(adapter);
 		}
 		break;
-- 
2.39.2



