Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 970F74F377A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353030AbiDELNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349066AbiDEJtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0376BA94F2;
        Tue,  5 Apr 2022 02:39:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98D30B81B14;
        Tue,  5 Apr 2022 09:39:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F31EC385A1;
        Tue,  5 Apr 2022 09:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151578;
        bh=Z6EtSuCeXdh+PqwaoRlWSAWz4RHxvKlbnH7nuI5gNC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M/1Fj+Ta169HxbnUWcnDgOkRS9BUjeE8STfB0F2QMmSnjOZ0aiU8p28PKBUlBcgb5
         yYTO9KZwCKr8NtThl1IgEof+5hwSOO2sazRk5lRErFTFlTUDBYEqZofOeBGyOV/O8h
         ZqiX3jXQrgrH/GIZlQWUJ/AZC00TS63t8UbBgRxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 467/913] iwlwifi: mvm: Fix an error code in iwl_mvm_up()
Date:   Tue,  5 Apr 2022 09:25:29 +0200
Message-Id: <20220405070353.846025776@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 583d18336abdfb1b355270289ff8f6a2608ba905 ]

Return -ENODEV instead of success on this error path.

Fixes: dd36a507c806 ("iwlwifi: mvm: look for the first supported channel when add/remove phy ctxt")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20210816183930.GA2068@kili
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index bcc032c815dc..6d439ae7b50b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1489,8 +1489,10 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	while (!sband && i < NUM_NL80211_BANDS)
 		sband = mvm->hw->wiphy->bands[i++];
 
-	if (WARN_ON_ONCE(!sband))
+	if (WARN_ON_ONCE(!sband)) {
+		ret = -ENODEV;
 		goto error;
+	}
 
 	chan = &sband->channels[0];
 
-- 
2.34.1



