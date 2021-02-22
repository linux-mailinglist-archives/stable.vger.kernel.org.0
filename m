Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 066F0321736
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbhBVMoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:44:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:52870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231289AbhBVMmg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:42:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D59364F2D;
        Mon, 22 Feb 2021 12:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997586;
        bh=vwY4oJVsAOPWacoX4pBi7QpzcbEii844hqLpg8lt2B0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZSLDJc7wcEynAnaOJKo2Sv7e0rYDDmoBQrLBVkheB52sd8w9TLk0P+nuWe7rPzEx+
         WAkwrLe5bx/AP8wQvuqmuWeXoYa/p03BxFwo+76SpwYH+HbKvnWFjso7Ca0Iu5YEtl
         CcoaMZ0mvKm0dfpVG+f2s2ZzOCJK1Hsl8asC5+8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 05/35] iwlwifi: mvm: guard against device removal in reprobe
Date:   Mon, 22 Feb 2021 13:36:01 +0100
Message-Id: <20210222121018.192525470@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121013.581198717@linuxfoundation.org>
References: <20210222121013.581198717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 7a21b1d4a728a483f07c638ccd8610d4b4f12684 ]

If we get into a problem severe enough to attempt a reprobe,
we schedule a worker to do that. However, if the problem gets
more severe and the device is actually destroyed before this
worker has a chance to run, we use a free device. Bump up the
reference count of the device until the worker runs to avoid
this situation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210122144849.871f0892e4b2.I94819e11afd68d875f3e242b98bef724b8236f1e@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 13c97f665ba88..bb81261de45fa 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -909,6 +909,7 @@ static void iwl_mvm_reprobe_wk(struct work_struct *wk)
 	reprobe = container_of(wk, struct iwl_mvm_reprobe, work);
 	if (device_reprobe(reprobe->dev))
 		dev_err(reprobe->dev, "reprobe failed!\n");
+	put_device(reprobe->dev);
 	kfree(reprobe);
 	module_put(THIS_MODULE);
 }
@@ -991,7 +992,7 @@ void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 			module_put(THIS_MODULE);
 			return;
 		}
-		reprobe->dev = mvm->trans->dev;
+		reprobe->dev = get_device(mvm->trans->dev);
 		INIT_WORK(&reprobe->work, iwl_mvm_reprobe_wk);
 		schedule_work(&reprobe->work);
 	} else if (mvm->cur_ucode == IWL_UCODE_REGULAR) {
-- 
2.27.0



