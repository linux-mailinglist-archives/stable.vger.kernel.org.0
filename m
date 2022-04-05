Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E8F4F2F15
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237062AbiDEJDy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236709AbiDEIQ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:16:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7081DAD123;
        Tue,  5 Apr 2022 01:04:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8A66B81B90;
        Tue,  5 Apr 2022 08:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B62C385A2;
        Tue,  5 Apr 2022 08:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145869;
        bh=sc9pWM0Et+OG2UDsJfEDeDUGc1KeOVmKtHvxnrWQ5Ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VB3prBfeirjDxhttXUI65+LukTqupTVQYNP0W7TSbI43yYGeqGMmnYA3gqsw9oXMa
         Sc590s7Mn9dRD/L6cehaLzEnuaJj5wXZLcnpkvJWL58VCxXI6Bs70fNNr7OtOHAIaI
         4VD9aHV+dd8YGduYNzAgBs2SB6WRRxQakzS/61RU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rotem Saado <rotem.saado@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0560/1126] iwlwifi: yoyo: remove DBGI_SRAM address reset writing
Date:   Tue,  5 Apr 2022 09:21:47 +0200
Message-Id: <20220405070424.070708637@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Rotem Saado <rotem.saado@intel.com>

[ Upstream commit ce014c9861544bb4e789323d0d8956a5ad262e25 ]

Due to preg protection we cannot write to this register
while FW is running (when FW in Halt it is ok).
since we have some cases that we need to dump this
region while FW is running remove this writing from DRV.
FW will do this writing.

Signed-off-by: Rotem Saado <rotem.saado@intel.com>
Fixes: 89639e06d0f3 ("iwlwifi: yoyo: support for new DBGI_SRAM region")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20220129105618.209f3078bc74.I463530bd2f40daedb39f6d9df987bb7cee209033@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 2 --
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 7ad9cee925da..372cc950cc88 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1561,8 +1561,6 @@ iwl_dump_ini_dbgi_sram_iter(struct iwl_fw_runtime *fwrt,
 		return -EBUSY;
 
 	range->range_data_size = reg->dev_addr.size;
-	iwl_write_prph_no_grab(fwrt->trans, DBGI_SRAM_TARGET_ACCESS_CFG,
-			       DBGI_SRAM_TARGET_ACCESS_CFG_RESET_ADDRESS_MSK);
 	for (i = 0; i < (le32_to_cpu(reg->dev_addr.size) / 4); i++) {
 		prph_data = iwl_read_prph_no_grab(fwrt->trans, (i % 2) ?
 					  DBGI_SRAM_TARGET_ACCESS_RDATA_MSB :
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index 95b3dae7b504..9331a6b6bf36 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -354,8 +354,6 @@
 #define WFPM_GP2			0xA030B4
 
 /* DBGI SRAM Register details */
-#define DBGI_SRAM_TARGET_ACCESS_CFG			0x00A2E14C
-#define DBGI_SRAM_TARGET_ACCESS_CFG_RESET_ADDRESS_MSK	0x10000
 #define DBGI_SRAM_TARGET_ACCESS_RDATA_LSB		0x00A2E154
 #define DBGI_SRAM_TARGET_ACCESS_RDATA_MSB		0x00A2E158
 
-- 
2.34.1



