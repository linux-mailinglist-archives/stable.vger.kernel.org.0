Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9FC12C6AE
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731646AbfL2Rt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:49:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:33230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731294AbfL2Rt0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:49:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 910AC20718;
        Sun, 29 Dec 2019 17:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641766;
        bh=se1BIkBtvl3Jf62AntvouJyn75kBQxgPGW67kB+oNVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aCOoncZgHHtRNUKx1BtJ0m6lY3q0YY7J0GTIr0f1lwFEl6i8H75gGq+eHMdRDKPNm
         QeiBa/dmikwsYES09cWmajSsgI++BlBfL2OQMRU8R7Obb9GP7HxA5PFx00DWm/Lpkq
         RVPgQiB409qlGlNPLTUph6R69zNzyKdAQxxiUknc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Adham Abozaeid <adham.abozaeid@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 203/434] staging: wilc1000: check if device is initialzied before changing vif
Date:   Sun, 29 Dec 2019 18:24:16 +0100
Message-Id: <20191229172715.312996737@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 22f21831649b..c3cd6f389a98 100644
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



