Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C630B4F3772
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352968AbiDELNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349058AbiDEJtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3885FA94EF;
        Tue,  5 Apr 2022 02:39:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7E0F61368;
        Tue,  5 Apr 2022 09:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3836C385A2;
        Tue,  5 Apr 2022 09:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151567;
        bh=SWnPec7Zwl4H05NnprqEXu/B97MmpNcASNuRbqfMQ4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mefo5UDr2Hm/jxAgwct6SEWgmEddaJf7uqU3/DjDAHjZXB+EwVCWlWRj6iZeNgqV6
         6WLnT0w9hR+E2bXFjaqIamSEzduAJwZpOIubX0sEPB9jJKM/p70yurHbKHUtlHuM31
         NUsaLYkTj1jd0J1hjeBDAVFUCbN2shTeSZ1TnH3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 463/913] iwlwifi: mvm: dont iterate unadded vifs when handling FW SMPS req
Date:   Tue,  5 Apr 2022 09:25:25 +0200
Message-Id: <20220405070353.727258366@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit 8a265d1a619c16400406c9d598411850ee104aed ]

We may not have all the interfaces added to the driver when we get the
THERMAL_DUAL_CHAIN_REQUEST notification from the FW, so instead of
iterating all vifs to update SMPS, iterate only the ones that are
already assigned.  The interfaces that were not assigned yet, will be
updated accordingly when we start using them.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Fixes: 2a7ce54ccc23 ("iwlwifi: mvm: honour firmware SMPS requests")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20220129105618.9416aade2ba0.I0b71142f89e3f158aa058a1dfb2517c8c1fa3726@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 49c32a8132a0..c77d98c88811 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -238,7 +238,8 @@ static void iwl_mvm_rx_thermal_dual_chain_req(struct iwl_mvm *mvm,
 	 */
 	mvm->fw_static_smps_request =
 		req->event == cpu_to_le32(THERMAL_DUAL_CHAIN_REQ_DISABLE);
-	ieee80211_iterate_interfaces(mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
+	ieee80211_iterate_interfaces(mvm->hw,
+				     IEEE80211_IFACE_SKIP_SDATA_NOT_IN_DRIVER,
 				     iwl_mvm_intf_dual_chain_req, NULL);
 }
 
-- 
2.34.1



