Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8C4657D3A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233542AbiL1Pk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233950AbiL1Pkx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:40:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFE0E09D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:40:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE73CB81719
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182A4C433EF;
        Wed, 28 Dec 2022 15:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242049;
        bh=oPdNVYVgqMTARXgaDMO2J0+D9WTvrKAMXyh3e3lh6YI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pOIy/GIkTCrWlv1U8rg3r+2m/mnpkxOrG+Q8BDBbvUtBDeoP7aSMK9v6o5jI00zsL
         nDcfKAJlKtHVWgvZzwQX5MWN988dgbLIrXVy3UCgRv1w1fWlFWNRdwAKBLC5zPjt0D
         vUmyY7bCKdZ+2XTdBRGRCZ4YXPP0znydGkZqznIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0320/1146] wifi: iwlwifi: mei: fix tx DHCP packet for devices with new Tx API
Date:   Wed, 28 Dec 2022 15:30:59 +0100
Message-Id: <20221228144338.846271462@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit bcd68b3dbe78b7b0f7b6b55162cf1eff1e7fff9e ]

Devices with new Tx API have the IV introduced by the HW and it is not
present in the skb at all. Hence we don't need to tell
iwl_mvm_mei_tx_copy_to_csme to jump over 8 bytes to get to the ethernet
header.

Fixes: 2da4366f9e2c ("iwlwifi: mei: add the driver to allow cooperation with CSME")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20221030191011.12dc42133502.Idd744ffeeb84b880eb497963ee02563cbb959a42@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 86d20e13bf47..ba335f57771c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1171,9 +1171,15 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	/* From now on, we cannot access info->control */
 	iwl_mvm_skb_prepare_status(skb, dev_cmd);
 
+	/*
+	 * The IV is introduced by the HW for new tx api, and it is not present
+	 * in the skb, hence, don't tell iwl_mvm_mei_tx_copy_to_csme about the
+	 * IV for those devices.
+	 */
 	if (ieee80211_is_data(fc))
 		iwl_mvm_mei_tx_copy_to_csme(mvm, skb,
-					    info->control.hw_key ?
+					    info->control.hw_key &&
+					    !iwl_mvm_has_new_tx_api(mvm) ?
 					    info->control.hw_key->iv_len : 0);
 
 	if (iwl_trans_tx(mvm->trans, skb, dev_cmd, txq_id))
-- 
2.35.1



