Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536234C48C2
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 16:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240204AbiBYPZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 10:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242030AbiBYPZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 10:25:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AB01D06F8
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 07:25:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DAC461532
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 15:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC21C340F1;
        Fri, 25 Feb 2022 15:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645802713;
        bh=50ITuOGgdGA7SCk0X0J9yw06+XtJF1/64teXajmc8FE=;
        h=Subject:To:Cc:From:Date:From;
        b=mRLGBzIAAE0zgwreQkQtz4WZTmimaZyKJj/Gqa/f5dDhZq5ckbfMH9amszTrkerNU
         TzZUFkTYY7uDoW+o6XLvelJjcDoeQ7t72G0ND57DgZLr2hX5ZJJJcghrToORWKl7EL
         QHB7Aspv3nXQ4JSg6GLBH/K3s0/KP9KzoDK9mjjY=
Subject: FAILED: patch "[PATCH] ice: initialize local variable 'tlv'" failed to apply to 5.10-stable tree
To:     trix@redhat.com, anthony.l.nguyen@intel.com,
        gurucharanx.g@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Feb 2022 16:25:10 +0100
Message-ID: <164580271018249@kroah.com>
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

From 5950bdc88dd1d158f2845fdff8fb1de86476806c Mon Sep 17 00:00:00 2001
From: Tom Rix <trix@redhat.com>
Date: Mon, 14 Feb 2022 07:40:43 -0800
Subject: [PATCH] ice: initialize local variable 'tlv'

Clang static analysis reports this issues
ice_common.c:5008:21: warning: The left expression of the compound
  assignment is an uninitialized value. The computed value will
  also be garbage
  ldo->phy_type_low |= ((u64)buf << (i * 16));
  ~~~~~~~~~~~~~~~~~ ^

When called from ice_cfg_phy_fec() ldo is the uninitialized local
variable tlv.  So initialize.

Fixes: ea78ce4dab05 ("ice: add link lenient and default override support")
Signed-off-by: Tom Rix <trix@redhat.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index a6d7d3eff186..e2af99a763ed 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3340,7 +3340,7 @@ ice_cfg_phy_fec(struct ice_port_info *pi, struct ice_aqc_set_phy_cfg_data *cfg,
 
 	if (fec == ICE_FEC_AUTO && ice_fw_supports_link_override(hw) &&
 	    !ice_fw_supports_report_dflt_cfg(hw)) {
-		struct ice_link_default_override_tlv tlv;
+		struct ice_link_default_override_tlv tlv = { 0 };
 
 		status = ice_get_link_default_override(&tlv, pi);
 		if (status)

