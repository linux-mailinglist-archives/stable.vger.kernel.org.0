Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2E62B6611
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730014AbgKQNOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:14:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:45250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730040AbgKQNOW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:14:22 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20001221EB;
        Tue, 17 Nov 2020 13:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618861;
        bh=UE8TG4E8KEuyum8GqKuE75XwJYIocEuD5stFJ29F2aU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u5EpnorfuoFWZNWGvr0a7PqVqd4hzd90nW36zJRBgZx1VR6ksZVOiribaJ3O9wTVn
         jjYVrc5mjBnHyVTt4yVYxqOmmhpJpNS6vOoiFKPdiat+Bn1dF/dBfre6s7H0Hkdaxc
         TQ03rzB7Jq0FuVjkXNJGVKetgW3fh/zDdBtM7a+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Ye Bin <yebin10@huawei.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 31/85] cfg80211: regulatory: Fix inconsistent format argument
Date:   Tue, 17 Nov 2020 14:05:00 +0100
Message-Id: <20201117122112.554995551@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122111.018425544@linuxfoundation.org>
References: <20201117122111.018425544@linuxfoundation.org>
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
index 9eb9d34cef7b1..db8cc505caf76 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2846,7 +2846,7 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
 		power_rule = &reg_rule->power_rule;
 
 		if (reg_rule->flags & NL80211_RRF_AUTO_BW)
-			snprintf(bw, sizeof(bw), "%d KHz, %d KHz AUTO",
+			snprintf(bw, sizeof(bw), "%d KHz, %u KHz AUTO",
 				 freq_range->max_bandwidth_khz,
 				 reg_get_max_bandwidth(rd, reg_rule));
 		else
-- 
2.27.0



