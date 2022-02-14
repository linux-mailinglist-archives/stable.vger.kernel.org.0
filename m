Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE11D4B4BF2
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348309AbiBNKfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:35:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348320AbiBNKes (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:34:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DAEE22;
        Mon, 14 Feb 2022 02:01:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5999EB80D6D;
        Mon, 14 Feb 2022 10:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E90CC340F0;
        Mon, 14 Feb 2022 10:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832893;
        bh=CZc73YvIudVlmaabKNEr9mCZRnN0qITgpADm3Omyavk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qssJumIX6xDNef2AuteVgpHq9OVcDm+N9aUqwocGXE7guWoJvKtwqfFuwiApT/6dO
         fFjlaJx/mhf+lZ5xZh4jLuPVdsh1ZOCoe2T4adgplORzrZ67/SnkjxHGkHT/KgvpHO
         4Q7iAiOQFf14eHITWl/uj9vcA+AfDX44vCHn+6nY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Ertman <david.m.ertman@intel.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Gurucharan G <gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 159/203] ice: Avoid RTNL lock when re-creating auxiliary device
Date:   Mon, 14 Feb 2022 10:26:43 +0100
Message-Id: <20220214092515.644027305@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

[ Upstream commit 5dbbbd01cbba831233c6ea9a3e6bfa133606d3c0 ]

If a call to re-create the auxiliary device happens in a context that has
already taken the RTNL lock, then the call flow that recreates auxiliary
device can hang if there is another attempt to claim the RTNL lock by the
auxiliary driver.

To avoid this, any call to re-create auxiliary devices that comes from
an source that is holding the RTNL lock (e.g. netdev notifier when
interface exits a bond) should execute in a separate thread.  To
accomplish this, add a flag to the PF that will be evaluated in the
service task and dealt with there.

Fixes: f9f5301e7e2d ("ice: Register auxiliary device to provide RDMA")
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Reviewed-by: Jonathan Toppins <jtoppins@redhat.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice.h      | 3 ++-
 drivers/net/ethernet/intel/ice/ice_main.c | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index b2db39ee5f85c..b3e1fc6a0a8eb 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -483,6 +483,7 @@ enum ice_pf_flags {
 	ICE_FLAG_VF_TRUE_PROMISC_ENA,
 	ICE_FLAG_MDD_AUTO_RESET_VF,
 	ICE_FLAG_LINK_LENIENT_MODE_ENA,
+	ICE_FLAG_PLUG_AUX_DEV,
 	ICE_PF_FLAGS_NBITS		/* must be last */
 };
 
@@ -880,7 +881,7 @@ static inline void ice_set_rdma_cap(struct ice_pf *pf)
 	if (pf->hw.func_caps.common_cap.rdma && pf->num_rdma_msix) {
 		set_bit(ICE_FLAG_RDMA_ENA, pf->flags);
 		set_bit(ICE_FLAG_AUX_ENA, pf->flags);
-		ice_plug_aux_dev(pf);
+		set_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags);
 	}
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 68d3de6d42218..5b4be432b60ce 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2235,6 +2235,9 @@ static void ice_service_task(struct work_struct *work)
 		return;
 	}
 
+	if (test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
+		ice_plug_aux_dev(pf);
+
 	ice_clean_adminq_subtask(pf);
 	ice_check_media_subtask(pf);
 	ice_check_for_hang_subtask(pf);
-- 
2.34.1



