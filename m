Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F834FD14E
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351289AbiDLG6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351559AbiDLGx6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:53:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78486186F2;
        Mon, 11 Apr 2022 23:42:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D07FB818BD;
        Tue, 12 Apr 2022 06:42:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979E7C385A6;
        Tue, 12 Apr 2022 06:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745769;
        bh=MULgWNzYKIeZ6LHFtLTCYQ836O4d8ZKzFDBUaakDnv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pPzHXGUxxBfTLBMKoiC8aJYcMfGNdP43UONn0//suExuHtf6teWzqRAQ1hikkrzDM
         jem4pSjxBA9NDkKbaSvRns+dj/CdTmWRpCSPrHeR6SS5swu9WsZnacZLLfvGoA6I95
         Mt6aINWO+D8c/1bTPBsNfJrTXU8m/5cjbqi2uFK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/277] cfg80211: dont add non transmitted BSS to 6GHz scanned channels
Date:   Tue, 12 Apr 2022 08:27:23 +0200
Message-Id: <20220412062943.209285627@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit 5666ee154f4696c011dfa8544aaf5591b6b87515 ]

When adding 6GHz channels to scan request based on reported
co-located APs, don't add channels that have only APs with
"non-transmitted" BSSes if they only match the wildcard SSID since
they will be found by probing the "transmitted" BSS.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20220202104617.f6ddf099f934.I231e55885d3644f292d00dfe0f42653269f2559e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index adc0d14cfd86..8e1e578d64bc 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -702,8 +702,12 @@ static bool cfg80211_find_ssid_match(struct cfg80211_colocated_ap *ap,
 
 	for (i = 0; i < request->n_ssids; i++) {
 		/* wildcard ssid in the scan request */
-		if (!request->ssids[i].ssid_len)
+		if (!request->ssids[i].ssid_len) {
+			if (ap->multi_bss && !ap->transmitted_bssid)
+				continue;
+
 			return true;
+		}
 
 		if (ap->ssid_len &&
 		    ap->ssid_len == request->ssids[i].ssid_len) {
@@ -829,6 +833,9 @@ static int cfg80211_scan_6ghz(struct cfg80211_registered_device *rdev)
 		    !cfg80211_find_ssid_match(ap, request))
 			continue;
 
+		if (!request->n_ssids && ap->multi_bss && !ap->transmitted_bssid)
+			continue;
+
 		cfg80211_scan_req_add_chan(request, chan, true);
 		memcpy(scan_6ghz_params->bssid, ap->bssid, ETH_ALEN);
 		scan_6ghz_params->short_ssid = ap->short_ssid;
-- 
2.35.1



