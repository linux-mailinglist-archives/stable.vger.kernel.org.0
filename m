Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA2731196B2
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfLJV20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:28:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:60306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728484AbfLJVK0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:10:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B60172077B;
        Tue, 10 Dec 2019 21:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012225;
        bh=pDb99hDHnLaIQT5+IsVMp+MuY1aORJ5mKqZBYwYdPOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tK+H1tzd2f6QJYRM10FV0BQOWxIdCa7PcB1bzzSFEpmYwTSfc6axC4OM95bUezzQK
         fyqFwGIfavKx+e9C2OIFh0IPoL50INauhb3uCtmI2q3YapMpZm6NUQmmKl5iE4D8Ya
         zEpCDpthwRU/np4F62og/ObXsb4at2Q2WGC9egA0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adham Abozaeid <adham.abozaeid@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.4 175/350] staging: wilc1000: check if device is initialzied before changing vif
Date:   Tue, 10 Dec 2019 16:04:40 -0500
Message-Id: <20191210210735.9077-136-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adham Abozaeid <adham.abozaeid@microchip.com>

[ Upstream commit 6df6f3849bb8f317bf2d52711aacea4292237ede ]

When killing hostapd, the interface is closed which deinitializes the
device, then change virtual interface is called.
This change checks if the device is initialized before sending the
interface change command to the device

Signed-off-by: Adham Abozaeid <adham.abozaeid@microchip.com>
Link: https://lore.kernel.org/r/20191028184019.31194-1-adham.abozaeid@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/wilc1000/wilc_wfi_cfgoperations.c  | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 22f21831649bd..c3cd6f389a989 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1419,8 +1419,10 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		if (vif->iftype == WILC_AP_MODE || vif->iftype == WILC_GO_MODE)
 			wilc_wfi_deinit_mon_interface(wl, true);
 		vif->iftype = WILC_STATION_MODE;
-		wilc_set_operation_mode(vif, wilc_get_vif_idx(vif),
-					WILC_STATION_MODE, vif->idx);
+
+		if (wl->initialized)
+			wilc_set_operation_mode(vif, wilc_get_vif_idx(vif),
+						WILC_STATION_MODE, vif->idx);
 
 		memset(priv->assoc_stainfo.sta_associated_bss, 0,
 		       WILC_MAX_NUM_STA * ETH_ALEN);
@@ -1432,8 +1434,10 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		priv->wdev.iftype = type;
 		vif->monitor_flag = 0;
 		vif->iftype = WILC_CLIENT_MODE;
-		wilc_set_operation_mode(vif, wilc_get_vif_idx(vif),
-					WILC_STATION_MODE, vif->idx);
+
+		if (wl->initialized)
+			wilc_set_operation_mode(vif, wilc_get_vif_idx(vif),
+						WILC_STATION_MODE, vif->idx);
 		break;
 
 	case NL80211_IFTYPE_AP:
@@ -1450,8 +1454,10 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev.iftype = type;
 		vif->iftype = WILC_GO_MODE;
-		wilc_set_operation_mode(vif, wilc_get_vif_idx(vif),
-					WILC_AP_MODE, vif->idx);
+
+		if (wl->initialized)
+			wilc_set_operation_mode(vif, wilc_get_vif_idx(vif),
+						WILC_AP_MODE, vif->idx);
 		break;
 
 	default:
-- 
2.20.1

