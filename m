Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF5255DC87
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238097AbiF0LuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238489AbiF0Lsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDCABF70;
        Mon, 27 Jun 2022 04:41:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74CCD61150;
        Mon, 27 Jun 2022 11:41:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80AE2C3411D;
        Mon, 27 Jun 2022 11:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330112;
        bh=n9FZEQIgD8MigI+6BcU6gJN+cGDBxUZmCA6J21ivfb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qbacEoRUNtIrWQrekkHBDbZdxuaKx1pGSspR5UxjjSF8/swTKdT2nzdGotihJlX0b
         XcJhzMjHvDhtJYbI8cBRPpmlTcAJVCCFkgDSqtjeVxmUo/Q1tQzS4tp7wCoy8UCe2L
         /39GMnHyM2wEDdw9O2iCRQ19ue2NtaMUXlzf0g/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Wojciech Drewek <wojciech.drewek@intel.com>,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 086/181] ice: Fix switchdev rules book keeping
Date:   Mon, 27 Jun 2022 13:20:59 +0200
Message-Id: <20220627111947.053547619@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>

[ Upstream commit 3578dc90013b1fa20da996cdadd8515802716132 ]

Adding two filters with same matching criteria ends up with
one rule in hardware with act = ICE_FWD_TO_VSI_LIST.
In order to remove them properly we have to keep the
information about vsi handle which is used in VSI bitmap
(ice_adv_fltr_mgmt_list_entry::vsi_list_info::vsi_map).

Fixes: 0d08a441fb1a ("ice: ndo_setup_tc implementation for PF")
Reported-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index 734bfa121e24..2ce2694fcbd7 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -524,6 +524,7 @@ ice_eswitch_add_tc_fltr(struct ice_vsi *vsi, struct ice_tc_flower_fltr *fltr)
 	 */
 	fltr->rid = rule_added.rid;
 	fltr->rule_id = rule_added.rule_id;
+	fltr->dest_id = rule_added.vsi_handle;
 
 exit:
 	kfree(list);
-- 
2.35.1



