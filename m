Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7BF40E7E4
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347698AbhIPRgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:36:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348538AbhIPRc3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:32:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5AA761504;
        Thu, 16 Sep 2021 16:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810871;
        bh=xHfzP72TZyDPRk8pGAwmlKS+B0g1x+9BYa0SUdCdils=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=um3/AnRm6J1EtDpVf4e7hSg8o2/7oqq/V3Zq+PJs0UkLUKgUTJh9koJkdqUxE7dnK
         HJFIYj8TefTGzBHUaR8/wjLHz7FTOQFkUWys7aYVXjcyMbY4Lbfkk8PGcH/Iuxez+J
         NXy3JCFXRDk50W21l1juEd607qlr064r311Ahcps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 297/432] mac80211: Fix monitor MTU limit so that A-MSDUs get through
Date:   Thu, 16 Sep 2021 18:00:46 +0200
Message-Id: <20210916155820.896912477@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Almbladh <johan.almbladh@anyfinetworks.com>

[ Upstream commit 79f5962baea74ce1cd4e5949598944bff854b166 ]

The maximum MTU was set to 2304, which is the maximum MSDU size. While
this is valid for normal WLAN interfaces, it is too low for monitor
interfaces. A monitor interface may receive and inject MPDU frames, and
the maximum MPDU frame size is larger than 2304. The MPDU may also
contain an A-MSDU frame, in which case the size may be much larger than
the MTU limit. Since the maximum size of an A-MSDU depends on the PHY
mode of the transmitting STA, it is not possible to set an exact MTU
limit for a monitor interface. Now the maximum MTU for a monitor
interface is unrestricted.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Link: https://lore.kernel.org/r/20210628123246.2070558-1-johan.almbladh@anyfinetworks.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/iface.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 1e5e9fc45523..cd96cd337aa8 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -2001,9 +2001,16 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 		netdev_set_default_ethtool_ops(ndev, &ieee80211_ethtool_ops);
 
-		/* MTU range: 256 - 2304 */
+		/* MTU range is normally 256 - 2304, where the upper limit is
+		 * the maximum MSDU size. Monitor interfaces send and receive
+		 * MPDU and A-MSDU frames which may be much larger so we do
+		 * not impose an upper limit in that case.
+		 */
 		ndev->min_mtu = 256;
-		ndev->max_mtu = local->hw.max_mtu;
+		if (type == NL80211_IFTYPE_MONITOR)
+			ndev->max_mtu = 0;
+		else
+			ndev->max_mtu = local->hw.max_mtu;
 
 		ret = cfg80211_register_netdevice(ndev);
 		if (ret) {
-- 
2.30.2



