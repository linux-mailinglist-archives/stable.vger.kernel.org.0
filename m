Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C304173AB
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345806AbhIXM70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:59:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345250AbhIXM5r (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:57:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B2C4613A1;
        Fri, 24 Sep 2021 12:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487922;
        bh=UN16EHAIhr0/e3BPk+w74b2trjTfAh9FxdX2JDaqZQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZ8P9HHX5WyF8UY016BdYtnmyvmuZIcBLe8u8MeJIQGl7EB9SOXJw/l/xBEI498cR
         Y3Fz1vwO7grsRvdy5yLfJax2EOKb1lbVP5uowjWdk87+65QCOehXSStRGDOgKBRcwf
         Z8dGDdb4ZHNJKpXbH0+tMe1Qy8eq0tReaXTetqeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Fabio Aiuto <fabioaiuto83@gmail.com>
Subject: [PATCH 5.14 014/100] staging: rtl8723bs: fix wpa_set_auth_algs() function
Date:   Fri, 24 Sep 2021 14:43:23 +0200
Message-Id: <20210924124341.925084421@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Aiuto <fabioaiuto83@gmail.com>

commit b658acbf64ae38b8fca982c2929ccc0bf4eb1ea2 upstream.

fix authentication algorithm constants.
wpa_set_auth_algs() function contains some conditional
statements masking the checked value with the wrong
constants. This produces some unintentional dead code.
Mask the value with the right macros.

Fixes: 5befa937e8da ("staging: rtl8723bs: Fix IEEE80211 authentication algorithm constants.")
Reported-by: Colin Ian King <colin.king@canonical.com>
Tested-on: Lenovo Ideapad MiiX 300-10IBY
Signed-off-by: Fabio Aiuto <fabioaiuto83@gmail.com>
Link: https://lore.kernel.org/r/20210715145700.9427-1-fabioaiuto83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
@@ -349,16 +349,16 @@ static int wpa_set_auth_algs(struct net_
 	struct adapter *padapter = rtw_netdev_priv(dev);
 	int ret = 0;
 
-	if ((value & WLAN_AUTH_SHARED_KEY) && (value & WLAN_AUTH_OPEN)) {
+	if ((value & IW_AUTH_ALG_SHARED_KEY) && (value & IW_AUTH_ALG_OPEN_SYSTEM)) {
 		padapter->securitypriv.ndisencryptstatus = Ndis802_11Encryption1Enabled;
 		padapter->securitypriv.ndisauthtype = Ndis802_11AuthModeAutoSwitch;
 		padapter->securitypriv.dot11AuthAlgrthm = dot11AuthAlgrthm_Auto;
-	} else if (value & WLAN_AUTH_SHARED_KEY)	{
+	} else if (value & IW_AUTH_ALG_SHARED_KEY)	{
 		padapter->securitypriv.ndisencryptstatus = Ndis802_11Encryption1Enabled;
 
 		padapter->securitypriv.ndisauthtype = Ndis802_11AuthModeShared;
 		padapter->securitypriv.dot11AuthAlgrthm = dot11AuthAlgrthm_Shared;
-	} else if (value & WLAN_AUTH_OPEN) {
+	} else if (value & IW_AUTH_ALG_OPEN_SYSTEM) {
 		/* padapter->securitypriv.ndisencryptstatus = Ndis802_11EncryptionDisabled; */
 		if (padapter->securitypriv.ndisauthtype < Ndis802_11AuthModeWPAPSK) {
 			padapter->securitypriv.ndisauthtype = Ndis802_11AuthModeOpen;


