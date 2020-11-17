Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF1362B6314
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730795AbgKQNej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:34:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:45058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732202AbgKQNeg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:34:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52E2A2078E;
        Tue, 17 Nov 2020 13:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620075;
        bh=1jTr55gaoyGw5R902U7nFxaSS5hrWwmAkLllFm2nUrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vDCV3NdKPQhpXxIsOhlCYnLIDgGdWzX8zEbNfcZILLNvJDMoJgxB7eKy5cTy1Kfvv
         gUxsBxPCdfbbNwmzB6wEKhRnLvS9sddPbFEcPpk/PSG5GvqZZvEvsiJ7fnmx+xfoZ7
         fQURSaFVRfP8Fx4CxC73P/9xaaMKq//WqNDdKf9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Ye Bin <yebin10@huawei.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 100/255] cfg80211: regulatory: Fix inconsistent format argument
Date:   Tue, 17 Nov 2020 14:04:00 +0100
Message-Id: <20201117122143.823648077@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit db18d20d1cb0fde16d518fb5ccd38679f174bc04 ]

Fix follow warning:
[net/wireless/reg.c:3619]: (warning) %d in format string (no. 2)
requires 'int' but the argument type is 'unsigned int'.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Ye Bin <yebin10@huawei.com>
Link: https://lore.kernel.org/r/20201009070215.63695-1-yebin10@huawei.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index d8a90d3974235..763a45655ac21 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3411,7 +3411,7 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
 		power_rule = &reg_rule->power_rule;
 
 		if (reg_rule->flags & NL80211_RRF_AUTO_BW)
-			snprintf(bw, sizeof(bw), "%d KHz, %d KHz AUTO",
+			snprintf(bw, sizeof(bw), "%d KHz, %u KHz AUTO",
 				 freq_range->max_bandwidth_khz,
 				 reg_get_max_bandwidth(rd, reg_rule));
 		else
-- 
2.27.0



