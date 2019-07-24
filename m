Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1B873E82
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389908AbfGXTjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:39:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389300AbfGXTjW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:39:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2B7F22ADB;
        Wed, 24 Jul 2019 19:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997162;
        bh=CPNZ+QSf1n22rncsUpD/LvnhCTo6fBi49pfftRYaJgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iS9zQjSF0fVwSE/OVa8N2eQtNYewqYNjsU9ixzSLjcGc1dfpNUfcn55NYPLylqElj
         7OoevIWcQW2LgNwK6++chWDIiYLxIpzkebngHlmwCNPq3dzUUFSMC2jD67nvQyIB7C
         zgSXPcbTnsdZo/MpUdmZbv2VuUmXdD8wIYiOPSnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 5.2 300/413] iwlwifi: mvm: clear rfkill_safe_init_done when we start the firmware
Date:   Wed, 24 Jul 2019 21:19:51 +0200
Message-Id: <20190724191757.431975096@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 940225628652b340b2bfe99f42f3d2db9fd9ce6c upstream.

Otherwise it'll stay set forever which is clearly buggy.

Cc: stable@vger.kernel.org
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -419,6 +419,8 @@ static int iwl_run_unified_mvm_ucode(str
 
 	lockdep_assert_held(&mvm->mutex);
 
+	mvm->rfkill_safe_init_done = false;
+
 	iwl_init_notification_wait(&mvm->notif_wait,
 				   &init_wait,
 				   init_complete,
@@ -537,8 +539,7 @@ int iwl_run_init_mvm_ucode(struct iwl_mv
 
 	lockdep_assert_held(&mvm->mutex);
 
-	if (WARN_ON_ONCE(mvm->rfkill_safe_init_done))
-		return 0;
+	mvm->rfkill_safe_init_done = false;
 
 	iwl_init_notification_wait(&mvm->notif_wait,
 				   &calib_wait,
@@ -1108,10 +1109,13 @@ static int iwl_mvm_load_rt_fw(struct iwl
 
 	iwl_fw_dbg_apply_point(&mvm->fwrt, IWL_FW_INI_APPLY_EARLY);
 
+	mvm->rfkill_safe_init_done = false;
 	ret = iwl_mvm_load_ucode_wait_alive(mvm, IWL_UCODE_REGULAR);
 	if (ret)
 		return ret;
 
+	mvm->rfkill_safe_init_done = true;
+
 	iwl_fw_dbg_apply_point(&mvm->fwrt, IWL_FW_INI_APPLY_AFTER_ALIVE);
 
 	return iwl_init_paging(&mvm->fwrt, mvm->fwrt.cur_fw_img);


