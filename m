Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91764B92C1
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391775AbfITOfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:35:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36058 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388136AbfITOZE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:04 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqH-000512-Mp; Fri, 20 Sep 2019 15:25:01 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqG-0007xc-Vs; Fri, 20 Sep 2019 15:25:00 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Johannes Berg" <johannes.berg@intel.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.510943168@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 108/132] mac80211: drop robust management frames from
 unknown TA
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 588f7d39b3592a36fb7702ae3b8bdd9be4621e2f upstream.

When receiving a robust management frame, drop it if we don't have
rx->sta since then we don't have a security association and thus
couldn't possibly validate the frame.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/mac80211/rx.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3084,6 +3084,8 @@ static bool prepare_for_handlers(struct
 	case NL80211_IFTYPE_STATION:
 		if (!bssid && !sdata->u.mgd.use_4addr)
 			return false;
+		if (ieee80211_is_robust_mgmt_frame(skb) && !rx->sta)
+			return false;
 		if (!multicast &&
 		    !ether_addr_equal(sdata->vif.addr, hdr->addr1)) {
 			if (!(sdata->dev->flags & IFF_PROMISC) ||

