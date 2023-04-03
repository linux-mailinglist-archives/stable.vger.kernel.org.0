Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8236D4A2C
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233946AbjDCOou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbjDCOoe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:44:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD2B280E6
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:44:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B26EB6144D
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6298C4339B;
        Mon,  3 Apr 2023 14:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533051;
        bh=isO0RvN70ZcuYch9J00VGEUvSaWqdMj2Ho5yc7Tft/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xl4IhtxXYc5+eN4Kx7aSJFDP827WpNnfiVEvpI4QOaMzGBDk+xztMV/8/wYma4+ZG
         yqRQFDN13AK4S7/fkuIpCSRpuIOmHJCJRmfRN38cdQDRnWFIZg0z24f+YW781wkeVT
         FfBhznVoNvv29mknOiwn0qjkhQRYgBUKLnU58Mz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 035/187] wifi: mac80211: check basic rates validity
Date:   Mon,  3 Apr 2023 16:08:00 +0200
Message-Id: <20230403140417.147598860@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit ce04abc3fcc62cd5640af981ebfd7c4dc3bded28 ]

When userspace sets basic rates, it might send us some rates
list that's empty or consists of invalid values only. We're
currently ignoring invalid values and then may end up with a
rates bitmap that's empty, which later results in a warning.

Reject the call if there were no valid rates.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d611e15301839..e24d2d5b04ad0 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2576,6 +2576,17 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 	if (!sband)
 		return -EINVAL;
 
+	if (params->basic_rates) {
+		if (!ieee80211_parse_bitrates(link->conf->chandef.width,
+					      wiphy->bands[sband->band],
+					      params->basic_rates,
+					      params->basic_rates_len,
+					      &link->conf->basic_rates))
+			return -EINVAL;
+		changed |= BSS_CHANGED_BASIC_RATES;
+		ieee80211_check_rate_mask(link);
+	}
+
 	if (params->use_cts_prot >= 0) {
 		link->conf->use_cts_prot = params->use_cts_prot;
 		changed |= BSS_CHANGED_ERP_CTS_PROT;
@@ -2597,16 +2608,6 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 		changed |= BSS_CHANGED_ERP_SLOT;
 	}
 
-	if (params->basic_rates) {
-		ieee80211_parse_bitrates(link->conf->chandef.width,
-					 wiphy->bands[sband->band],
-					 params->basic_rates,
-					 params->basic_rates_len,
-					 &link->conf->basic_rates);
-		changed |= BSS_CHANGED_BASIC_RATES;
-		ieee80211_check_rate_mask(link);
-	}
-
 	if (params->ap_isolate >= 0) {
 		if (params->ap_isolate)
 			sdata->flags |= IEEE80211_SDATA_DONT_BRIDGE_PACKETS;
-- 
2.39.2



