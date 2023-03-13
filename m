Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1AE26B745B
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 11:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjCMKl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 06:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbjCMKl2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 06:41:28 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E5A40F5
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 03:41:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1C40CCE0935
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 10:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC26AC433D2;
        Mon, 13 Mar 2023 10:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678704083;
        bh=RG2SsqFgRpAwi0Hhv4fPCnXvxFw8FPXAy8QmxpTv/x8=;
        h=Subject:To:Cc:From:Date:From;
        b=BKbsVMtEv5DlWawtC855zxwLk83XA3GrF14GYJJruTZNgzwcKK1L418tT4AgDN7ib
         kX26cu/kEU/YQgbDbjGjiCn+aAPUUXueCfjZyevK9x6+3BEYycT+WFaAuRCZrS3iSm
         6reW1KiZJOHvvVYHt70WPQpTr6aJHCBjGb/sOams=
Subject: FAILED: patch "[PATCH] staging: rtl8723bs: Fix key-store index handling" failed to apply to 5.4-stable tree
To:     hdegoede@redhat.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Mar 2023 11:41:16 +0100
Message-ID: <16787040761644@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.4.y
git checkout FETCH_HEAD
git cherry-pick -x 05cbcc415c9b8c8bc4f9a09f8e03610a89042f03
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16787040761644@kroah.com' --subject-prefix 'PATCH 5.4.y' HEAD^..

Possible dependencies:

