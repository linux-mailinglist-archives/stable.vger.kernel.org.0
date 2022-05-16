Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012F15291BE
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240126AbiEPUIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350235AbiEPUA5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:00:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A1046B23;
        Mon, 16 May 2022 12:55:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E102DB81617;
        Mon, 16 May 2022 19:55:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5C0C385AA;
        Mon, 16 May 2022 19:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730904;
        bh=/65BHHgEn+1gWgXBEcRBKSvFqIkhOUARj7hbRXS6LD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZPIl9FU2XKMVCutHrXuny8SDLQXA3WtITDOEuYYcSygbyeSNwqL5jW1h+j4K6ww7
         FzKUnZN9GVR49y/jwleJalLHs/shmbc/299LMKwyZM29kJ4w2QdnNWH8T3ANAUM6Sg
         Lpe4zMjdIG+js0qp2u4VjZ4x3sWYsSxlPTLnyrOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 004/114] mac80211: Reset MBSSID parameters upon connection
Date:   Mon, 16 May 2022 21:35:38 +0200
Message-Id: <20220516193625.621927793@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manikanta Pubbisetty <quic_mpubbise@quicinc.com>

[ Upstream commit 86af062f40a73bf63321694e6bf637144f0383fe ]

Currently MBSSID parameters in struct ieee80211_bss_conf
are not reset upon connection. This could be problematic
with some drivers in a scenario where the device first
connects to a non-transmit BSS and then connects to a
transmit BSS of a Multi BSS AP. The MBSSID parameters
which are set after connecting to a non-transmit BSS will
not be reset and the same parameters will be passed on to
the driver during the subsequent connection to a transmit
BSS of a Multi BSS AP.

For example, firmware running on the ath11k device uses the
Multi BSS data for tracking the beacon of a non-transmit BSS
and reports the driver when there is a beacon miss. If we do
not reset the MBSSID parameters during the subsequent
connection to a transmit BSS, then the driver would have
wrong MBSSID data and FW would be looking for an incorrect
BSSID in the MBSSID beacon of a Multi BSS AP and reports
beacon loss leading to an unstable connection.

Reset the MBSSID parameters upon every connection to solve this
problem.

Fixes: 78ac51f81532 ("mac80211: support multi-bssid")
Signed-off-by: Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
Link: https://lore.kernel.org/r/20220428052744.27040-1-quic_mpubbise@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c4d3e2da73f2..b5ac06b96329 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3574,6 +3574,12 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 				cbss->transmitted_bss->bssid);
 		bss_conf->bssid_indicator = cbss->max_bssid_indicator;
 		bss_conf->bssid_index = cbss->bssid_index;
+	} else {
+		bss_conf->nontransmitted = false;
+		memset(bss_conf->transmitter_bssid, 0,
+		       sizeof(bss_conf->transmitter_bssid));
+		bss_conf->bssid_indicator = 0;
+		bss_conf->bssid_index = 0;
 	}
 
 	/*
-- 
2.35.1



