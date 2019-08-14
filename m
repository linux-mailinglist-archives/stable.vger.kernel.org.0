Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6149E8DB89
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfHNR0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:26:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728576AbfHNRFN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:05:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB628208C2;
        Wed, 14 Aug 2019 17:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802312;
        bh=X2Xp1Ub7iOB42ET/E+acLVe+OBzEfYU8mumcHqqqrwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U3Z1LHF+rrcmwP5slC8bMbJNILEBoXEIIdU9HWN17tAGBXE5EUVtWclYtlZCHAW9j
         VA5J+SMzV1XQ9covLpgxXq9VZKu7JagICLPvKEWULdLLzi5hDpfWeMo7Nvpbe8v2YM
         yjhdqR5oZFDrZhfyF3Jl/GIVQQlQTF4Q64+c73S0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 076/144] mac80211: fix possible memory leak in ieee80211_assign_beacon
Date:   Wed, 14 Aug 2019 19:00:32 +0200
Message-Id: <20190814165803.034950064@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit bcc27fab8cc673ddc95452674373cce618ccb3a3 ]

Free new beacon_data in ieee80211_assign_beacon whenever
ieee80211_assign_beacon fails

Fixes: 8860020e0be1 ("cfg80211: restructure AP/GO mode API")
Fixes: bc847970f432 ("mac80211: support FTM responder configuration/statistic")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/770285772543c9fca33777bb4ad4760239e56256.1562105631.git.lorenzo@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a1973a26c7fc4..b8288125e05db 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -935,8 +935,10 @@ static int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 
 	err = ieee80211_set_probe_resp(sdata, params->probe_resp,
 				       params->probe_resp_len, csa);
-	if (err < 0)
+	if (err < 0) {
+		kfree(new);
 		return err;
+	}
 	if (err == 0)
 		changed |= BSS_CHANGED_AP_PROBE_RESP;
 
@@ -948,8 +950,10 @@ static int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 							 params->civicloc,
 							 params->civicloc_len);
 
-		if (err < 0)
+		if (err < 0) {
+			kfree(new);
 			return err;
+		}
 
 		changed |= BSS_CHANGED_FTM_RESPONDER;
 	}
-- 
2.20.1



