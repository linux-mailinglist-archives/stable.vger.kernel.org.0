Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB7E4F29F7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242849AbiDEJiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240407AbiDEJGG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:06:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DE94838C;
        Tue,  5 Apr 2022 01:56:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4933FB81C6F;
        Tue,  5 Apr 2022 08:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A830CC385A0;
        Tue,  5 Apr 2022 08:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148982;
        bh=MhbfE+TlUu5XyErtSUHPH19ufIBaaUhqTicyOzfIEE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TWl+aoDquoXRZE4AYUGsCrnVRCTIFy3GCJ+zceEdeLgVfyaSzaCtPSmBg3xon7A3N
         E/JqTv4VQzomx4Fh5JNVgE1NjFcbfb0P/o/M5v3wfp5/qm369W6RhD8kB1IVtz+Nhu
         pRh6grLOYJRf4FFwQtWTOgGsesvZpqWewa0jX4jE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0514/1017] iwlwifi: mvm: Fix an error code in iwl_mvm_up()
Date:   Tue,  5 Apr 2022 09:23:47 +0200
Message-Id: <20220405070409.555267247@linuxfoundation.org>
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
index 58d5395acf73..6d17d7a71182 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1553,8 +1553,10 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
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



