Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3525F992B
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiJJHIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbiJJHHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:07:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF4E1D678;
        Mon, 10 Oct 2022 00:05:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA66960E08;
        Mon, 10 Oct 2022 07:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2406C433D6;
        Mon, 10 Oct 2022 07:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385540;
        bh=6JffHU6PnRtlmn1w09erYXoEyaJBI9+hx8PzX9HTScw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t2qq3vp/NpuK+fy3bD9QtVKJ7ognRPfjNkYvuBNgHffIicntEgXKq6uwdX3JDQOwa
         /XYYCTRsznXcs8oW2JBGl1xz5BlsdcZwKaUv0qfa/fj0kCx4LiEky0mOUiVKqCDKcr
         mhkE+A+qwZTNgxFdjViEm48kva9SCOlzokA0icsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 16/48] wifi: iwlwifi: dont spam logs with NSS>2 messages
Date:   Mon, 10 Oct 2022 09:05:14 +0200
Message-Id: <20221010070334.133086627@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070333.676316214@linuxfoundation.org>
References: <20221010070333.676316214@linuxfoundation.org>
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

From: Jason A. Donenfeld <Jason@zx2c4.com>

[ Upstream commit 4d8421f2dd88583cc7a4d6c2a5532c35e816a52a ]

I get a log line like this every 4 seconds when connected to my AP:

[15650.221468] iwlwifi 0000:09:00.0: Got NSS = 4 - trimming to 2

Looking at the code, this seems to be related to a hardware limitation,
and there's nothing to be done. In an effort to keep my dmesg
manageable, downgrade this error to "debug" rather than "info".

Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220905172246.105383-1-Jason@zx2c4.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index c5626ff83805..640e3786c244 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1833,8 +1833,8 @@ static void iwl_mvm_parse_ppe(struct iwl_mvm *mvm,
 	* If nss < MAX: we can set zeros in other streams
 	*/
 	if (nss > MAX_HE_SUPP_NSS) {
-		IWL_INFO(mvm, "Got NSS = %d - trimming to %d\n", nss,
-			 MAX_HE_SUPP_NSS);
+		IWL_DEBUG_INFO(mvm, "Got NSS = %d - trimming to %d\n", nss,
+			       MAX_HE_SUPP_NSS);
 		nss = MAX_HE_SUPP_NSS;
 	}
 
-- 
2.35.1



