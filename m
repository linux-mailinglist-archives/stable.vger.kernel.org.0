Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4125C528ED8
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbiEPTn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346083AbiEPTmu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:42:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34853F32B;
        Mon, 16 May 2022 12:41:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 197F561512;
        Mon, 16 May 2022 19:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17105C385AA;
        Mon, 16 May 2022 19:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730079;
        bh=jXsRJZlhkkVNE5KFJ6uMHiXK5LPb7EkwA2pg9EW8UoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jeIF6155DwepFbd8POLDNrVPixbVbwQo4llPFQD0tlC3sp5+sOa+xJGgNC8PjXaRx
         ftF29XpFT3739QteWs+ctzPAbizNeFwVO6/Xc+Fr9hzURQSghZ1HCmxZIq1jyUnFvC
         jFSGmDcej8qYjzFbJggU6almYzGwDOoiAKzf62LQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/32] mac80211_hwsim: call ieee80211_tx_prepare_skb under RCU protection
Date:   Mon, 16 May 2022 21:36:20 +0200
Message-Id: <20220516193614.966264764@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193614.773450018@linuxfoundation.org>
References: <20220516193614.773450018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 9e2db50f1ef2238fc2f71c5de1c0418b7a5b0ea2 ]

This is needed since it might use (and pass out) pointers to
e.g. keys protected by RCU. Can't really happen here as the
frames aren't encrypted, but we need to still adhere to the
rules.

Fixes: cacfddf82baf ("mac80211_hwsim: initialize ieee80211_tx_info at hw_scan_work")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20220505230421.5f139f9de173.I77ae111a28f7c0e9fd1ebcee7f39dbec5c606770@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index c84ee5ba5381..3d8e17bb8a10 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2082,11 +2082,13 @@ static void hw_scan_work(struct work_struct *work)
 			if (req->ie_len)
 				skb_put_data(probe, req->ie, req->ie_len);
 
+			rcu_read_lock();
 			if (!ieee80211_tx_prepare_skb(hwsim->hw,
 						      hwsim->hw_scan_vif,
 						      probe,
 						      hwsim->tmp_chan->band,
 						      NULL)) {
+				rcu_read_unlock();
 				kfree_skb(probe);
 				continue;
 			}
@@ -2094,6 +2096,7 @@ static void hw_scan_work(struct work_struct *work)
 			local_bh_disable();
 			mac80211_hwsim_tx_frame(hwsim->hw, probe,
 						hwsim->tmp_chan);
+			rcu_read_unlock();
 			local_bh_enable();
 		}
 	}
-- 
2.35.1



