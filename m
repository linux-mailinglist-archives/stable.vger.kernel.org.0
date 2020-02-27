Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B50E5171F34
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732613AbgB0OAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:00:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:34156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732597AbgB0OAj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:00:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71B6220578;
        Thu, 27 Feb 2020 14:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812038;
        bh=EaFYSLWwD9gekvKvQ2KakS9kbGL/UANEAU+960lU688=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pHHdniKcxKA2RbwYMk7XSybaFz6kHSMI8SsxRQtre1V1CHSzfquP3Ly3oSZ1bjfWg
         ZBfWvzFA3naly2+SLOAF+nCfDmIOVYfoNrH6SExIeGsK2+tRBMfCyz+ZAPP6LyU8O0
         uiZViJy0R1nFZmocGyrUkPYsLFf5hLLVJAQz1nYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 160/237] iwlwifi: mvm: Fix thermal zone registration
Date:   Thu, 27 Feb 2020 14:36:14 +0100
Message-Id: <20200227132308.285203576@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

[ Upstream commit baa6cf8450b72dcab11f37c47efce7c5b9b8ad0f ]

Use a unique name when registering a thermal zone. Otherwise, with
multiple NICS, we hit the following warning during the unregistration.

WARNING: CPU: 2 PID: 3525 at fs/sysfs/group.c:255
 RIP: 0010:sysfs_remove_group+0x80/0x90
 Call Trace:
  dpm_sysfs_remove+0x57/0x60
  device_del+0x5a/0x350
  ? sscanf+0x4e/0x70
  device_unregister+0x1a/0x60
  hwmon_device_unregister+0x4a/0xa0
  thermal_remove_hwmon_sysfs+0x175/0x1d0
  thermal_zone_device_unregister+0x188/0x1e0
  iwl_mvm_thermal_exit+0xe7/0x100 [iwlmvm]
  iwl_op_mode_mvm_stop+0x27/0x180 [iwlmvm]
  _iwl_op_mode_stop.isra.3+0x2b/0x50 [iwlwifi]
  iwl_opmode_deregister+0x90/0xa0 [iwlwifi]
  __exit_compat+0x10/0x2c7 [iwlmvm]
  __x64_sys_delete_module+0x13f/0x270
  do_syscall_64+0x5a/0x110
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index 1232f63278eb6..319103f4b432e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -739,7 +739,8 @@ static  struct thermal_zone_device_ops tzone_ops = {
 static void iwl_mvm_thermal_zone_register(struct iwl_mvm *mvm)
 {
 	int i;
-	char name[] = "iwlwifi";
+	char name[16];
+	static atomic_t counter = ATOMIC_INIT(0);
 
 	if (!iwl_mvm_is_tt_in_fw(mvm)) {
 		mvm->tz_device.tzone = NULL;
@@ -749,6 +750,7 @@ static void iwl_mvm_thermal_zone_register(struct iwl_mvm *mvm)
 
 	BUILD_BUG_ON(ARRAY_SIZE(name) >= THERMAL_NAME_LENGTH);
 
+	sprintf(name, "iwlwifi_%u", atomic_inc_return(&counter) & 0xFF);
 	mvm->tz_device.tzone = thermal_zone_device_register(name,
 							IWL_MAX_DTS_TRIPS,
 							IWL_WRITABLE_TRIPS_MSK,
-- 
2.20.1



