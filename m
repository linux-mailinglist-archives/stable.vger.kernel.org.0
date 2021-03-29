Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A685134C7C2
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbhC2ISK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:18:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233148AbhC2IQk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:16:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF14A61477;
        Mon, 29 Mar 2021 08:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005774;
        bh=QzKNGjYBXGZvK+0oTzQfokndILUCu4ieBs+xb2Nd4sg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qDdMevvFktCYf1ED8SDn84x2yZnf7mEiA0SuKk5tTFykMMK2tfHezpx5lmwknIHlW
         iiQZ1wmSpL+7dUDHjjiBSMjIlQwn75FzEedwOnHbdm/CWUoSLfG9oTG+7eFrOBc/QZ
         TRTJ/hgDhd6Los4Tj4/2zVAS1NoixbxbaiG3L9t8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 077/111] mac80211: fix rate mask reset
Date:   Mon, 29 Mar 2021 09:58:25 +0200
Message-Id: <20210329075617.775630786@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
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
index fa293feef935..677928bf13d1 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2906,14 +2906,14 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
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



