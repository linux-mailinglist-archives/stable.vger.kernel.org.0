Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1803314E53
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfEFOll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:41:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728285AbfEFOlk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:41:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F61E20C01;
        Mon,  6 May 2019 14:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153699;
        bh=lRNIYmFIsCxmdjlVSc56AtBFUVHBM4tCJ2q0ZlP67uE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VdPhXCmF3hmqeBBwQURdVgVXmWq5F5dssbEzElbkSJIyhjiLeNqovv6CGOmxVtHJl
         p18rPKISZRiuSyBLn57plOIAeKBy9zRIKW8fc2FzO2BL3z+t4MNIXaPcxgQUrraUVJ
         lm1FaE2qrcJJDVvOT7GnzV8dLoodfz05iLMEAL0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 29/99] batman-adv: fix warning in function batadv_v_elp_get_throughput
Date:   Mon,  6 May 2019 16:32:02 +0200
Message-Id: <20190506143056.596637433@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ca8c3b922e7032aff6cc3fd05548f4df1f3df90e ]

When CONFIG_CFG80211 isn't enabled the compiler correcly warns about
'sinfo.pertid' may be unused. It can also happen for other error
conditions that it not warn about.

net/batman-adv/bat_v_elp.c: In function ‘batadv_v_elp_get_throughput.isra.0’:
include/net/cfg80211.h:6370:13: warning: ‘sinfo.pertid’ may be used
 uninitialized in this function [-Wmaybe-uninitialized]
  kfree(sinfo->pertid);
        ~~~~~^~~~~~~~

Rework so that we only release '&sinfo' if cfg80211_get_station returns
zero.

Fixes: 7d652669b61d ("batman-adv: release station info tidstats")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bat_v_elp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/bat_v_elp.c b/net/batman-adv/bat_v_elp.c
index ef0dec20c7d8..5da183b2f4c9 100644
--- a/net/batman-adv/bat_v_elp.c
+++ b/net/batman-adv/bat_v_elp.c
@@ -104,8 +104,10 @@ static u32 batadv_v_elp_get_throughput(struct batadv_hardif_neigh_node *neigh)
 
 		ret = cfg80211_get_station(real_netdev, neigh->addr, &sinfo);
 
-		/* free the TID stats immediately */
-		cfg80211_sinfo_release_content(&sinfo);
+		if (!ret) {
+			/* free the TID stats immediately */
+			cfg80211_sinfo_release_content(&sinfo);
+		}
 
 		dev_put(real_netdev);
 		if (ret == -ENOENT) {
-- 
2.20.1



