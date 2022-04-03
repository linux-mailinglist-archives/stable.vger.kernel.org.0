Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904954F09CE
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 15:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358777AbiDCNRL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 09:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358776AbiDCNRJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 09:17:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A315B25EE
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 06:15:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3688B61149
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 13:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C55C340ED;
        Sun,  3 Apr 2022 13:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648991714;
        bh=+qeK3rKkBFnFJtXiDw9YsqWQvEk+YT1xawZHkJMxZkU=;
        h=Subject:To:Cc:From:Date:From;
        b=diVdNMyV3z/869wDD6oB+/vR8sQ9wnWHBCNtbaMzch7s/cZfTCdh3bP/kETPR34L8
         9zkAOMBjhDfdE0EU6TbNeL9Lu6mnpiTUSHJCQ+8QvQWVPMq/Qu7hH1Wc4CJyKG40kP
         omZ9sQaiBDkfex35l8znDt8VglW2voo3+gmw5F94=
Subject: FAILED: patch "[PATCH] iwlwifi: nvm: Correct HE capability" failed to apply to 5.15-stable tree
To:     abhishek.naik@intel.com, luciano.coelho@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Apr 2022 15:15:12 +0200
Message-ID: <164899171215368@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 85643396c71241aa8b5afc4e23e1099b170f6517 Mon Sep 17 00:00:00 2001
From: Abhishek Naik <abhishek.naik@intel.com>
Date: Sun, 30 Jan 2022 11:53:06 +0200
Subject: [PATCH] iwlwifi: nvm: Correct HE capability

The HE PHY capability - Tx 1024-QAM < 242-tone RU support
was not handled for Ms RFs, add the relevant code for it.

Signed-off-by: Abhishek Naik <abhishek.naik@intel.com>
Fixes: 1381eb5c8ed5 ("iwlwifi: correct HE capabilities")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20220130115024.01e232ce98ca.I765d26e9eb6ae9424542ccb7dd7f7ba61b1b6449@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 0693dfda43a3..0dfd69fcd5d7 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -784,6 +784,7 @@ iwl_nvm_fixup_sband_iftd(struct iwl_trans *trans,
 	switch (CSR_HW_RFID_TYPE(trans->hw_rf_id)) {
 	case IWL_CFG_RF_TYPE_GF:
 	case IWL_CFG_RF_TYPE_MR:
+	case IWL_CFG_RF_TYPE_MS:
 		iftype_data->he_cap.he_cap_elem.phy_cap_info[9] |=
 			IEEE80211_HE_PHY_CAP9_TX_1024_QAM_LESS_THAN_242_TONE_RU;
 		if (!is_ap)

