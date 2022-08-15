Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE1759369B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343645AbiHOTSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343762AbiHOTNz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:13:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA3E52472;
        Mon, 15 Aug 2022 11:37:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DBC66114B;
        Mon, 15 Aug 2022 18:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8E5C433C1;
        Mon, 15 Aug 2022 18:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588663;
        bh=boHXcxQtTXBVil/aIoI4ARENch7agbweuVxDGPVujyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h/QnyFkBWlmuDGE0HhgweblroMhsxbI33v0RG7jGfQUGLt0Ccb+kWPJ5fmADMELnC
         Iy9IcQ1rbK3VSLC3KMeHgJNtWeHkrxpR4QzJkIrRmhC4wEY7LNMWq0SHLgtOusVG/X
         AC69kBE0Fr7f0QdGVBEIkphedfT3E/GnF9T3rYJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 475/779] staging: rtl8192u: Fix sleep in atomic context bug in dm_fsync_timer_callback
Date:   Mon, 15 Aug 2022 20:01:59 +0200
Message-Id: <20220815180357.584037574@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 6a0c054930d554ad8f8044ef1fc856d9da391c81 ]

There are sleep in atomic context bugs when dm_fsync_timer_callback is
executing. The root cause is that the memory allocation functions with
GFP_KERNEL or GFP_NOIO parameters are called in dm_fsync_timer_callback
which is a timer handler. The call paths that could trigger bugs are
shown below:

    (interrupt context)
dm_fsync_timer_callback
  write_nic_byte
    kzalloc(sizeof(data), GFP_KERNEL); //may sleep
    usb_control_msg
      kmalloc(.., GFP_NOIO); //may sleep
  write_nic_dword
    kzalloc(sizeof(data), GFP_KERNEL); //may sleep
    usb_control_msg
      kmalloc(.., GFP_NOIO); //may sleep

This patch uses delayed work to replace timer and moves the operations
that may sleep into the delayed work in order to mitigate bugs.

Fixes: 8fc8598e61f6 ("Staging: Added Realtek rtl8192u driver to staging")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20220710103002.63283-1-duoming@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8192u/r8192U.h    |  2 +-
 drivers/staging/rtl8192u/r8192U_dm.c | 38 +++++++++++++---------------
 drivers/staging/rtl8192u/r8192U_dm.h |  2 +-
 3 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U.h b/drivers/staging/rtl8192u/r8192U.h
index 4013107cd93a..a23d6d41de9d 100644
--- a/drivers/staging/rtl8192u/r8192U.h
+++ b/drivers/staging/rtl8192u/r8192U.h
@@ -1013,7 +1013,7 @@ typedef struct r8192_priv {
 	bool		bis_any_nonbepkts;
 	bool		bcurrent_turbo_EDCA;
 	bool		bis_cur_rdlstate;
-	struct timer_list fsync_timer;
+	struct delayed_work fsync_work;
 	bool bfsync_processing;	/* 500ms Fsync timer is active or not */
 	u32	rate_record;
 	u32	rateCountDiffRecord;
diff --git a/drivers/staging/rtl8192u/r8192U_dm.c b/drivers/staging/rtl8192u/r8192U_dm.c
index 725bf5ca9e34..0fcfcaa6500b 100644
--- a/drivers/staging/rtl8192u/r8192U_dm.c
+++ b/drivers/staging/rtl8192u/r8192U_dm.c
@@ -2578,19 +2578,20 @@ static void dm_init_fsync(struct net_device *dev)
 	priv->ieee80211->fsync_seconddiff_ratethreshold = 200;
 	priv->ieee80211->fsync_state = Default_Fsync;
 	priv->framesyncMonitor = 1;	/* current default 0xc38 monitor on */
-	timer_setup(&priv->fsync_timer, dm_fsync_timer_callback, 0);
+	INIT_DELAYED_WORK(&priv->fsync_work, dm_fsync_work_callback);
 }
 
 static void dm_deInit_fsync(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
-	del_timer_sync(&priv->fsync_timer);
+	cancel_delayed_work_sync(&priv->fsync_work);
 }
 
