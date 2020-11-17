Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAA22B6559
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731351AbgKQNyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:54:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:60650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731165AbgKQNZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:25:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EDE520781;
        Tue, 17 Nov 2020 13:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619517;
        bh=MLrSMe0LNFlLFy9vkLziluBQnqB5lpVCd2LuDcTLal4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/1XvQU4MQpHASRyybKwCEkn5yZFzvHC15T/Ftk6NBFa42b4S2j56Pjj8IKRvWYI6
         mstF/Lv8SJhpn2gangCVj3i3TdOQ4srJtpgtj2yS/DsWXsmUNCH7ymQRI6znDobSgh
         Ppgyuib5v7h+1fn6kZ+thW3wrFCSomdBoK8B4zrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Ye Bin <yebin10@huawei.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 065/151] cfg80211: regulatory: Fix inconsistent format argument
Date:   Tue, 17 Nov 2020 14:04:55 +0100
Message-Id: <20201117122124.583605201@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
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
index 20a8e6af88c45..0f3b57a73670b 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3405,7 +3405,7 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
 		power_rule = &reg_rule->power_rule;
 
 		if (reg_rule->flags & NL80211_RRF_AUTO_BW)
-			snprintf(bw, sizeof(bw), "%d KHz, %d KHz AUTO",
+			snprintf(bw, sizeof(bw), "%d KHz, %u KHz AUTO",
 				 freq_range->max_bandwidth_khz,
 				 reg_get_max_bandwidth(rd, reg_rule));
 		else
-- 
2.27.0



