Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59843469F14
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391352AbhLFPpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390512AbhLFPm2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273E9C08ED03;
        Mon,  6 Dec 2021 07:27:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD2A8B8111C;
        Mon,  6 Dec 2021 15:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32AACC34901;
        Mon,  6 Dec 2021 15:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804422;
        bh=t/pttRSCweMqeOKweAPdtOa5THVRVa0S7pIBTkKQpME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1dkNHKyvQxTxw1BJ2M/cuJ1a2eU1uluFs4DalydD/dMGS4Xn5I5P/XzqdmXV6Xina
         Gi/5Q0xMYbHHV/RdoO0q9KMwq0t1c3wd3vVUv4YpPcXbjqVxJFJGWH2WyXsp7v6WXi
         C6RfvUf2BSDHNJtDa+In305uUhOYj48lckrO9j30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=C5=81ukasz=20Bartosik?= <lb@semihalf.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.15 109/207] iwlwifi: fix warnings produced by kernel debug options
Date:   Mon,  6 Dec 2021 15:56:03 +0100
Message-Id: <20211206145614.016974504@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Łukasz Bartosik <lb@semihalf.com>

commit f5cecf1d4c5ff76172928bc32e99ca56a5ca2f56 upstream.

Fix warnings produced by:
- lockdep_assert_wiphy() in function reg_process_self_managed_hint(),
- wiphy_dereference() in function iwl_mvm_init_fw_regd().
Both function are expected to be called in critical section.

The warnings were discovered when running v5.15 kernel
with debug options enabled:

1)
Hardware name: Google Delbin/Delbin
RIP: 0010:reg_process_self_managed_hint+0x254/0x347 [cfg80211]
...
Call Trace:
regulatory_set_wiphy_regd_sync+0x3d/0xb0
iwl_mvm_init_mcc+0x49d/0x5a2
iwl_op_mode_mvm_start+0x1b58/0x2507
? iwl_mvm_reprobe_wk+0x94/0x94
_iwl_op_mode_start+0x146/0x1a3
iwl_opmode_register+0xda/0x13d
init_module+0x28/0x1000

2)
drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c:263 suspicious rcu_dereference_protected() usage!
...
Hardware name: Google Delbin/Delbin, BIOS Google_Delbin
Call Trace:
dump_stack_lvl+0xb1/0xe6
iwl_mvm_init_fw_regd+0x2e7/0x379
iwl_mvm_init_mcc+0x2c6/0x5a2
iwl_op_mode_mvm_start+0x1b58/0x2507
? iwl_mvm_reprobe_wk+0x94/0x94
_iwl_op_mode_start+0x146/0x1a3
iwl_opmode_register+0xda/0x13d
init_module+0x28/0x100

Fixes: a05829a7222e ("cfg80211: avoid holding the RTNL when calling the driver")
Signed-off-by: Łukasz Bartosik <lb@semihalf.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211110215744.5487-1-lukasz.bartosik@semihalf.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -687,6 +687,7 @@ static int iwl_mvm_start_get_nvm(struct
 	int ret;
 
 	rtnl_lock();
+	wiphy_lock(mvm->hw->wiphy);
 	mutex_lock(&mvm->mutex);
 
 	ret = iwl_run_init_mvm_ucode(mvm);
@@ -702,6 +703,7 @@ static int iwl_mvm_start_get_nvm(struct
 		iwl_mvm_stop_device(mvm);
 
 	mutex_unlock(&mvm->mutex);
+	wiphy_unlock(mvm->hw->wiphy);
 	rtnl_unlock();
 
 	if (ret < 0)


