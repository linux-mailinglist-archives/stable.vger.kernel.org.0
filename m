Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1019C4F303E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242746AbiDEJiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236496AbiDEJDD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:03:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A34E2D1CC;
        Tue,  5 Apr 2022 01:54:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA5AA61476;
        Tue,  5 Apr 2022 08:54:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DC4C385A0;
        Tue,  5 Apr 2022 08:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148885;
        bh=U2ZJYOuEEz0m9/elS5Kj92JvO3TyzPU4Kk2kEKcCqqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wXTbrKAAfku7vvgMeHu1RTal5gY8bpw9Is9Vozaes80THRtZMhD1/KnbscJ6xToRl
         mBw4NE+SRzhPd+8dkmezDqCUaEZm8s7ihpzLvCN67gCt0scPUPGaN9V3qTXeVYBMoL
         Uw10qxlPY/HttRsPOFP4C2LeZTGfZdwHjG9+euB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0509/1017] iwlwifi: mvm: dont iterate unadded vifs when handling FW SMPS req
Date:   Tue,  5 Apr 2022 09:23:42 +0200
Message-Id: <20220405070409.409242075@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index 364f6aefae81..5b7d89e33431 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -237,7 +237,8 @@ static void iwl_mvm_rx_thermal_dual_chain_req(struct iwl_mvm *mvm,
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



