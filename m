Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A501B59E25C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354175AbiHWKcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355136AbiHWKbH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:31:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D150A50D1;
        Tue, 23 Aug 2022 02:06:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F115A6156F;
        Tue, 23 Aug 2022 09:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9115C433C1;
        Tue, 23 Aug 2022 09:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245592;
        bh=pMLjTVY79woXUN6LdpdzLIrMQpQNhyKcJyqJmAcy4jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0AYrJXBDOPOGkZyfAmeNKKq5RcoMa6MPibJXZbwrLbmSr7KX1W6x+siC6msyXnNPz
         nZOR5k5Q9I0kZuFX7hf25Q/rMznbsgJAJ8eJShWaSE7q20Mz8/Nxmn/8qvz5kcta4A
         TFwyvr9yrdIdqzb1DLeRoHPUksqWBNPFaSBhGXxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 126/287] staging: rtl8192u: Fix sleep in atomic context bug in dm_fsync_timer_callback
Date:   Tue, 23 Aug 2022 10:24:55 +0200
Message-Id: <20220823080104.637720667@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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
index 94a148994069..2c3b33304173 100644
--- a/drivers/staging/rtl8192u/r8192U.h
+++ b/drivers/staging/rtl8192u/r8192U.h
@@ -1000,7 +1000,7 @@ typedef struct r8192_priv {
 	bool		bis_any_nonbepkts;
 	bool		bcurrent_turbo_EDCA;
 	bool		bis_cur_rdlstate;
-	struct timer_list fsync_timer;
+	struct delayed_work fsync_work;
 	bool bfsync_processing;	/* 500ms Fsync timer is active or not */
 	u32	rate_record;
 	u32	rateCountDiffRecord;
diff --git a/drivers/staging/rtl8192u/r8192U_dm.c b/drivers/staging/rtl8192u/r8192U_dm.c
index 5fb5f583f703..c24a29189545 100644
--- a/drivers/staging/rtl8192u/r8192U_dm.c
+++ b/drivers/staging/rtl8192u/r8192U_dm.c
@@ -2627,19 +2627,20 @@ static void dm_init_fsync(struct net_device *dev)
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
@@ -2706,17 +2707,16 @@ void dm_fsync_timer_callback(struct timer_list *t)
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
@@ -2744,7 +2744,7 @@ static void dm_EndSWFsync(struct net_device *dev)
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
 	RT_TRACE(COMP_HALDM, "%s\n", __func__);
-	del_timer_sync(&(priv->fsync_timer));
+	cancel_delayed_work_sync(&priv->fsync_work);
 
 	/* Let Register return to default value; */
 	if (priv->bswitch_fsync) {
@@ -2786,11 +2786,9 @@ static void dm_StartSWFsync(struct net_device *dev)
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
 
diff --git a/drivers/staging/rtl8192u/r8192U_dm.h b/drivers/staging/rtl8192u/r8192U_dm.h
index 0de0332906bd..eeb03130de15 100644
--- a/drivers/staging/rtl8192u/r8192U_dm.h
+++ b/drivers/staging/rtl8192u/r8192U_dm.h
@@ -167,7 +167,7 @@ void dm_force_tx_fw_info(struct net_device *dev,
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



