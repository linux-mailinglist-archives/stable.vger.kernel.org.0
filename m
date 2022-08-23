Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAF159D603
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241000AbiHWJGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347712AbiHWJFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:05:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BEC84EC0;
        Tue, 23 Aug 2022 01:29:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43ABD61499;
        Tue, 23 Aug 2022 08:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CFEC433D6;
        Tue, 23 Aug 2022 08:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243273;
        bh=JzwUZcD7jNCJYY/ChR+2ByndPEgmimdsvcQdGqDEtNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pe9tmdIfDYuQpEtX503QJwywUU5kChivFghzWonYBEeD63b7FZ8PxuI6wGXyngwJc
         Pl6DuQMqOLJxpo2/nYDVDK63oZEq7K2ngAGXWu0mSClKfdJ3uYeCHGcFohIQMdgE9z
         4LJzr7Qayxu2fTFHElk2wbModkkr6JeSzO7QN9WM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Grzegorz Siwik <grzegorz.siwik@intel.com>,
        Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>,
        Igor Raits <igor@gooddata.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 5.19 224/365] ice: Fix double VLAN error when entering promisc mode
Date:   Tue, 23 Aug 2022 10:02:05 +0200
Message-Id: <20220823080127.569797517@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Grzegorz Siwik <grzegorz.siwik@intel.com>

commit ffa9ed86522f1c08d4face4e0a4ebf366037bf19 upstream.

Avoid enabling or disabling VLAN 0 when trying to set promiscuous
VLAN mode if double VLAN mode is enabled. This fix is needed
because the driver tries to add the VLAN 0 filter twice (once for
inner and once for outer) when double VLAN mode is enabled. The
filter program is rejected by the firmware when double VLAN is
enabled, because the promiscuous filter only needs to be set once.

This issue was missed in the initial implementation of double VLAN
mode.

Fixes: 5eda8afd6bcc ("ice: Add support for PF/VF promiscuous mode")
Signed-off-by: Grzegorz Siwik <grzegorz.siwik@intel.com>
Link: https://lore.kernel.org/all/CAK8fFZ7m-KR57M_rYX6xZN39K89O=LGooYkKsu6HKt0Bs+x6xQ@mail.gmail.com/
Tested-by: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Tested-by: Igor Raits <igor@gooddata.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_switch.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -4414,6 +4414,13 @@ ice_set_vlan_vsi_promisc(struct ice_hw *
 		goto free_fltr_list;
 
 	list_for_each_entry(list_itr, &vsi_list_head, list_entry) {
+		/* Avoid enabling or disabling VLAN zero twice when in double
+		 * VLAN mode
+		 */
+		if (ice_is_dvm_ena(hw) &&
+		    list_itr->fltr_info.l_data.vlan.tpid == 0)
+			continue;
+
 		vlan_id = list_itr->fltr_info.l_data.vlan.vlan_id;
 		if (rm_vlan_promisc)
 			status = ice_clear_vsi_promisc(hw, vsi_handle,


