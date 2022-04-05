Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3797F4F377D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353051AbiDELNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349059AbiDEJtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3B3954B5;
        Tue,  5 Apr 2022 02:39:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FF67B81C14;
        Tue,  5 Apr 2022 09:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0219C385A1;
        Tue,  5 Apr 2022 09:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151570;
        bh=vFLGFY6Y2m6hnjaomhJJXAPRRbtKFLzx3D6TYfGQzDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D96o7GnKjnwvDpZSGlVfgfcFJrkTtnIh1nsF0sSS9INwO4bnnTelg/SRdFiVFDGS7
         I0IxHWkr/+qhFGa/bR6E3ReWwYiO9VWC2IHzPwsgzJ/LrfuCZ1wpCJgoqwHR4yOYev
         olKmbx3uRyUgrrK4k6j8f1G/NnPoOLgnC0J5igS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 464/913] iwlwifi: mvm: align locking in D3 test debugfs
Date:   Tue,  5 Apr 2022 09:25:26 +0200
Message-Id: <20220405070353.756715944@linuxfoundation.org>
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
index d3013a51a509..00ca17f3b263 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2499,7 +2499,9 @@ static int iwl_mvm_d3_test_open(struct inode *inode, struct file *file)
 
 	/* start pseudo D3 */
 	rtnl_lock();
+	wiphy_lock(mvm->hw->wiphy);
 	err = __iwl_mvm_suspend(mvm->hw, mvm->hw->wiphy->wowlan_config, true);
+	wiphy_unlock(mvm->hw->wiphy);
 	rtnl_unlock();
 	if (err > 0)
 		err = -EINVAL;
@@ -2555,7 +2557,9 @@ static int iwl_mvm_d3_test_release(struct inode *inode, struct file *file)
 	iwl_fw_dbg_read_d3_debug_data(&mvm->fwrt);
 
 	rtnl_lock();
+	wiphy_lock(mvm->hw->wiphy);
 	__iwl_mvm_resume(mvm, true);
+	wiphy_unlock(mvm->hw->wiphy);
 	rtnl_unlock();
 
 	iwl_mvm_resume_tcm(mvm);
-- 
2.34.1



