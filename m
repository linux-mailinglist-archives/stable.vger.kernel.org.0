Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99BAB353D1D
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233833AbhDEI6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:58:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233708AbhDEI6Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:58:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6763860238;
        Mon,  5 Apr 2021 08:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613099;
        bh=NnzeJ9bU7O/kw0wTFeurbQExxkYSrIb4RLKP73ul0Yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UzLJ37XHSbnlUYSPuvNT9LVRrHPWoHi/4c/KPUoge8y8myCuDFHhHfAXcX8Ihj/7J
         kXAHnQElS+JMOO/uRvPcsxOwHg5sRif2PreJ6ol1R/Gi6j6A7SBh8FOEeO8GrCFFdZ
         2HEk1v9ncYC3AO5/4HOeISGtEs3Os4JJxVgMxIts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Pesce <luca.pesce@vimar.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 19/52] brcmfmac: clear EAP/association status bits on linkdown events
Date:   Mon,  5 Apr 2021 10:53:45 +0200
Message-Id: <20210405085022.626799000@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085021.996963957@linuxfoundation.org>
References: <20210405085021.996963957@linuxfoundation.org>
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
index 04fa66ed99a0..b5fceba10806 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5381,7 +5381,8 @@ static bool brcmf_is_linkup(struct brcmf_cfg80211_vif *vif,
 	return false;
 }
 
-static bool brcmf_is_linkdown(const struct brcmf_event_msg *e)
+static bool brcmf_is_linkdown(struct brcmf_cfg80211_vif *vif,
+			    const struct brcmf_event_msg *e)
 {
 	u32 event = e->event_code;
 	u16 flags = e->flags;
@@ -5390,6 +5391,8 @@ static bool brcmf_is_linkdown(const struct brcmf_event_msg *e)
 	    (event == BRCMF_E_DISASSOC_IND) ||
 	    ((event == BRCMF_E_LINK) && (!(flags & BRCMF_EVENT_MSG_LINK)))) {
 		brcmf_dbg(CONN, "Processing link down\n");
+		clear_bit(BRCMF_VIF_STATUS_EAP_SUCCESS, &vif->sme_state);
+		clear_bit(BRCMF_VIF_STATUS_ASSOC_SUCCESS, &vif->sme_state);
 		return true;
 	}
 	return false;
@@ -5674,7 +5677,7 @@ brcmf_notify_connect_status(struct brcmf_if *ifp,
 		} else
 			brcmf_bss_connect_done(cfg, ndev, e, true);
 		brcmf_net_setcarrier(ifp, true);
-	} else if (brcmf_is_linkdown(e)) {
+	} else if (brcmf_is_linkdown(ifp->vif, e)) {
 		brcmf_dbg(CONN, "Linkdown\n");
 		if (!brcmf_is_ibssmode(ifp->vif)) {
 			brcmf_bss_connect_done(cfg, ndev, e, false);
-- 
2.30.1



