Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E9350559E
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241336AbiDRNVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243607AbiDRNUp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:20:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B558C101C9;
        Mon, 18 Apr 2022 05:52:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47A5AB80D9C;
        Mon, 18 Apr 2022 12:52:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD9DC385A7;
        Mon, 18 Apr 2022 12:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286337;
        bh=4DzzX0WzJVjW6boSYS3W+arhKlppk9cW+qJ5wqH51FA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SpBsiXe7RVno9YY87FacTEmwPwBb9JDkw4zdld7PCWWA58v8P+Uzh6ZoEQLb9eDnO
         9rqhQWQJ2jJgh2H9OQDXhKlsG5n/ZeRoFVk8PJuf/0+aVjMqBYMzRJQGEHeFIwOBBK
         QwR4AOtyDbfQ7/esHSl5qt1zptK1TXvHkfDc59g4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 103/284] iwlwifi: Fix -EIO error code that is never returned
Date:   Mon, 18 Apr 2022 14:11:24 +0200
Message-Id: <20220418121213.775492380@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit c305c94bdc18e45b5ad1db54da4269f8cbfdff6b ]

Currently the error -EIO is being assinged to variable ret when
the READY_BIT is not set but the function iwlagn_mac_start returns
0 rather than ret. Fix this by returning ret instead of 0.

Addresses-Coverity: ("Unused value")
Fixes: 7335613ae27a ("iwlwifi: move all mac80211 related functions to one place")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20210907104658.14706-1-colin.king@canonical.com
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
index 82caae02dd09..f2e0cfa2f4a2 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
@@ -317,7 +317,7 @@ static int iwlagn_mac_start(struct ieee80211_hw *hw)
 
 	priv->is_open = 1;
 	IWL_DEBUG_MAC80211(priv, "leave\n");
-	return 0;
+	return ret;
 }
 
 static void iwlagn_mac_stop(struct ieee80211_hw *hw)
-- 
2.34.1



