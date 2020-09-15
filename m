Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F8426B695
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgIPAHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:07:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726955AbgIOO2g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:28:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F951224BD;
        Tue, 15 Sep 2020 14:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179610;
        bh=YB6LMn6dVIAQQecjsMuXES5wSTgr8G+mlKOQ3KV/a/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CqqIYcFlo7gkagibqiswmGvrQIZhFQkvrI+NLBeCriBTDO+cwFW4o+tM+qNUP/ksR
         4jmm9wt1D3DLzBeRe++86yMkIZVF8t/t4BqVoi/zsMuznqE/boPJtHzkQ7RnWflE2K
         MXcv4TxGZdQbS+k3+DmoB8LR0YxsRslv7Di5auVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amar Singhal <asinghal@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 048/132] cfg80211: Adjust 6 GHz frequency to channel conversion
Date:   Tue, 15 Sep 2020 16:12:30 +0200
Message-Id: <20200915140646.520323779@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amar Singhal <asinghal@codeaurora.org>

[ Upstream commit 2d9b55508556ccee6410310fb9ea2482fd3328eb ]

Adjust the 6 GHz frequency to channel conversion function,
the other way around was previously handled.

Signed-off-by: Amar Singhal <asinghal@codeaurora.org>
Link: https://lore.kernel.org/r/1592599921-10607-1-git-send-email-asinghal@codeaurora.org
[rewrite commit message, hard-code channel 2]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 8481e9ac33da5..9abafd76ec50e 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -116,11 +116,13 @@ int ieee80211_frequency_to_channel(int freq)
 		return (freq - 2407) / 5;
 	else if (freq >= 4910 && freq <= 4980)
 		return (freq - 4000) / 5;
-	else if (freq < 5945)
+	else if (freq < 5925)
 		return (freq - 5000) / 5;
+	else if (freq == 5935)
+		return 2;
 	else if (freq <= 45000) /* DMG band lower limit */
-		/* see 802.11ax D4.1 27.3.22.2 */
-		return (freq - 5940) / 5;
+		/* see 802.11ax D6.1 27.3.22.2 */
+		return (freq - 5950) / 5;
 	else if (freq >= 58320 && freq <= 70200)
 		return (freq - 56160) / 2160;
 	else
-- 
2.25.1



