Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9533147958C
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 21:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236644AbhLQUhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 15:37:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236749AbhLQUhM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 15:37:12 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E15C06173F
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 12:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=Z1xBn0cs7TXYEXG4OGQRC/Rdhf35EUc8w3X++b+JvcA=; t=1639773432; x=1640983032; 
        b=scDGe+y1fYDurqpOgTnFt9RAw8YuL1KM11AqCL4Qe7n+/hUhrS4Z8DmtKj+yzCuB77R+qVA+kJI
        9PkYiRU3EVfZXw9vSzmcFgxdBN1JCauqDAf46mIgz/ZvOwmfGj0tfETkcYKh6TRw4HKvzcM5NCmuO
        ARukRxmdQw6ttWqM5am0lrn2GVnDO5MBQm6AguhwbG5QBughZmYgIVrMSbwlA0M9e0lHz0fQknIfC
        gksopovLz1kiQNF5uZz0uB3t4CtjVa2Frmg51E/qwePzd6M0BckpOlE13jWf8ikM7pPaZ9EFULmlo
        /WshBMu/gMyERcqvx9zezztiMNXcqdS/rjHw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1myJyX-00CuJN-A6;
        Fri, 17 Dec 2021 21:37:09 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        syzbot+59bdff68edce82e393b6@syzkaller.appspotmail.com
Subject: [PATCH v5.4] mac80211: validate extended element ID is present
Date:   Fri, 17 Dec 2021 21:37:06 +0100
Message-Id: <20211217203706.55031-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.33.1
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
index decd46b38393..c1c117fdf318 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1227,6 +1227,8 @@ _ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
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

