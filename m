Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931734FD19C
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350823AbiDLG70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352423AbiDLGzp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:55:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EB23A701;
        Mon, 11 Apr 2022 23:45:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89CDC60B5E;
        Tue, 12 Apr 2022 06:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ADCCC385A8;
        Tue, 12 Apr 2022 06:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745931;
        bh=pY4QV7aUWhR+x8fT1/v/jYPAQBiSOMIuk64AYnF/ntw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jkdvoch2Fhq0/59IFaogRL/p9wV78/ZUSKeiYl2AVh+nfjzSaLIDkL3SjHjZQaNOY
         mIo6iLFIAG1taGrMDe/MYws5t4mcaolVEP08KPnSpkSz/yd4nOOBtePb70zomYAMla
         FGcNcrClrEIFTI4I6JHsLhKdJ8bgKyuDbLY4llV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/277] iwlwifi: mvm: Correctly set fragmented EBS
Date:   Tue, 12 Apr 2022 08:27:42 +0200
Message-Id: <20220412062943.757256668@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit d8d4dd26b9e0469baf5017f0544d852fd4e3fb6d ]

Currently, fragmented EBS was set for a channel only if the 'hb_type'
was set to fragmented or balanced scan. However, 'hb_type' is set only
in case of CDB, and thus fragmented EBS is never set for a channel for
non-CDB devices. Fix it.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20220204122220.a6165ac9b9d5.I654eafa62fd647030ae6d4f07f32c96c3171decb@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 5461bf399959..65e382756de6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1890,7 +1890,10 @@ static u8 iwl_mvm_scan_umac_chan_flags_v2(struct iwl_mvm *mvm,
 			IWL_SCAN_CHANNEL_FLAG_CACHE_ADD;
 
 	/* set fragmented ebs for fragmented scan on HB channels */
-	if (iwl_mvm_is_scan_fragmented(params->hb_type))
+	if ((!iwl_mvm_is_cdb_supported(mvm) &&
+	     iwl_mvm_is_scan_fragmented(params->type)) ||
+	    (iwl_mvm_is_cdb_supported(mvm) &&
+	     iwl_mvm_is_scan_fragmented(params->hb_type)))
 		flags |= IWL_SCAN_CHANNEL_FLAG_EBS_FRAG;
 
 	return flags;
-- 
2.35.1



