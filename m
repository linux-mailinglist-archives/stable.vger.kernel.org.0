Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC7A4F3389
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236947AbiDEJDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236894AbiDEIRH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:17:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C72ADD45;
        Tue,  5 Apr 2022 01:04:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CE4461725;
        Tue,  5 Apr 2022 08:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E1BC385A3;
        Tue,  5 Apr 2022 08:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145874;
        bh=sL3PQOe5HXGSewZPa7HCepSF994qk/AklDFvpvB1oiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqkgMZd16+OJq1xp4UZipKTqNUIFqQRuIskanS+mvu5m1QLEhp6WKPZNkuACfPVjC
         DShzLQMsnNBYhKAal/7vny8ONRq1O2Ybbm6dQ6Lc0I5RU+uvDYsjv7hqGcIZIM1+LJ
         0yzhyNbIaN/9ELn0k5xDnxmf7VEhwewNupbhLaDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0562/1126] iwlwifi: mvm: fix off by one in iwl_mvm_stat_iterator_all_macs()
Date:   Tue,  5 Apr 2022 09:21:49 +0200
Message-Id: <20220405070424.129277698@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit f1cbb0a8ca9db80c086009c88c71464ac50f50a2 ]

Change the comparison from ">" to ">=" to avoid accessing one element
beyond the end of the ->per_mac_stats[] array.

Fixes: 6324c173ff4a ("iwlwifi: mvm: add support for statistics update version 15")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20220106071825.GA5836@kili
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 64446a11ef98..9a46468bd434 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -640,7 +640,7 @@ static void iwl_mvm_stat_iterator_all_macs(void *_data, u8 *mac,
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	u16 vif_id = mvmvif->id;
 
-	if (WARN_ONCE(vif_id > MAC_INDEX_AUX, "invalid vif id: %d", vif_id))
+	if (WARN_ONCE(vif_id >= MAC_INDEX_AUX, "invalid vif id: %d", vif_id))
 		return;
 
 	if (vif->type != NL80211_IFTYPE_STATION)
-- 
2.34.1



