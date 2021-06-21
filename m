Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5015D3AEF4E
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbhFUQhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:37:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233092AbhFUQfH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:35:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB086613EE;
        Mon, 21 Jun 2021 16:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292867;
        bh=vP3ScztuWnr/JyucZzR+HDQwCAf3QOVJPTpMAbi2NEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e3IvtkQNAwKX8uyHuavhoLEj0UJDqQYJ8lRBpUZp/sIY6EMnObHacwC3NYgONt7IZ
         Fpd5Px5P7tcAEghk01PdpRqw30m8VBm4DIWkqf+JfVajbovBJ+SFDsTL+jxyoEYdFv
         +Cw3N59ZTDpHCa4ddau/KssSLk3ScfnRIrI/OwWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 014/178] staging: rtl8723bs: fix monitor netdev register/unregister
Date:   Mon, 21 Jun 2021 18:13:48 +0200
Message-Id: <20210621154922.085150419@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit b90f51e8e1f5014c01c82a7bf4c611643d0a8bcb ]

Due to the locking changes and callbacks happening inside
cfg80211, we need to use cfg80211 versions of the register
and unregister functions if called within cfg80211 methods,
otherwise deadlocks occur.

Fixes: a05829a7222e ("cfg80211: avoid holding the RTNL when calling the driver")
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20210426212801.3d902cc9e6f4.Ie0b1e0c545920c61400a4b7d0f384ea61feb645a@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
index cbec65e5a464..62ea47f9fee5 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -2579,7 +2579,7 @@ static int rtw_cfg80211_add_monitor_if(struct adapter *padapter, char *name, str
 	mon_wdev->iftype = NL80211_IFTYPE_MONITOR;
 	mon_ndev->ieee80211_ptr = mon_wdev;
 
-	ret = register_netdevice(mon_ndev);
+	ret = cfg80211_register_netdevice(mon_ndev);
 	if (ret) {
 		goto out;
 	}
@@ -2661,7 +2661,7 @@ static int cfg80211_rtw_del_virtual_intf(struct wiphy *wiphy,
 	adapter = rtw_netdev_priv(ndev);
 	pwdev_priv = adapter_wdev_data(adapter);
 
-	unregister_netdevice(ndev);
+	cfg80211_unregister_netdevice(ndev);
 
 	if (ndev == pwdev_priv->pmon_ndev) {
 		pwdev_priv->pmon_ndev = NULL;
-- 
2.30.2



