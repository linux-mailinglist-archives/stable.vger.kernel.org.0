Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75AF94F2AB0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243096AbiDEJiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239084AbiDEJFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:05:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E355F4090C;
        Tue,  5 Apr 2022 01:56:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 296DE61572;
        Tue,  5 Apr 2022 08:56:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB73C385A0;
        Tue,  5 Apr 2022 08:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148976;
        bh=sguz78huzTlJ+6AdEbFDuzyeDjf7ZrfKYEM3mGzXiZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTdn0gfF3X3Yp7CZPVDupN2GZvnUnEFxa/DoqhzhMW90xJ4JJmchloT+SorQTaO8P
         XsmX+eyXPX61Ef1ZShtJsOBajn+W8ayTOqMSzZhS5lSiAxzE2qrGt5hhaqNWqQqAa4
         0BMO2jZTm1FkA2OcsSQUlEm5MIceEk6+EJx6jaKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mukesh Sisodiya <mukesh.sisodiya@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0512/1017] iwlwifi: yoyo: Avoid using dram data if allocation failed
Date:   Tue,  5 Apr 2022 09:23:45 +0200
Message-Id: <20220405070409.496667498@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index 7ab98b419cc1..d412b6d0b28e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -849,11 +849,18 @@ static void iwl_dbg_tlv_apply_config(struct iwl_fw_runtime *fwrt,
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



