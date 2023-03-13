Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA406B7343
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 10:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbjCMJ5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 05:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbjCMJ5g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 05:57:36 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E0437555;
        Mon, 13 Mar 2023 02:57:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C4FD0CE0FAD;
        Mon, 13 Mar 2023 09:57:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF340C433EF;
        Mon, 13 Mar 2023 09:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678701444;
        bh=hMubZbSMJx3MXMGI4EH5wuloWZkIaL0cYW9FELupna8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z4DHvylKzR/S2n11SrrJoq7/ZdbS0rzMjZI+02NjlLQT55iuPJazBxp6I4lMkmnqR
         jA3gRHcmiJ5PH6EIDLLdh+OVqXf1Ak6jEuIoa5zkEm9TwgIH6nALbrAXO0TXDghOeL
         rBdEGmoEw/Xd7zsVo+JyIEEcDusMa8L3m8UPyBw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.19.277
Date:   Mon, 13 Mar 2023 10:57:13 +0100
Message-Id: <167870143322885@kroah.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <167870143312135@kroah.com>
References: <167870143312135@kroah.com>
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
index 7f6669dae46b..e00f4bbcd737 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 276
+SUBLEVEL = 277
 EXTRAVERSION =
 NAME = "People's Front"
 
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c b/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
index 9bf95bd0ad13..ca2113823387 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
@@ -193,7 +193,6 @@ static void _rtl92e_dm_init_fsync(struct net_device *dev);
 static void _rtl92e_dm_deinit_fsync(struct net_device *dev);
 
 static	void _rtl92e_dm_check_txrateandretrycount(struct net_device *dev);
-static  void _rtl92e_dm_check_ac_dc_power(struct net_device *dev);
 static void _rtl92e_dm_check_fsync(struct net_device *dev);
 static void _rtl92e_dm_check_rf_ctrl_gpio(void *data);
 static void _rtl92e_dm_fsync_timer_callback(struct timer_list *t);
@@ -246,8 +245,6 @@ void rtl92e_dm_watchdog(struct net_device *dev)
 	if (priv->being_init_adapter)
 		return;
 
-	_rtl92e_dm_check_ac_dc_power(dev);
-
 	_rtl92e_dm_check_txrateandretrycount(dev);
 	_rtl92e_dm_check_edca_turbo(dev);
 
@@ -265,30 +262,6 @@ void rtl92e_dm_watchdog(struct net_device *dev)
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
 
@@ -1809,10 +1782,6 @@ static void _rtl92e_dm_check_rf_ctrl_gpio(void *data)
 	u8 tmp1byte;
 	enum rt_rf_power_state eRfPowerStateToSet;
 	bool bActuallySet = false;
-	char *argv[3];
-	static char const RadioPowerPath[] = "/etc/acpi/events/RadioPower.sh";
-	static char *envp[] = {"HOME=/", "TERM=linux", "PATH=/usr/bin:/bin",
-			       NULL};
 
 	bActuallySet = false;
 
@@ -1844,14 +1813,6 @@ static void _rtl92e_dm_check_rf_ctrl_gpio(void *data)
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
index 501c0ec50328..ebc73faa8fb1 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -1226,8 +1226,6 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
 		connect->key = NULL;
 		connect->key_len = 0;
 		connect->key_idx = 0;
-		connect->crypto.cipher_group = 0;
-		connect->crypto.n_ciphers_pairwise = 0;
 	}
 
 	wdev->connect_keys = connkeys;
