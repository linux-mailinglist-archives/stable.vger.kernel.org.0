Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082F259C032
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 15:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234771AbiHVNIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 09:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235019AbiHVNIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 09:08:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C34313FA0
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 06:08:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AEE51CE12B3
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 13:08:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9F4C433D6;
        Mon, 22 Aug 2022 13:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661173719;
        bh=d3tUqq0w89qyRs59Q7Jk7eaJ0kG8JfN/eYJAKyCxvII=;
        h=Subject:To:Cc:From:Date:From;
        b=napa9m7KiuksuwJpOtrybAFRkFSpNWH1mEH6qPmQt4rR+SY5STZa6+JHjC46LToth
         JkxxsbVm2PMW9TddF+MKH314yHjOAxw6ZT+XozPE73X3Nng7FEJ9B9HJrQIZvAUW2n
         dZ/gW8rrCQMGJBBeFpM1jxQqAygYZ84TPnZAI4yU=
Subject: FAILED: patch "[PATCH] ice: Fix double VLAN error when entering promisc mode" failed to apply to 5.10-stable tree
To:     grzegorz.siwik@intel.com, anthony.l.nguyen@intel.com,
        gurucharanx.g@intel.com, igor@gooddata.com,
        jaroslav.pulchart@gooddata.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 15:08:36 +0200
Message-ID: <1661173716200237@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ffa9ed86522f1c08d4face4e0a4ebf366037bf19 Mon Sep 17 00:00:00 2001
From: Grzegorz Siwik <grzegorz.siwik@intel.com>
Date: Fri, 12 Aug 2022 15:25:47 +0200
Subject: [PATCH] ice: Fix double VLAN error when entering promisc mode

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

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 262e553e3b58..0c265739cce2 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -4445,6 +4445,13 @@ ice_set_vlan_vsi_promisc(struct ice_hw *hw, u16 vsi_handle, u8 promisc_mask,
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