-void dm_fsync_timer_callback(struct timer_list *t)
+void dm_fsync_work_callback(struct work_struct *work)
 {
-	struct r8192_priv *priv = from_timer(priv, t, fsync_timer);
+	struct r8192_priv *priv =
+	    container_of(work, struct r8192_priv, fsync_work.work);
 	struct net_device *dev = priv->ieee80211->dev;
 	u32 rate_index, rate_count = 0, rate_count_diff = 0;
 	bool		bSwitchFromCountDiff = false;
@@ -2657,17 +2658,16 @@ void dm_fsync_timer_callback(struct timer_list *t)
 			}
 		}
 		if (bDoubleTimeInterval) {
-			if (timer_pending(&priv->fsync_timer))
-				del_timer_sync(&priv->fsync_timer);
-			priv->fsync_timer.expires = jiffies +
-				msecs_to_jiffies(priv->ieee80211->fsync_time_interval*priv->ieee80211->fsync_multiple_timeinterval);
-			add_timer(&priv->fsync_timer);
+			cancel_delayed_work_sync(&priv->fsync_work);
+			schedule_delayed_work(&priv->fsync_work,
+					      msecs_to_jiffies(priv
+					      ->ieee80211->fsync_time_interval *
+					      priv->ieee80211->fsync_multiple_timeinterval));
 		} else {
-			if (timer_pending(&priv->fsync_timer))
-				del_timer_sync(&priv->fsync_timer);
-			priv->fsync_timer.expires = jiffies +
-				msecs_to_jiffies(priv->ieee80211->fsync_time_interval);
-			add_timer(&priv->fsync_timer);
+			cancel_delayed_work_sync(&priv->fsync_work);
+			schedule_delayed_work(&priv->fsync_work,
+					      msecs_to_jiffies(priv
+					      ->ieee80211->fsync_time_interval));
 		}
 	} else {
 		/* Let Register return to default value; */
@@ -2695,7 +2695,7 @@ static void dm_EndSWFsync(struct net_device *dev)
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
 	RT_TRACE(COMP_HALDM, "%s\n", __func__);
-	del_timer_sync(&(priv->fsync_timer));
+	cancel_delayed_work_sync(&priv->fsync_work);
 
 	/* Let Register return to default value; */
 	if (priv->bswitch_fsync) {
@@ -2736,11 +2736,9 @@ static void dm_StartSWFsync(struct net_device *dev)
 		if (priv->ieee80211->fsync_rate_bitmap &  rateBitmap)
 			priv->rate_record += priv->stats.received_rate_histogram[1][rateIndex];
 	}
-	if (timer_pending(&priv->fsync_timer))
-		del_timer_sync(&priv->fsync_timer);
-	priv->fsync_timer.expires = jiffies +
-			msecs_to_jiffies(priv->ieee80211->fsync_time_interval);
-	add_timer(&priv->fsync_timer);
+	cancel_delayed_work_sync(&priv->fsync_work);
+	schedule_delayed_work(&priv->fsync_work,
+			      msecs_to_jiffies(priv->ieee80211->fsync_time_interval));
 
 	write_nic_dword(dev, rOFDM0_RxDetector2, 0x465c12cd);
 }
diff --git a/drivers/staging/rtl8192u/r8192U_dm.h b/drivers/staging/rtl8192u/r8192U_dm.h
index 0b2a1c688597..2159018b4e38 100644
--- a/drivers/staging/rtl8192u/r8192U_dm.h
+++ b/drivers/staging/rtl8192u/r8192U_dm.h
@@ -166,7 +166,7 @@ void dm_force_tx_fw_info(struct net_device *dev,
 void dm_init_edca_turbo(struct net_device *dev);
 void dm_rf_operation_test_callback(unsigned long data);
 void dm_rf_pathcheck_workitemcallback(struct work_struct *work);
-void dm_fsync_timer_callback(struct timer_list *t);
+void dm_fsync_work_callback(struct work_struct *work);
 void dm_cck_txpower_adjust(struct net_device *dev, bool  binch14);
 void dm_shadow_init(struct net_device *dev);
 void dm_initialize_txpower_tracking(struct net_device *dev);
-- 
2.35.1



