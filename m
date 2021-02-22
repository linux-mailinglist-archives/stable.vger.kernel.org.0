Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9368232176B
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbhBVMrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:47:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:56578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231639AbhBVMny (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:43:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4552D64DF0;
        Mon, 22 Feb 2021 12:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997654;
        bh=jCyPvmj/VHxcGkWl8CNXFkUNCSiy3nQSDgNHVBoMCJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gD5og0omF8MHNbnhlPcZ6zYkf7NG85CNQJ26vOb2m2WaEhKb/JBZBJESe7zCBBt9v
         azByQuQT/m+97AKYm+IwBY4Zkof6ZcXSvmfJ42d7a3MQiVdMHdI1AL2k0/3gJ5m+GS
         3GW+fKULmRw6JETrg5cxHU3Xos4VNUjzDRjzNidE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 05/49] iwlwifi: mvm: take mutex for calling iwl_mvm_get_sync_time()
Date:   Mon, 22 Feb 2021 13:36:03 +0100
Message-Id: <20210222121024.207916459@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121022.546148341@linuxfoundation.org>
References: <20210222121022.546148341@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 5c56d862c749669d45c256f581eac4244be00d4d ]

We need to take the mutex to call iwl_mvm_get_sync_time(), do it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210115130252.4bb5ccf881a6.I62973cbb081e80aa5b0447a5c3b9c3251a65cf6b@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
index f4d75ffe3d8a8..7f01fb91ea668 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -518,7 +518,10 @@ static ssize_t iwl_dbgfs_os_device_timediff_read(struct file *file,
 	const size_t bufsz = sizeof(buf);
 	int pos = 0;
 
+	mutex_lock(&mvm->mutex);
 	iwl_mvm_get_sync_time(mvm, &curr_gp2, &curr_os);
+	mutex_unlock(&mvm->mutex);
+
 	do_div(curr_os, NSEC_PER_USEC);
 	diff = curr_os - curr_gp2;
 	pos += scnprintf(buf + pos, bufsz - pos, "diff=%lld\n", diff);
-- 
2.27.0



