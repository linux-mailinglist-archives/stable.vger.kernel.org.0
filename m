Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6BC440E081
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241550AbhIPQVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:21:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241713AbhIPQUC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:20:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B754361246;
        Thu, 16 Sep 2021 16:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808850;
        bh=5Tmo5EoUoUNPILBlPgR5l9L/1NDvicyyvoVo8uwBhKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m89ZXVvF+pXpuXesv2Fcz7Ydf2Xyiks1+PhOdSBOdjqRsraHdc6RT+2S/NoUPkJkv
         dt00/ppFVQOHS9TC3N0BEV4nB+KTZC0idTl6K+XNxhnoGbkr8qoix4Tq8ktHiG0qBh
         9boZmtA1GlodRG0czFoWqdI7F3Pg74FeHGUPrrn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 213/306] mac80211: Fix monitor MTU limit so that A-MSDUs get through
Date:   Thu, 16 Sep 2021 17:59:18 +0200
Message-Id: <20210916155801.301283700@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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
index 30589b4c09da..3a15ef8dd322 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -2000,9 +2000,16 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
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
 
 		ret = register_netdevice(ndev);
 		if (ret) {
-- 
2.30.2



