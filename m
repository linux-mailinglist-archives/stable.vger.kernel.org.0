Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475A04996A5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443784AbiAXVFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387515AbiAXUgy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:36:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E636C038AF4;
        Mon, 24 Jan 2022 11:49:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFAE960B03;
        Mon, 24 Jan 2022 19:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F85EC340E5;
        Mon, 24 Jan 2022 19:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053798;
        bh=YDjUoVyK2QZHgahWsrbWXcshySCqkSFQvmka6DxA3K4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vhCEmZrulHGMkwqp6JqpLEiIbt69llL16z3++VfXtC8iZ2QCQ4VgQOIv4ahvolkZl
         NhQVoZjfyDyDH20tkM7agiAxREBIaUNLAdLc1FhahufIUST2avfOYVUpY2h+9H/+aq
         MAB4FGznnzD2DajFTv6cCVQnfg1bB085rWGIs6WQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 148/563] mwifiex: Fix possible ABBA deadlock
Date:   Mon, 24 Jan 2022 19:38:33 +0100
Message-Id: <20220124184029.520070168@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit 1b8bb8919ef81bfc8873d223b9361f1685f2106d ]

Quoting Jia-Ju Bai <baijiaju1990@gmail.com>:

  mwifiex_dequeue_tx_packet()
     spin_lock_bh(&priv->wmm.ra_list_spinlock); --> Line 1432 (Lock A)
     mwifiex_send_addba()
       spin_lock_bh(&priv->sta_list_spinlock); --> Line 608 (Lock B)

  mwifiex_process_sta_tx_pause()
     spin_lock_bh(&priv->sta_list_spinlock); --> Line 398 (Lock B)
     mwifiex_update_ralist_tx_pause()
       spin_lock_bh(&priv->wmm.ra_list_spinlock); --> Line 941 (Lock A)

Similar report for mwifiex_process_uap_tx_pause().

While the locking expectations in this driver are a bit unclear, the
Fixed commit only intended to protect the sta_ptr, so we can drop the
lock as soon as we're done with it.

IIUC, this deadlock cannot actually happen, because command event
processing (which calls mwifiex_process_sta_tx_pause()) is
sequentialized with TX packet processing (e.g.,
mwifiex_dequeue_tx_packet()) via the main loop (mwifiex_main_process()).
But it's good not to leave this potential issue lurking.

Fixes: f0f7c2275fb9 ("mwifiex: minor cleanups w/ sta_list_spinlock in cfg80211.c")
Cc: Douglas Anderson <dianders@chromium.org>
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Link: https://lore.kernel.org/linux-wireless/0e495b14-efbb-e0da-37bd-af6bd677ee2c@gmail.com/
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/YaV0pllJ5p/EuUat@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/sta_event.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index bc79ca4cb803c..753458628f86a 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -364,10 +364,12 @@ static void mwifiex_process_uap_tx_pause(struct mwifiex_private *priv,
 		sta_ptr = mwifiex_get_sta_entry(priv, tp->peermac);
 		if (sta_ptr && sta_ptr->tx_pause != tp->tx_pause) {
 			sta_ptr->tx_pause = tp->tx_pause;
+			spin_unlock_bh(&priv->sta_list_spinlock);
 			mwifiex_update_ralist_tx_pause(priv, tp->peermac,
 						       tp->tx_pause);
+		} else {
+			spin_unlock_bh(&priv->sta_list_spinlock);
 		}
-		spin_unlock_bh(&priv->sta_list_spinlock);
 	}
 }
 
@@ -399,11 +401,13 @@ static void mwifiex_process_sta_tx_pause(struct mwifiex_private *priv,
 			sta_ptr = mwifiex_get_sta_entry(priv, tp->peermac);
 			if (sta_ptr && sta_ptr->tx_pause != tp->tx_pause) {
 				sta_ptr->tx_pause = tp->tx_pause;
+				spin_unlock_bh(&priv->sta_list_spinlock);
 				mwifiex_update_ralist_tx_pause(priv,
 							       tp->peermac,
 							       tp->tx_pause);
+			} else {
+				spin_unlock_bh(&priv->sta_list_spinlock);
 			}
-			spin_unlock_bh(&priv->sta_list_spinlock);
 		}
 	}
 }
-- 
2.34.1



