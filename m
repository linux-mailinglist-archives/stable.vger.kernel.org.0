Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCA1328C6C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240528AbhCASv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:51:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:53406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240243AbhCASpA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:45:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31C7E64FF5;
        Mon,  1 Mar 2021 17:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618411;
        bh=fodgHe8hvVgcYBNGP3V8gy+9j/9DxZ2QYO60B4Omja0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MaHcmZfqAFFa4r48+m66WIa0JCagLiOaZkA9uRRtNxx1126BJsTzjEJ47PveoOcyd
         LceqRQkJQVYTL3+Leeew+FXqTBdsSgYOly26JolbjNVwdqnb33Z1I0wnBiFJ53lZ3L
         geY6PoKthGufK//m+ZjWSky/GbMsFEbz5cBD+Px4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/663] iwlwifi: mvm: set enabled in the PPAG command properly
Date:   Mon,  1 Mar 2021 17:05:26 +0100
Message-Id: <20210301161145.591180142@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit efaa85cf2294d5e10a724e24356507eeb3836f72 ]

When version 2 of the PER_PLATFORM_ANT_GAIN_CMD was implemented, we
started copying the values from the command that we have stored into a
local instance.  But we accidentally forgot to copy the enabled flag,
so in practice PPAG is never really enabled.  Fix this by copying the
flag from our stored data a we should.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Fixes: f2134f66f40e ("iwlwifi: acpi: support ppag table command v2")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210131201908.24d7bf754ad5.I0e8abc2b8747508b6118242533d68c856ca6dffb@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 6385b9641126b..059ce227151ea 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1034,6 +1034,8 @@ int iwl_mvm_ppag_send_cmd(struct iwl_mvm *mvm)
 		return 0;
 	}
 
+	ppag_table.v1.enabled = mvm->fwrt.ppag_table.v1.enabled;
+
 	cmd_ver = iwl_fw_lookup_cmd_ver(mvm->fw, PHY_OPS_GROUP,
 					PER_PLATFORM_ANT_GAIN_CMD,
 					IWL_FW_CMD_VER_UNKNOWN);
-- 
2.27.0



