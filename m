Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86224BE078
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbiBUJuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:50:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352876AbiBUJsA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:48:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B149140E9;
        Mon, 21 Feb 2022 01:20:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8A97FCE0E7D;
        Mon, 21 Feb 2022 09:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68444C340E9;
        Mon, 21 Feb 2022 09:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435241;
        bh=eRdAMNUWLmW3wkxHrYARD03B6yLDBmoiMLWXqF0v8Tk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zRqU4ueLk5L8MYun58Ed2BkAkddeJKio5TV0EaPy97L4ciF0PytrgFpP9E4Hl7KPT
         tZ7ua48heMsZOchzDrVpgk8fcF4jl2TvU7V2QPr2osFHNGkQuYuB7tsqdacPlnRFL5
         43hn0kWARqY+DSQLRFnTXnmzDK2nXNQfBFOwjukI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.16 094/227] iwlwifi: mvm: fix condition which checks the version of rate_n_flags
Date:   Mon, 21 Feb 2022 09:48:33 +0100
Message-Id: <20220221084938.003673140@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

commit be8287c9b8326d767429c8371bbc78b33f6efe13 upstream.

We're checking the FW version of TX_CMD in order to decide whether to
convert rate_n_flags from the old format to the new one.  If the API
is smaller or equal to 6 we should convert it.  Currently we're
converting if the API version is greater than 6. Fix it.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Fixes: dc52fac37c87 ("iwlwifi: mvm: Support new TX_RSP and COMPRESSED_BA_RES versions")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/iwlwifi.20220128142706.a264ac51d106.I228ba1317cdcbfef931c09d280d701fcad9048d2@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1380,7 +1380,7 @@ static void iwl_mvm_hwrate_to_tx_status(
 	struct ieee80211_tx_rate *r = &info->status.rates[0];
 
 	if (iwl_fw_lookup_notif_ver(fw, LONG_GROUP,
-				    TX_CMD, 0) > 6)
+				    TX_CMD, 0) <= 6)
 		rate_n_flags = iwl_new_rate_from_v1(rate_n_flags);
 
 	info->status.antenna =


