Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E284479586
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 21:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbhLQUf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 15:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236873AbhLQUf7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 15:35:59 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5200C06173E
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 12:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=Q7Nax3PxMl3HjWfdHLh+2+AV949t4rDho0Xmp3u7kTc=;
        t=1639773358; x=1640982958; b=HI1Yj1zHD0DOtboV5OCS3K31cSoltwo1cGXx/wXcjnciUv6
        qqxpCMaESBr1sgp5b8o0m60wH7lkcyp0vt3pGx69Wc/Scdpexm9olprTvxAzO3kLjVg+0U6cQ/DFE
        ZPiZgWC6G3SQcRLBi8xOSjnCdB4RqMvP0o7JVdecRyqpoMasOs8EPHbtqnFfvr8TbWgGb+LCC2KMZ
        oIAR/BZAyKUKlP4O4SKnn4LoVqcnPSgmjMZUyGRy0mTcFUxheMBhQObFpBUJKAKBbcoCsHAA81ESc
        +6NF2mG60pd54hADe5uVGZJrhg5mC67zmffvD4usmr0H207OLg5Wm+ZFC2ErpZGg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1myJxL-00CuHI-0T;
        Fri, 17 Dec 2021 21:35:55 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        syzbot+59bdff68edce82e393b6@syzkaller.appspotmail.com
Subject: [PATCH v4.19 2/2] mac80211: validate extended element ID is present
Date:   Fri, 17 Dec 2021 21:35:50 +0100
Message-Id: <20211217203550.54684-2-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211217203550.54684-1-johannes@sipsolutions.net>
References: <20211217203550.54684-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Commit 768c0b19b50665e337c96858aa2b7928d6dcf756 upstream.

Before attempting to parse an extended element, verify that
the extended element ID is present.

Fixes: 41cbb0f5a295 ("mac80211: add support for HE")
Reported-by: syzbot+59bdff68edce82e393b6@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20211211201023.f30a1b128c07.I5cacc176da94ba316877c6e10fe3ceec8b4dbd7d@changeid
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7fa9871b1db9..9c1a20ca6344 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1102,6 +1102,8 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 				elems->max_idle_period_ie = (void *)pos;
 			break;
 		case WLAN_EID_EXTENSION:
+			if (!elen)
+				break;
 			if (pos[0] == WLAN_EID_EXT_HE_MU_EDCA &&
 			    elen >= (sizeof(*elems->mu_edca_param_set) + 1)) {
 				elems->mu_edca_param_set = (void *)&pos[1];
-- 
2.33.1

