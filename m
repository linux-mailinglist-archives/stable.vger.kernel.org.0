Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED238D9E5
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730828AbfHNRNV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:13:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730870AbfHNRNV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:13:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB02320665;
        Wed, 14 Aug 2019 17:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802800;
        bh=/Ff2BB1YQa4gCwavzBkOv5LyIublasKxglhj1JWbgpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xe2B1o7GjBq78cbzHj4vBYEs4s6FJ1/LzRacsKtbzxn+x930EpJe/IdbGZ+pkJrWn
         nlEKkzaKSDb7DZNzqXfSEnCOuya4DJJ5Gz1Vl2OcIaf0WNyR5PpJ67Pp7PIesWFMpj
         czdTaigAfytYhmpfrlzT/XXZmQkbZEx8GyEDRDG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 31/69] mac80211: dont warn about CW params when not using them
Date:   Wed, 14 Aug 2019 19:01:29 +0200
Message-Id: <20190814165747.681162081@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d2b3fe42bc629c2d4002f652b3abdfb2e72991c7 ]

ieee80211_set_wmm_default() normally sets up the initial CW min/max for
each queue, except that it skips doing this if the driver doesn't
support ->conf_tx. We still end up calling drv_conf_tx() in some cases
(e.g., ieee80211_reconfig()), which also still won't do anything
useful...except it complains here about the invalid CW parameters.

Let's just skip the WARN if we weren't going to do anything useful with
the parameters.

Signed-off-by: Brian Norris <briannorris@chromium.org>
Link: https://lore.kernel.org/r/20190718015712.197499-1-briannorris@chromium.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/driver-ops.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index bb886e7db47f1..f783d1377d9a8 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -169,11 +169,16 @@ int drv_conf_tx(struct ieee80211_local *local,
 	if (!check_sdata_in_driver(sdata))
 		return -EIO;
 
-	if (WARN_ONCE(params->cw_min == 0 ||
-		      params->cw_min > params->cw_max,
-		      "%s: invalid CW_min/CW_max: %d/%d\n",
-		      sdata->name, params->cw_min, params->cw_max))
+	if (params->cw_min == 0 || params->cw_min > params->cw_max) {
+		/*
+		 * If we can't configure hardware anyway, don't warn. We may
+		 * never have initialized the CW parameters.
+		 */
+		WARN_ONCE(local->ops->conf_tx,
+			  "%s: invalid CW_min/CW_max: %d/%d\n",
+			  sdata->name, params->cw_min, params->cw_max);
 		return -EINVAL;
+	}
 
 	trace_drv_conf_tx(local, sdata, ac, params);
 	if (local->ops->conf_tx)
-- 
2.20.1



