Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659EC469BF0
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348024AbhLFPRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:17:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48838 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356991AbhLFPPv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:15:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18375B8101B;
        Mon,  6 Dec 2021 15:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601F0C341C6;
        Mon,  6 Dec 2021 15:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803540;
        bh=8n2IBl+k1S/Bq+MjR5lhlxC6Vz+D8xdsiTdby2ApKEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RaQpQB2+DwLT2c2joNXh7UEcv7eoXRi2Xp/vFW5F3vP53v4rIwdfaaCwiBVQjvgWR
         4u6hCczCwr7BAsBII38G3PMz5jLCf2xhy3SxmKshEB+5ejLP+7VRwuVZLfcFcBYtKB
         mNuYkI0UyWCoNP3zCfVstNS9xJgYZUfCXZ65sj2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xing Song <xing.song@mediatek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/70] mac80211: do not access the IV when it was stripped
Date:   Mon,  6 Dec 2021 15:56:11 +0100
Message-Id: <20211206145552.165501354@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
References: <20211206145551.909846023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xing Song <xing.song@mediatek.com>

[ Upstream commit 77dfc2bc0bb4b8376ecd7a430f27a4a8fff6a5a0 ]

ieee80211_get_keyid() will return false value if IV has been stripped,
such as return 0 for IP/ARP frames due to LLC header, and return -EINVAL
for disassociation frames due to its length... etc. Don't try to access
it if it's not present.

Signed-off-by: Xing Song <xing.song@mediatek.com>
Link: https://lore.kernel.org/r/20211101024657.143026-1-xing.song@mediatek.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c7e6bf7c22c78..282bf336b15a4 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1918,7 +1918,8 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 		int keyid = rx->sta->ptk_idx;
 		sta_ptk = rcu_dereference(rx->sta->ptk[keyid]);
 
-		if (ieee80211_has_protected(fc)) {
+		if (ieee80211_has_protected(fc) &&
+		    !(status->flag & RX_FLAG_IV_STRIPPED)) {
 			cs = rx->sta->cipher_scheme;
 			keyid = ieee80211_get_keyid(rx->skb, cs);
 
-- 
2.33.0



