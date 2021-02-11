Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74DD318E58
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhBKPYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:24:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:52626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229700AbhBKPUg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:20:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6230964F26;
        Thu, 11 Feb 2021 15:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613056004;
        bh=a7cpqNj4McTknLDLJ6IE1wMgM7KtFiLedfkTpgs8aEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gVHdzKiD7k/z2zenx5H6f9IV8e+1SGfHCZArt/o7vibnJmIbSDq3ZOQi2oS3Sbnf1
         0N5lT7Zr7zcZy0T+EoNs//sGY+yNv2KFdoqn6OTImINKZAo9xenqub6p3aG4GS3LP5
         JQC+ke60evDiDJGRosjRPdX9iEv6kFfZzGwk6RZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/24] iwlwifi: mvm: guard against device removal in reprobe
Date:   Thu, 11 Feb 2021 16:02:47 +0100
Message-Id: <20210211150148.335575799@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150147.743660073@linuxfoundation.org>
References: <20210211150147.743660073@linuxfoundation.org>
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
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 0e26619fb330b..d932171617e6a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1192,6 +1192,7 @@ static void iwl_mvm_reprobe_wk(struct work_struct *wk)
 	reprobe = container_of(wk, struct iwl_mvm_reprobe, work);
 	if (device_reprobe(reprobe->dev))
 		dev_err(reprobe->dev, "reprobe failed!\n");
+	put_device(reprobe->dev);
 	kfree(reprobe);
 	module_put(THIS_MODULE);
 }
@@ -1242,7 +1243,7 @@ void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 			module_put(THIS_MODULE);
 			return;
 		}
-		reprobe->dev = mvm->trans->dev;
+		reprobe->dev = get_device(mvm->trans->dev);
 		INIT_WORK(&reprobe->work, iwl_mvm_reprobe_wk);
 		schedule_work(&reprobe->work);
 	} else if (mvm->fwrt.cur_fw_img == IWL_UCODE_REGULAR &&
-- 
2.27.0



