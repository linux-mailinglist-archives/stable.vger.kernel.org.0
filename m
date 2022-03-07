Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3774E4CF5EF
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237214AbiCGJbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237861AbiCGJ23 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:28:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509F66BDF9;
        Mon,  7 Mar 2022 01:26:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31A3861140;
        Mon,  7 Mar 2022 09:26:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004C4C340F3;
        Mon,  7 Mar 2022 09:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645172;
        bh=zkNcC6hnSHqKlwlocwB7CPDuJLbjT2NpdqYeAQVJKoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xgImOR4KTxa1wTQ8H3kqaMcMdLlQV4+9NXcidk+0UmsAmuDRxD87hzjOwQ0WzwtDM
         Q4OhNV3dMiqL8kS3G8StWcTeEXyalbX24lSV5aaEVSP/PVGA+lE3UBdMITttWhAx+H
         vV8O/AUDvCHfQOToga9Gp56j7frnsDnKOWg1IU4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, JaeMan Park <jaeman@google.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 02/64] mac80211_hwsim: initialize ieee80211_tx_info at hw_scan_work
Date:   Mon,  7 Mar 2022 10:18:35 +0100
Message-Id: <20220307091639.208272118@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091639.136830784@linuxfoundation.org>
References: <20220307091639.136830784@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: JaeMan Park <jaeman@google.com>

[ Upstream commit cacfddf82baf1470e5741edeecb187260868f195 ]

In mac80211_hwsim, the probe_req frame is created and sent while
scanning. It is sent with ieee80211_tx_info which is not initialized.
Uninitialized ieee80211_tx_info can cause problems when using
mac80211_hwsim with wmediumd. wmediumd checks the tx_rates field of
ieee80211_tx_info and doesn't relay probe_req frame to other clients
even if it is a broadcasting message.

Call ieee80211_tx_prepare_skb() to initialize ieee80211_tx_info for
the probe_req that is created by hw_scan_work in mac80211_hwsim.

Signed-off-by: JaeMan Park <jaeman@google.com>
Link: https://lore.kernel.org/r/20220113060235.546107-1-jaeman@google.com
[fix memory leak]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index cfd97fe92d468..6e1721d533846 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2062,6 +2062,15 @@ static void hw_scan_work(struct work_struct *work)
 			if (req->ie_len)
 				skb_put_data(probe, req->ie, req->ie_len);
 
+			if (!ieee80211_tx_prepare_skb(hwsim->hw,
+						      hwsim->hw_scan_vif,
+						      probe,
+						      hwsim->tmp_chan->band,
+						      NULL)) {
+				kfree_skb(probe);
+				continue;
+			}
+
 			local_bh_disable();
 			mac80211_hwsim_tx_frame(hwsim->hw, probe,
 						hwsim->tmp_chan);
-- 
2.34.1



