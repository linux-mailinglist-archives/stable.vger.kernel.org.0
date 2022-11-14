Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68DD627EEA
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237461AbiKNMxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:53:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237467AbiKNMxN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:53:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782D6252BA
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:53:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A36AB80EBF
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7EFC433C1;
        Mon, 14 Nov 2022 12:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430389;
        bh=87jc1f9aBeUUoqpANk80a/kPipWvHgjrk22lJX2TRdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LXymy9qi30nZchf0uTAcu0L5gGZ8A9znjf25sdhQ0cC9SY/aT6XzWV5kf4ZR5z1VX
         wRlWKOT60Xttk8Xu5Pz8GcwqHfCn/TINnZ1CBVEYq94KXGRyTNw9KTDQ9C57hwzAXJ
         uzwWc5j4VQKb0bIGioVUPMKuOy4j6+pLPwWh+0Xo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Howard Hsu <howard-yh.hsu@mediatek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/131] wifi: mac80211: Set TWT Information Frame Disabled bit as 1
Date:   Mon, 14 Nov 2022 13:44:44 +0100
Message-Id: <20221114124449.373944029@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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

From: Howard Hsu <howard-yh.hsu@mediatek.com>

[ Upstream commit 30ac96f7cc973bb850c718c9bbe1fdcedfbe826b ]

The TWT Information Frame Disabled bit of control field of TWT Setup
frame shall be set to 1 since handling TWT Information frame is not
supported by current mac80211 implementation.

Fixes: f5a4c24e689f ("mac80211: introduce individual TWT support in AP mode")
Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Link: https://lore.kernel.org/r/20221027015653.1448-1-howard-yh.hsu@mediatek.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/s1g.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/s1g.c b/net/mac80211/s1g.c
index 4141bc80cdfd..10b34bc4b67d 100644
--- a/net/mac80211/s1g.c
+++ b/net/mac80211/s1g.c
@@ -112,6 +112,9 @@ ieee80211_s1g_rx_twt_setup(struct ieee80211_sub_if_data *sdata,
 		goto out;
 	}
 
+	/* TWT Information not supported yet */
+	twt->control |= IEEE80211_TWT_CONTROL_RX_DISABLED;
+
 	drv_add_twt_setup(sdata->local, sdata, &sta->sta, twt);
 out:
 	ieee80211_s1g_send_twt_setup(sdata, mgmt->sa, sdata->vif.addr, twt);
-- 
2.35.1



