Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8648D6AC5B8
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 16:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbjCFPm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 10:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbjCFPm4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 10:42:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86446270D
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 07:41:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678117287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=H9Z6WV7NL84Kbv4qMj3xuK0nRGtPHbDJeWztjVc85m8=;
        b=PsynA0PGoJhxDiCNRPc8QwzQGNUyGH7oFW/tI6QTADMvm6gKjw57KH0R+cFR1gxEIuj90V
        Q8BLzj91Cu3k+scAPNHgHaIzyiAjPQnAbjSLi5KEgkQV6k6kVUjb5nM9Jm5fUezzCIpCLd
        VUThUNs/d26I4O17CnDdbyRaBLFBqD4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-XbZLA3d0PPOqYvGwdX1cqA-1; Mon, 06 Mar 2023 10:35:15 -0500
X-MC-Unique: XbZLA3d0PPOqYvGwdX1cqA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 47F1B101A52E;
        Mon,  6 Mar 2023 15:35:15 +0000 (UTC)
Received: from x1.localdomain.com (unknown [10.39.193.237])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E2FD7175AD;
        Mon,  6 Mar 2023 15:35:13 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Bastien Nocera <hadess@hadess.net>,
        linux-staging@lists.linux.dev, stable@vger.kernel.org
Subject: [PATCH 1/2] staging: rtl8723bs: Fix key-store index handling
Date:   Mon,  6 Mar 2023 16:35:11 +0100
Message-Id: <20230306153512.162104-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 .../staging/rtl8723bs/include/rtw_security.h  |  8 ++---
 .../staging/rtl8723bs/os_dep/ioctl_cfg80211.c | 26 ++++++++-------
 .../staging/rtl8723bs/os_dep/ioctl_linux.c    | 33 ++++++++++---------
 3 files changed, 36 insertions(+), 31 deletions(-)

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
-- 
2.39.1

