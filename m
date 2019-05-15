Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A248F1F12A
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbfEOLVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:21:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730700AbfEOLVh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:21:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B93E820843;
        Wed, 15 May 2019 11:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919296;
        bh=w5bdYzHACanwOF0KV2kSSzyZ4JFPkznJRKgzkbWXsQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZKOJbLiw6ps7Gv1hsfN0cOyyz43hgZxLN7qAbB8ql20n3X4UGP8dqjDnCOnW1l7ar
         TitThzDZ8X9R5wIJ/2e8odqM5WECkoZI4pc76E7P2xNiXCTqSP+svxnes/fbhcVoDA
         5RB6i2nEs17DzOXZAK6LZWjeCLVueim7gGJSsFPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 021/113] cfg80211: Handle WMM rules in regulatory domain intersection
Date:   Wed, 15 May 2019 12:55:12 +0200
Message-Id: <20190515090655.077512576@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 08a75a887ee46828b54600f4bb7068d872a5edd5 ]

The support added for regulatory WMM rules did not handle
the case of regulatory domain intersections. Fix it.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Fixes: 230ebaa189af ("cfg80211: read wmm rules from regulatory database")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/reg.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 8002ace7c9f65..8a47297ff206d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1287,6 +1287,16 @@ reg_intersect_dfs_region(const enum nl80211_dfs_regions dfs_region1,
 	return dfs_region1;
 }
 
+static void reg_wmm_rules_intersect(const struct ieee80211_wmm_ac *wmm_ac1,
+				    const struct ieee80211_wmm_ac *wmm_ac2,
+				    struct ieee80211_wmm_ac *intersect)
+{
+	intersect->cw_min = max_t(u16, wmm_ac1->cw_min, wmm_ac2->cw_min);
+	intersect->cw_max = max_t(u16, wmm_ac1->cw_max, wmm_ac2->cw_max);
+	intersect->cot = min_t(u16, wmm_ac1->cot, wmm_ac2->cot);
+	intersect->aifsn = max_t(u8, wmm_ac1->aifsn, wmm_ac2->aifsn);
+}
+
 /*
  * Helper for regdom_intersect(), this does the real
  * mathematical intersection fun
@@ -1301,6 +1311,8 @@ static int reg_rules_intersect(const struct ieee80211_regdomain *rd1,
 	struct ieee80211_freq_range *freq_range;
 	const struct ieee80211_power_rule *power_rule1, *power_rule2;
 	struct ieee80211_power_rule *power_rule;
+	const struct ieee80211_wmm_rule *wmm_rule1, *wmm_rule2;
+	struct ieee80211_wmm_rule *wmm_rule;
 	u32 freq_diff, max_bandwidth1, max_bandwidth2;
 
 	freq_range1 = &rule1->freq_range;
@@ -1311,6 +1323,10 @@ static int reg_rules_intersect(const struct ieee80211_regdomain *rd1,
 	power_rule2 = &rule2->power_rule;
 	power_rule = &intersected_rule->power_rule;
 
+	wmm_rule1 = &rule1->wmm_rule;
+	wmm_rule2 = &rule2->wmm_rule;
+	wmm_rule = &intersected_rule->wmm_rule;
+
 	freq_range->start_freq_khz = max(freq_range1->start_freq_khz,
 					 freq_range2->start_freq_khz);
 	freq_range->end_freq_khz = min(freq_range1->end_freq_khz,
@@ -1354,6 +1370,29 @@ static int reg_rules_intersect(const struct ieee80211_regdomain *rd1,
 	intersected_rule->dfs_cac_ms = max(rule1->dfs_cac_ms,
 					   rule2->dfs_cac_ms);
 
+	if (rule1->has_wmm && rule2->has_wmm) {
+		u8 ac;
+
+		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+			reg_wmm_rules_intersect(&wmm_rule1->client[ac],
+						&wmm_rule2->client[ac],
+						&wmm_rule->client[ac]);
+			reg_wmm_rules_intersect(&wmm_rule1->ap[ac],
+						&wmm_rule2->ap[ac],
+						&wmm_rule->ap[ac]);
+		}
+
+		intersected_rule->has_wmm = true;
+	} else if (rule1->has_wmm) {
+		*wmm_rule = *wmm_rule1;
+		intersected_rule->has_wmm = true;
+	} else if (rule2->has_wmm) {
+		*wmm_rule = *wmm_rule2;
+		intersected_rule->has_wmm = true;
+	} else {
+		intersected_rule->has_wmm = false;
+	}
+
 	if (!is_valid_reg_rule(intersected_rule))
 		return -EINVAL;
 
-- 
2.20.1



