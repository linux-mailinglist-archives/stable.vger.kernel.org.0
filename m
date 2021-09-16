Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A798440E495
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242819AbhIPREq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:04:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:51090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245754AbhIPQ62 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:58:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DD046103C;
        Thu, 16 Sep 2021 16:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809908;
        bh=SyAxMhOp2pwQ74LlnnoLxvfi9WBzRJkbZSYLuemmFXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UVY7g+H/qX3Sd90tUg1BnY0rkgj16fAk1fu1tD2PS8U95jCg18dJ0N51Ulma/348a
         9/9BKxBQ2M4rJrQ+sehtSVzTdnQJD7+0HaqDWptrYDhKLgQU72SWYi0Phz4yxP6bgn
         26z4X/nwbHpxrJ3cB48EgEE+IKunwm3+CS30xxw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 328/380] iwlwifi: mvm: fix a memory leak in iwl_mvm_mac_ctxt_beacon_changed
Date:   Thu, 16 Sep 2021 18:01:25 +0200
Message-Id: <20210916155815.205514852@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 0f5d44ac6e55551798dd3da0ff847c8df5990822 ]

If beacon_inject_active is true, we will return without freeing
beacon.  Fid that by freeing it before returning.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
[reworded the commit message]
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210802172232.d16206ca60fc.I9984a9b442c84814c307cee3213044e24d26f38a@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index fd5e08961651..7f0c82189808 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1005,8 +1005,10 @@ int iwl_mvm_mac_ctxt_beacon_changed(struct iwl_mvm *mvm,
 		return -ENOMEM;
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-	if (mvm->beacon_inject_active)
+	if (mvm->beacon_inject_active) {
+		dev_kfree_skb(beacon);
 		return -EBUSY;
+	}
 #endif
 
 	ret = iwl_mvm_mac_ctxt_send_beacon(mvm, vif, beacon);
-- 
2.30.2



