Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54AB34C8A6
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbhC2IXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:23:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233778AbhC2IWZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:22:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCE276044F;
        Mon, 29 Mar 2021 08:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006145;
        bh=UEQoMXZ6WL4a5lcnMnICIkdCGCryPENNnGQhxaMdqrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=orrk2BT88LizM5aQe7WTw9sDE1KIt+1Vedlj/F8mgKK64bhAssE+3Mmx0e+0X63Nq
         3gp/MW3vKnmVxD2YmRXIsNyv98AYULeV74TSWBuamVNmkG0aPZlKjSoUmSyq8iQJ79
         TTFEl4k1npZ1ckywEBDZg1zNO6oBXVlJkSUTyX2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 133/221] mac80211: fix rate mask reset
Date:   Mon, 29 Mar 2021 09:57:44 +0200
Message-Id: <20210329075633.630474453@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 1944015fe9c1d9fa5e9eb7ffbbb5ef8954d6753b ]

Coverity reported the strange "if (~...)" condition that's
always true. It suggested that ! was intended instead of ~,
but upon further analysis I'm convinced that what really was
intended was a comparison to 0xff/0xffff (in HT/VHT cases
respectively), since this indicates that all of the rates
are enabled.

Change the comparison accordingly.

I'm guessing this never really mattered because a reset to
not having a rate mask is basically equivalent to having a
mask that enables all rates.

Reported-by: Colin Ian King <colin.king@canonical.com>
Fixes: 2ffbe6d33366 ("mac80211: fix and optimize MCS mask handling")
Fixes: b119ad6e726c ("mac80211: add rate mask logic for vht rates")
Reviewed-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20210212112213.36b38078f569.I8546a20c80bc1669058eb453e213630b846e107b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7276e66ae435..2bf6271d9e3f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2961,14 +2961,14 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 			continue;
 
 		for (j = 0; j < IEEE80211_HT_MCS_MASK_LEN; j++) {
-			if (~sdata->rc_rateidx_mcs_mask[i][j]) {
+			if (sdata->rc_rateidx_mcs_mask[i][j] != 0xff) {
 				sdata->rc_has_mcs_mask[i] = true;
 				break;
 			}
 		}
 
 		for (j = 0; j < NL80211_VHT_NSS_MAX; j++) {
-			if (~sdata->rc_rateidx_vht_mcs_mask[i][j]) {
+			if (sdata->rc_rateidx_vht_mcs_mask[i][j] != 0xffff) {
 				sdata->rc_has_vht_mcs_mask[i] = true;
 				break;
 			}
-- 
2.30.1