05cbcc415c9b ("staging: rtl8723bs: Fix key-store index handling")
a8b088d6d98d ("staging: rtl8723bs: fix placement of braces")
1d7280898f68 ("Staging: rtl8723bs: Placing opening { braces in previous line")
cd1f14500922 ("staging: rtl8723bs: clean up comparsions to NULL")
6994aa430368 ("staging: rtl8723bs: fix camel case in struct ndis_802_11_ssid")
d8b322b60da6 ("staging: rtl8723bs: fix camel case in struct ndis_802_11_conf")
d3fcee1b78a5 ("staging: rtl8723bs: fix camel case in struct wlan_bssid_ex")
2a62ff13132a ("staging: rtl8723bs: remove commented out condition")
ddd7c8b0033b ("staging: rtl8723bs: remove 5Ghz code blocks")
a16d8644bad4 ("Merge tag 'staging-5.14-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 05cbcc415c9b8c8bc4f9a09f8e03610a89042f03 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Mon, 6 Mar 2023 16:35:11 +0100
Subject: [PATCH] staging: rtl8723bs: Fix key-store index handling

There are 2 issues with the key-store index handling

1. The non WEP key stores can store keys with indexes 0 - BIP_MAX_KEYID,
   this means that they should be an array with BIP_MAX_KEYID + 1
   entries. But some of the arrays where just BIP_MAX_KEYID entries
   big. While one other array was hardcoded to a size of 6 entries,
   instead of using the BIP_MAX_KEYID define.

2. The rtw_cfg80211_set_encryption() and wpa_set_encryption() functions
   index check where checking that the passed in key-index would fit
   inside both the WEP key store (which only has 4 entries) as well as
   in the non WEP key stores. This breaks any attempts to set non WEP
   keys with index 4 or 5.

Issue 2. specifically breaks wifi connection with some access points
which advertise PMF support. Without this fix connecting to these
access points fails with the following wpa_supplicant messages:

 nl80211: kernel reports: key addition failed
 wlan0: WPA: Failed to configure IGTK to the driver
 wlan0: RSN: Failed to configure IGTK
 wlan0: CTRL-EVENT-DISCONNECTED bssid=... reason=1 locally_generated=1

Fix 1. by using the right size for the key-stores. After this 2. can
safely be fixed by checking the right max-index value depending on the
used algorithm, fixing wifi not working with some PMF capable APs.

Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230306153512.162104-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/staging/rtl8723bs/include/rtw_security.h b/drivers/staging/rtl8723bs/include/rtw_security.h
index a68b73858462..7587fa888527 100644
--- a/drivers/staging/rtl8723bs/include/rtw_security.h
+++ b/drivers/staging/rtl8723bs/include/rtw_security.h
@@ -107,13 +107,13 @@ struct security_priv {
 
 	u32 dot118021XGrpPrivacy;	/*  This specify the privacy algthm. used for Grp key */
 	u32 dot118021XGrpKeyid;		/*  key id used for Grp Key (tx key index) */
-	union Keytype	dot118021XGrpKey[BIP_MAX_KEYID];	/*  802.1x Group Key, for inx0 and inx1 */
-	union Keytype	dot118021XGrptxmickey[BIP_MAX_KEYID];
-	union Keytype	dot118021XGrprxmickey[BIP_MAX_KEYID];
+	union Keytype	dot118021XGrpKey[BIP_MAX_KEYID + 1];	/*  802.1x Group Key, for inx0 and inx1 */
+	union Keytype	dot118021XGrptxmickey[BIP_MAX_KEYID + 1];
+	union Keytype	dot118021XGrprxmickey[BIP_MAX_KEYID + 1];
 	union pn48		dot11Grptxpn;			/*  PN48 used for Grp Key xmit. */
 	union pn48		dot11Grprxpn;			/*  PN48 used for Grp Key recv. */
 	u32 dot11wBIPKeyid;						/*  key id used for BIP Key (tx key index) */
-	union Keytype	dot11wBIPKey[6];		/*  BIP Key, for index4 and index5 */
+	union Keytype	dot11wBIPKey[BIP_MAX_KEYID + 1];	/*  BIP Key, for index4 and index5 */
 	union pn48		dot11wBIPtxpn;			/*  PN48 used for Grp Key xmit. */
 	union pn48		dot11wBIPrxpn;			/*  PN48 used for Grp Key recv. */
 
diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
index 54004f846cf0..3aba4e6eec8a 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -711,6 +711,7 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 static int rtw_cfg80211_set_encryption(struct net_device *dev, struct ieee_param *param, u32 param_len)
 {
 	int ret = 0;
+	u8 max_idx;
 	u32 wep_key_idx, wep_key_len;
 	struct adapter *padapter = rtw_netdev_priv(dev);
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
@@ -724,26 +725,29 @@ static int rtw_cfg80211_set_encryption(struct net_device *dev, struct ieee_param
 		goto exit;
 	}
 
-	if (param->sta_addr[0] == 0xff && param->sta_addr[1] == 0xff &&
-	    param->sta_addr[2] == 0xff && param->sta_addr[3] == 0xff &&
-	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff) {
-		if (param->u.crypt.idx >= WEP_KEYS
-			|| param->u.crypt.idx >= BIP_MAX_KEYID) {
-			ret = -EINVAL;
-			goto exit;
-		}
-	} else {
-		{
+	if (param->sta_addr[0] != 0xff || param->sta_addr[1] != 0xff ||
+	    param->sta_addr[2] != 0xff || param->sta_addr[3] != 0xff ||
+	    param->sta_addr[4] != 0xff || param->sta_addr[5] != 0xff) {
 		ret = -EINVAL;
 		goto exit;
 	}
+
+	if (strcmp(param->u.crypt.alg, "WEP") == 0)
+		max_idx = WEP_KEYS - 1;
+	else
+		max_idx = BIP_MAX_KEYID;
+
+	if (param->u.crypt.idx > max_idx) {
+		netdev_err(dev, "Error crypt.idx %d > %d\n", param->u.crypt.idx, max_idx);
+		ret = -EINVAL;
+		goto exit;
 	}
 
 	if (strcmp(param->u.crypt.alg, "WEP") == 0) {
 		wep_key_idx = param->u.crypt.idx;
 		wep_key_len = param->u.crypt.key_len;
 
-		if ((wep_key_idx >= WEP_KEYS) || (wep_key_len <= 0)) {
+		if (wep_key_len <= 0) {
 			ret = -EINVAL;
 			goto exit;
 		}
diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
index 30374a820496..40a3157fb735 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
@@ -46,6 +46,7 @@ static int wpa_set_auth_algs(struct net_device *dev, u32 value)
 static int wpa_set_encryption(struct net_device *dev, struct ieee_param *param, u32 param_len)
 {
 	int ret = 0;
+	u8 max_idx;
 	u32 wep_key_idx, wep_key_len, wep_total_len;
 	struct ndis_802_11_wep	 *pwep = NULL;
 	struct adapter *padapter = rtw_netdev_priv(dev);
@@ -60,19 +61,22 @@ static int wpa_set_encryption(struct net_device *dev, struct ieee_param *param,
 		goto exit;
 	}
 
-	if (param->sta_addr[0] == 0xff && param->sta_addr[1] == 0xff &&
-	    param->sta_addr[2] == 0xff && param->sta_addr[3] == 0xff &&
-	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff) {
-		if (param->u.crypt.idx >= WEP_KEYS ||
-		    param->u.crypt.idx >= BIP_MAX_KEYID) {
-			ret = -EINVAL;
-			goto exit;
-		}
-	} else {
-		{
-			ret = -EINVAL;
-			goto exit;
-		}
+	if (param->sta_addr[0] != 0xff || param->sta_addr[1] != 0xff ||
+	    param->sta_addr[2] != 0xff || param->sta_addr[3] != 0xff ||
+	    param->sta_addr[4] != 0xff || param->sta_addr[5] != 0xff) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	if (strcmp(param->u.crypt.alg, "WEP") == 0)
+		max_idx = WEP_KEYS - 1;
+	else
+		max_idx = BIP_MAX_KEYID;
+
+	if (param->u.crypt.idx > max_idx) {
+		netdev_err(dev, "Error crypt.idx %d > %d\n", param->u.crypt.idx, max_idx);
+		ret = -EINVAL;
+		goto exit;
 	}
 
 	if (strcmp(param->u.crypt.alg, "WEP") == 0) {
@@ -84,9 +88,6 @@ static int wpa_set_encryption(struct net_device *dev, struct ieee_param *param,
 		wep_key_idx = param->u.crypt.idx;
 		wep_key_len = param->u.crypt.key_len;
 
-		if (wep_key_idx > WEP_KEYS)
-			return -EINVAL;
-
 		if (wep_key_len > 0) {
 			wep_key_len = wep_key_len <= 5 ? 5 : 13;
 			wep_total_len = wep_key_len + FIELD_OFFSET(struct ndis_802_11_wep, key_material);

