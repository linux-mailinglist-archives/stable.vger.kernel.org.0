Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABBC4F2B25
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236963AbiDEJDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236756AbiDEIRB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:17:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5BB06929E;
        Tue,  5 Apr 2022 01:04:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99D2F61748;
        Tue,  5 Apr 2022 08:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB2DC385A3;
        Tue,  5 Apr 2022 08:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145872;
        bh=CFhc9Z45Qbk4NWrtr4wnxdRKTBGyRPuDjO8Z/VPVtoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZ0SPCNQN4tUZADfcZGKkSMStocM70uouXaQd1o0FWXH7CqP2AyrzRl+FmSmr79Gr
         9DkPMJonTfOEWtxew61ceX3LccS7nFl1Erv3IvSRIVEgWZ6e3hNBfdWvW5U4rk/Fwt
         /1VSEwMesRBo7cKth349Y3VXNVKbtTPh25S82QSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mukesh Sisodiya <mukesh.sisodiya@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0561/1126] iwlwifi: yoyo: Avoid using dram data if allocation failed
Date:   Tue,  5 Apr 2022 09:21:48 +0200
Message-Id: <20220405070424.100101437@linuxfoundation.org>
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

From: Mukesh Sisodiya <mukesh.sisodiya@intel.com>

[ Upstream commit e2d53d10ef666859517360e711fd7761e7e984ce ]

The config set TLV setting depend on dram allocation
and if allocation failed the data used in config set tlv
should not set this.
Adding the check if dram fragment is available or not.

Signed-off-by: Mukesh Sisodiya <mukesh.sisodiya@intel.com>
Fixes: 1a5daead217c ("iwlwifi: yoyo: support for ROM usniffer")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20220204122220.44835d181528.I3e78ba29c13bbeada017fcb2a620f3552c1dfa30@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index c73672d61356..42f6f8bb83be 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -861,11 +861,18 @@ static void iwl_dbg_tlv_apply_config(struct iwl_fw_runtime *fwrt,
 		case IWL_FW_INI_CONFIG_SET_TYPE_DBGC_DRAM_ADDR: {
 			struct iwl_dbgc1_info dram_info = {};
 			struct iwl_dram_data *frags = &fwrt->trans->dbg.fw_mon_ini[1].frags[0];
-			__le64 dram_base_addr = cpu_to_le64(frags->physical);
-			__le32 dram_size = cpu_to_le32(frags->size);
-			u64  dram_addr = le64_to_cpu(dram_base_addr);
+			__le64 dram_base_addr;
+			__le32 dram_size;
+			u64 dram_addr;
 			u32 ret;
 
+			if (!frags)
+				break;
+
+			dram_base_addr = cpu_to_le64(frags->physical);
+			dram_size = cpu_to_le32(frags->size);
+			dram_addr = le64_to_cpu(dram_base_addr);
+
 			IWL_DEBUG_FW(fwrt, "WRT: dram_base_addr 0x%016llx, dram_size 0x%x\n",
 				     dram_base_addr, dram_size);
 			IWL_DEBUG_FW(fwrt, "WRT: config_list->addr_offset: %u\n",
-- 
2.34.1



