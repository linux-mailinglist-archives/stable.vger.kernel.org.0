Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793A76B7345
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 10:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbjCMJ5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 05:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbjCMJ5g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 05:57:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660EE4C6F4;
        Mon, 13 Mar 2023 02:57:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19C57B80EFD;
        Mon, 13 Mar 2023 09:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B16C433EF;
        Mon, 13 Mar 2023 09:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678701446;
        bh=30n5XcGdakB6s0doin0UPnJtwnlYQ33TJRkn7bxaP+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2v7RCieF4qgAhIh5LvffqbwMYVBvABtwAVGKV5mvT+VpZKg6PyEdDyMLKBwrnymX/
         T7otOkGqp8cuU2mdAd4+vqxHUs57Sb9xr33LjPgY1ZB3vfxuYxCM769Iaryw8CanzX
         4opJ5S2dqgVA1BK+KnHN0jDx/+LaJmmBG+gsMTaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.4.236
Date:   Mon, 13 Mar 2023 10:57:17 +0100
Message-Id: <167870143736200@kroah.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <1678701437166233@kroah.com>
References: <1678701437166233@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index f75275728ce8..e3b56259d50a 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 4
-SUBLEVEL = 235
+SUBLEVEL = 236
 EXTRAVERSION =
 NAME = Kleptomaniac Octopus
 
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c b/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
index 20e494186c9e..458ecca00ba1 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
@@ -185,7 +185,6 @@ static void _rtl92e_dm_init_fsync(struct net_device *dev);
 static void _rtl92e_dm_deinit_fsync(struct net_device *dev);
 
 static	void _rtl92e_dm_check_txrateandretrycount(struct net_device *dev);
-static  void _rtl92e_dm_check_ac_dc_power(struct net_device *dev);
 static void _rtl92e_dm_check_fsync(struct net_device *dev);
 static void _rtl92e_dm_check_rf_ctrl_gpio(void *data);
 static void _rtl92e_dm_fsync_timer_callback(struct timer_list *t);
@@ -238,8 +237,6 @@ void rtl92e_dm_watchdog(struct net_device *dev)
 	if (priv->being_init_adapter)
 		return;
 
-	_rtl92e_dm_check_ac_dc_power(dev);
-
 	_rtl92e_dm_check_txrateandretrycount(dev);
 	_rtl92e_dm_check_edca_turbo(dev);
 
@@ -257,30 +254,6 @@ void rtl92e_dm_watchdog(struct net_device *dev)
 	_rtl92e_dm_cts_to_self(dev);
 }
 
-static void _rtl92e_dm_check_ac_dc_power(struct net_device *dev)
-{
-	struct r8192_priv *priv = rtllib_priv(dev);
-	static char const ac_dc_script[] = "/etc/acpi/wireless-rtl-ac-dc-power.sh";
-	char *argv[] = {(char *)ac_dc_script, DRV_NAME, NULL};
-	static char *envp[] = {"HOME=/",
-			"TERM=linux",
-			"PATH=/usr/bin:/bin",
-			 NULL};
-
-	if (priv->ResetProgress == RESET_TYPE_SILENT) {
-		RT_TRACE((COMP_INIT | COMP_POWER | COMP_RF),
-			 "GPIOChangeRFWorkItemCallBack(): Silent Reset!!!!!!!\n");
-		return;
-	}
-
-	if (priv->rtllib->state != RTLLIB_LINKED)
-		return;
-	call_usermodehelper(ac_dc_script, argv, envp, UMH_WAIT_PROC);
-
-	return;
-};
-
-
 void rtl92e_init_adaptive_rate(struct net_device *dev)
 {
 
@@ -1800,10 +1773,6 @@ static void _rtl92e_dm_check_rf_ctrl_gpio(void *data)
 	u8 tmp1byte;
 	enum rt_rf_power_state eRfPowerStateToSet;
 	bool bActuallySet = false;
-	char *argv[3];
-	static char const RadioPowerPath[] = "/etc/acpi/events/RadioPower.sh";
-	static char *envp[] = {"HOME=/", "TERM=linux", "PATH=/usr/bin:/bin",
-			       NULL};
 
 	bActuallySet = false;
 
@@ -1835,14 +1804,6 @@ static void _rtl92e_dm_check_rf_ctrl_gpio(void *data)
 		mdelay(1000);
 		priv->bHwRfOffAction = 1;
 		rtl92e_set_rf_state(dev, eRfPowerStateToSet, RF_CHANGE_BY_HW);
-		if (priv->bHwRadioOff)
-			argv[1] = "RFOFF";
-		else
-			argv[1] = "RFON";
-
-		argv[0] = (char *)RadioPowerPath;
-		argv[2] = NULL;
-		call_usermodehelper(RadioPowerPath, argv, envp, UMH_WAIT_PROC);
 	}
 }
 
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 89b81d4c1095..a260cd60a7b9 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -1252,8 +1252,6 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
 		connect->key = NULL;
 		connect->key_len = 0;
 		connect->key_idx = 0;
-		connect->crypto.cipher_group = 0;
-		connect->crypto.n_ciphers_pairwise = 0;
 	}
 
 	wdev->connect_keys = connkeys;
