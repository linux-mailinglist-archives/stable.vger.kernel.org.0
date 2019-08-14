Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28EAC8DA39
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729608AbfHNRQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:16:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728886AbfHNROc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:14:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F29BD20665;
        Wed, 14 Aug 2019 17:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802871;
        bh=WWdtclU8aMzAP9fCCYl2gNsuul0ymzZGOQH/w5oVOgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vo3dtpT8mji3o1EI6ZQdFvgE9P0v1aEaU5CUoo0Q30RGD4jzy7EbZXsKfDzGmtjBl
         E1KfJIcQjnCYnUeWDdcbN34tL0SavRzdCLEmZ1vbXW+NnwNTfI4s6ZPoX2eFOCQg2L
         rP/1Jh0LGbgQufiDTrRswr4pxI6jrvxKVQPnuiBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.14 59/69] mac80211: dont WARN on short WMM parameters from AP
Date:   Wed, 14 Aug 2019 19:01:57 +0200
Message-Id: <20190814165749.524255625@linuxfoundation.org>
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

From: Brian Norris <briannorris@chromium.org>

commit 05aaa5c97dce4c10a9e7eae2f1569a684e0c5ced upstream.

In a very similar spirit to commit c470bdc1aaf3 ("mac80211: don't WARN
on bad WMM parameters from buggy APs"), an AP may not transmit a
fully-formed WMM IE. For example, it may miss or repeat an Access
Category. The above loop won't catch that and will instead leave one of
the four ACs zeroed out. This triggers the following warning in
drv_conf_tx()

  wlan0: invalid CW_min/CW_max: 0/0

and it may leave one of the hardware queues unconfigured. If we detect
such a case, let's just print a warning and fall back to the defaults.

Tested with a hacked version of hostapd, intentionally corrupting the
IEs in hostapd_eid_wmm().

Cc: stable@vger.kernel.org
Signed-off-by: Brian Norris <briannorris@chromium.org>
Link: https://lore.kernel.org/r/20190726224758.210953-1-briannorris@chromium.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/mlme.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1867,6 +1867,16 @@ static bool ieee80211_sta_wmm_params(str
 		}
 	}
 
+	/* WMM specification requires all 4 ACIs. */
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		if (params[ac].cw_min == 0) {
+			sdata_info(sdata,
+				   "AP has invalid WMM params (missing AC %d), using defaults\n",
+				   ac);
+			return false;
+		}
+	}
+
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		mlme_dbg(sdata,
 			 "WMM AC=%d acm=%d aifs=%d cWmin=%d cWmax=%d txop=%d uapsd=%d, downgraded=%d\n",


