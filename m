Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0AD11013C6
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbfKSF1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:27:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:45400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728097AbfKSF1L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:27:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0C8021823;
        Tue, 19 Nov 2019 05:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141231;
        bh=JT53lHzlxTCvHdD2h1AKBQEq+cdCUIcoomU7kVIRX94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=stQYQ5QIaF7cZbK1fRLIu0up61UZVHe38HI/5EMGOFKS0mQ50KE1h2ALOtmw6RyQG
         yXPqfBxGRMkk0cDxGQFnw5/A4Bf3QO1T5B/VySt8ZPwjI2o0b8jQWxb++KW5/Z8F0l
         zqE7YmtHba9d0VTxTU2wk2t/z4uSfxrnqGrzx1KQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 089/422] iwlwifi: dont WARN on trying to dump dead firmware
Date:   Tue, 19 Nov 2019 06:14:46 +0100
Message-Id: <20191119051405.165466532@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 84f260251ed8153e84c64eb2c5278ab18d3ddef6 ]

There's no point in warning here, the user will just get an
error back to the debugfs file write, and warning just makes
it seem like there's an internal consistency problem when in
reality the user just happened to hit this at a bad time.
Remove the warning.

Fixes: f45f979dc208 ("iwlwifi: mvm: disable dbg data collect when fw isn't alive")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index a31a42e673c46..8070b2d4c46fe 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1016,7 +1016,7 @@ int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
 	 * If the loading of the FW completed successfully, the next step is to
 	 * get the SMEM config data. Thus, if fwrt->smem_cfg.num_lmacs is non
 	 * zero, the FW was already loaded successully. If the state is "NO_FW"
-	 * in such a case - WARN and exit, since FW may be dead. Otherwise, we
+	 * in such a case - exit, since FW may be dead. Otherwise, we
 	 * can try to collect the data, since FW might just not be fully
 	 * loaded (no "ALIVE" yet), and the debug data is accessible.
 	 *
@@ -1024,9 +1024,8 @@ int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
 	 *	config. In such a case, due to HW access problems, we might
 	 *	collect garbage.
 	 */
-	if (WARN((fwrt->trans->state == IWL_TRANS_NO_FW) &&
-		 fwrt->smem_cfg.num_lmacs,
-		 "Can't collect dbg data when FW isn't alive\n"))
+	if (fwrt->trans->state == IWL_TRANS_NO_FW &&
+	    fwrt->smem_cfg.num_lmacs)
 		return -EIO;
 
 	if (test_and_set_bit(IWL_FWRT_STATUS_DUMPING, &fwrt->status))
-- 
2.20.1



