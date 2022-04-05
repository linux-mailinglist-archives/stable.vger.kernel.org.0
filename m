Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7519B4F28D6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbiDEIXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236837AbiDEIRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:17:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222D8AF1C7;
        Tue,  5 Apr 2022 01:04:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F761617D4;
        Tue,  5 Apr 2022 08:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F492C385A0;
        Tue,  5 Apr 2022 08:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145866;
        bh=twxBK/6R6dVTxHmZ166iGr8sl7qWopCJphQL1m4A06A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z9NpW8LjDz3pcYIpmktpqJ+zVPRV9BPuLfhuv8tX3Gg70QvuwxUnpFLWmeFmAEh5C
         Qszt7zu60TInsFMAFO8NAhe35PinHvzKS3LuRve2lLurlhdL99xL9Kp9UUioQrDVJZ
         AVxNuHZT4G7Z6QoFHG1b0duiHSTdE5EqacXQKnFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0559/1126] iwlwifi: mvm: align locking in D3 test debugfs
Date:   Tue,  5 Apr 2022 09:21:46 +0200
Message-Id: <20220405070424.041684544@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 59e1221f470c2e5d2f2d4c95153edd577a7071c5 ]

Since commit a05829a7222e ("cfg80211: avoid holding the RTNL when
calling the driver") we're not only holding the RTNL when going
in and out of suspend, but also the wiphy->mtx. Add that to the
D3 test debugfs in iwlwifi since it's required for various calls
to mac80211.

Fixes: a05829a7222e ("cfg80211: avoid holding the RTNL when calling the driver")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: a05829a7222e ("cfg80211: avoid holding the RTNL when calling the driver")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20220129105618.fcec0204e162.Ib73bf787ab4d83581de20eb89b1f8dbfcaaad0e3@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index b400867e94f0..3f284836e707 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2704,7 +2704,9 @@ static int iwl_mvm_d3_test_open(struct inode *inode, struct file *file)
 
 	/* start pseudo D3 */
 	rtnl_lock();
+	wiphy_lock(mvm->hw->wiphy);
 	err = __iwl_mvm_suspend(mvm->hw, mvm->hw->wiphy->wowlan_config, true);
+	wiphy_unlock(mvm->hw->wiphy);
 	rtnl_unlock();
 	if (err > 0)
 		err = -EINVAL;
@@ -2760,7 +2762,9 @@ static int iwl_mvm_d3_test_release(struct inode *inode, struct file *file)
 	iwl_fw_dbg_read_d3_debug_data(&mvm->fwrt);
 
 	rtnl_lock();
+	wiphy_lock(mvm->hw->wiphy);
 	__iwl_mvm_resume(mvm, true);
+	wiphy_unlock(mvm->hw->wiphy);
 	rtnl_unlock();
 
 	iwl_mvm_resume_tcm(mvm);
-- 
2.34.1



