Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC08234C6BF
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbhC2IJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:09:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231707AbhC2IJD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:09:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24D8061601;
        Mon, 29 Mar 2021 08:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005342;
        bh=v4kgBf59sePydDE3V+pt/j20NEXhADvol6n1p2zDM38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTcQ8CiYNeEI4+MkbHwmY6yxrJRnlPuk/YvP7b1YoGyfeZ2KZG2tPEotnQWm9/By/
         JcF6mjwzPZDrUxglj017BFBFcXEgcNYg9Gc49E3ihgUOnU8UZtYu2vw4G1DpK9pJTl
         DWBWVA9WGA95OLQ5DUUbagzT4eg77jYk4N7wjqyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 48/72] mac80211: fix rate mask reset
Date:   Mon, 29 Mar 2021 09:58:24 +0200
Message-Id: <20210329075611.870401797@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075610.300795746@linuxfoundation.org>
References: <20210329075610.300795746@linuxfoundation.org>
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
index 9926455dd546..f484f9fc62ca 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2777,14 +2777,14 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
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



