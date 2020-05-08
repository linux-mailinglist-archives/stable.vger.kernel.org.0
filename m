Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB5B1CB00F
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbgEHMiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:38:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728307AbgEHMiO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:38:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8BCA24953;
        Fri,  8 May 2020 12:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941494;
        bh=kKDJUoQUsayzk17hvv6RnM+MZYFe9lffBNiYBJ4kAy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aS458TUeNixAjkLj1WK0e8dNxq5OAYR6ava/3SpmKF3zUtb27/B6Wgq7sbYkYoBC9
         ulL59hAIhAL6Imo4qEyRqAP6Lo8XUzhMgdNkKdZrFn+Htd0plFR7RvqVkYlBl/a+AK
         sJYTBmL57zjypj2esklOw+gzZaMnvuNqk0NYNomI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, chunfan chen <jeffc@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.4 053/312] mwifiex: fix IBSS data path issue.
Date:   Fri,  8 May 2020 14:30:44 +0200
Message-Id: <20200508123128.286982579@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: chunfan chen <jeffc@marvell.com>

commit dc386ce76dedaeeaaf006fceb6ed8cf2e20ff026 upstream.

The port_open flag is not applicable for IBSS mode. IBSS data
path was broken when port_open flag was introduced.
This patch fixes the problem by correcting the checks.

Fixes: 5c8946330abfa4c ("mwifiex: enable traffic only when port is open")
Signed-off-by: chunfan chen <jeffc@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/sta_event.c |   10 ++++++----
 drivers/net/wireless/mwifiex/wmm.c       |    6 ++++--
 2 files changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -607,11 +607,13 @@ int mwifiex_process_sta_event(struct mwi
 
 	case EVENT_PS_AWAKE:
 		mwifiex_dbg(adapter, EVENT, "info: EVENT: AWAKE\n");
-		if (!adapter->pps_uapsd_mode && priv->port_open &&
+		if (!adapter->pps_uapsd_mode &&
+		    (priv->port_open ||
+		     (priv->bss_mode == NL80211_IFTYPE_ADHOC)) &&
 		    priv->media_connected && adapter->sleep_period.period) {
-				adapter->pps_uapsd_mode = true;
-				mwifiex_dbg(adapter, EVENT,
-					    "event: PPS/UAPSD mode activated\n");
+			adapter->pps_uapsd_mode = true;
+			mwifiex_dbg(adapter, EVENT,
+				    "event: PPS/UAPSD mode activated\n");
 		}
 		adapter->tx_lock_flag = false;
 		if (adapter->pps_uapsd_mode && adapter->gen_null_pkt) {
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -475,7 +475,8 @@ mwifiex_wmm_lists_empty(struct mwifiex_a
 		priv = adapter->priv[i];
 		if (!priv)
 			continue;
-		if (!priv->port_open)
+		if (!priv->port_open &&
+		    (priv->bss_mode != NL80211_IFTYPE_ADHOC))
 			continue;
 		if (adapter->if_ops.is_port_ready &&
 		    !adapter->if_ops.is_port_ready(priv))
@@ -1109,7 +1110,8 @@ mwifiex_wmm_get_highest_priolist_ptr(str
 
 			priv_tmp = adapter->bss_prio_tbl[j].bss_prio_cur->priv;
 
-			if (!priv_tmp->port_open ||
+			if (((priv_tmp->bss_mode != NL80211_IFTYPE_ADHOC) &&
+			     !priv_tmp->port_open) ||
 			    (atomic_read(&priv_tmp->wmm.tx_pkts_queued) == 0))
 				continue;
 


