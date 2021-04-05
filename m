Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33BA3353F16
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238643AbhDEJKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:10:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238984AbhDEJJR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:09:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69DF861398;
        Mon,  5 Apr 2021 09:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613751;
        bh=U1lwT8S3H4cJYaYaVzzMDfZD3C+/0vcojHddf7mcTGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=onxtPTYYCb4o5ZybVVtWvhCMhXrb4pIRiJeYjShii1NNdFWS33Vfiz2KZ9lqGONcc
         LE5YjPkg8Ytodxd944wkyEiFApH/0rf8ptgr13TKc/nlNg7bNrzJMwNDZKONgDDFDY
         NvRB4MrFxq2jXsYJBDAKltFhSk/w0ScwjWkWTP2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Pesce <luca.pesce@vimar.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/126] brcmfmac: clear EAP/association status bits on linkdown events
Date:   Mon,  5 Apr 2021 10:53:24 +0200
Message-Id: <20210405085032.440568386@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Pesce <luca.pesce@vimar.com>

[ Upstream commit e862a3e4088070de352fdafe9bd9e3ae0a95a33c ]

This ensure that previous association attempts do not leave stale statuses
on subsequent attempts.

This fixes the WARN_ON(!cr->bss)) from __cfg80211_connect_result() when
connecting to an AP after a previous connection failure (e.g. where EAP fails
due to incorrect psk but association succeeded). In some scenarios, indeed,
brcmf_is_linkup() was reporting a link up event too early due to stale
BRCMF_VIF_STATUS_ASSOC_SUCCESS bit, thus reporting to cfg80211 a connection
result with a zeroed bssid (vif->profile.bssid is still empty), causing the
WARN_ON due to the call to cfg80211_get_bss() with the empty bssid.

Signed-off-by: Luca Pesce <luca.pesce@vimar.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1608807119-21785-1-git-send-email-luca.pesce@vimar.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 0ee421f30aa2..23e6422c2251 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5611,7 +5611,8 @@ static bool brcmf_is_linkup(struct brcmf_cfg80211_vif *vif,
 	return false;
 }
 
-static bool brcmf_is_linkdown(const struct brcmf_event_msg *e)
+static bool brcmf_is_linkdown(struct brcmf_cfg80211_vif *vif,
+			    const struct brcmf_event_msg *e)
 {
 	u32 event = e->event_code;
 	u16 flags = e->flags;
@@ -5620,6 +5621,8 @@ static bool brcmf_is_linkdown(const struct brcmf_event_msg *e)
 	    (event == BRCMF_E_DISASSOC_IND) ||
 	    ((event == BRCMF_E_LINK) && (!(flags & BRCMF_EVENT_MSG_LINK)))) {
 		brcmf_dbg(CONN, "Processing link down\n");
+		clear_bit(BRCMF_VIF_STATUS_EAP_SUCCESS, &vif->sme_state);
+		clear_bit(BRCMF_VIF_STATUS_ASSOC_SUCCESS, &vif->sme_state);
 		return true;
 	}
 	return false;
@@ -6067,7 +6070,7 @@ brcmf_notify_connect_status(struct brcmf_if *ifp,
 		} else
 			brcmf_bss_connect_done(cfg, ndev, e, true);
 		brcmf_net_setcarrier(ifp, true);
-	} else if (brcmf_is_linkdown(e)) {
+	} else if (brcmf_is_linkdown(ifp->vif, e)) {
 		brcmf_dbg(CONN, "Linkdown\n");
 		if (!brcmf_is_ibssmode(ifp->vif) &&
 		    test_bit(BRCMF_VIF_STATUS_CONNECTED,
-- 
2.30.1



