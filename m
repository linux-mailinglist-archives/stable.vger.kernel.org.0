Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B426332772
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 14:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhCINod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 08:44:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:53270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231211AbhCINoB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Mar 2021 08:44:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6CF064F67;
        Tue,  9 Mar 2021 13:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615297441;
        bh=tfqw1B7qkLP1W78lRtKBNZeWGZJ3pcYmoRYY3jUFMKs=;
        h=Subject:To:From:Date:From;
        b=15qaeCTHNCGbWU8DTIHu9Jb6ulXt7HBreqwJrU3fKRgsP1igatS/gNJhqpx4Gg2GO
         K/Br+zPDluh4lc7OEbXYa7ZBhaVj2EagCHyuJJSXCryozVFLUXrBI6SFzFHth4yG7F
         mtGqIyF4I8crE7o89Jh7iP/EkhNfWFBNG5CVjm/g=
Subject: patch "staging: rtl8188eu: fix potential memory corruption in" added to staging-linus
To:     dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 09 Mar 2021 14:43:50 +0100
Message-ID: <161529743019120@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: rtl8188eu: fix potential memory corruption in

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 2b5d923c01cf6abf0ae2768891421612452d2ffa Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Fri, 5 Mar 2021 11:56:32 +0300
Subject: staging: rtl8188eu: fix potential memory corruption in
 rtw_check_beacon_data()

The "ie_len" is a value in the 1-255 range that comes from the user.  We
have to cap it to ensure that it's not too large or it could lead to
memory corruption.

Fixes: 9a7fe54ddc3a ("staging: r8188eu: Add source files for new driver - part 1")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/YEHyQCrFZKTXyT7J@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8188eu/core/rtw_ap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/rtl8188eu/core/rtw_ap.c b/drivers/staging/rtl8188eu/core/rtw_ap.c
index fa1e34a0d456..182bb944c9b3 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ap.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ap.c
@@ -791,6 +791,7 @@ int rtw_check_beacon_data(struct adapter *padapter, u8 *pbuf,  int len)
 	p = rtw_get_ie(ie + _BEACON_IE_OFFSET_, WLAN_EID_SSID, &ie_len,
 		       pbss_network->ie_length - _BEACON_IE_OFFSET_);
 	if (p && ie_len > 0) {
+		ie_len = min_t(int, ie_len, sizeof(pbss_network->ssid.ssid));
 		memset(&pbss_network->ssid, 0, sizeof(struct ndis_802_11_ssid));
 		memcpy(pbss_network->ssid.ssid, p + 2, ie_len);
 		pbss_network->ssid.ssid_length = ie_len;
@@ -811,6 +812,7 @@ int rtw_check_beacon_data(struct adapter *padapter, u8 *pbuf,  int len)
 	p = rtw_get_ie(ie + _BEACON_IE_OFFSET_, WLAN_EID_SUPP_RATES, &ie_len,
 		       pbss_network->ie_length - _BEACON_IE_OFFSET_);
 	if (p) {
+		ie_len = min_t(int, ie_len, NDIS_802_11_LENGTH_RATES_EX);
 		memcpy(supportRate, p + 2, ie_len);
 		supportRateNum = ie_len;
 	}
@@ -819,6 +821,8 @@ int rtw_check_beacon_data(struct adapter *padapter, u8 *pbuf,  int len)
 	p = rtw_get_ie(ie + _BEACON_IE_OFFSET_, WLAN_EID_EXT_SUPP_RATES,
 		       &ie_len, pbss_network->ie_length - _BEACON_IE_OFFSET_);
 	if (p) {
+		ie_len = min_t(int, ie_len,
+			       NDIS_802_11_LENGTH_RATES_EX - supportRateNum);
 		memcpy(supportRate + supportRateNum, p + 2, ie_len);
 		supportRateNum += ie_len;
 	}
@@ -934,6 +938,7 @@ int rtw_check_beacon_data(struct adapter *padapter, u8 *pbuf,  int len)
 
 		pht_cap->mcs.rx_mask[0] = 0xff;
 		pht_cap->mcs.rx_mask[1] = 0x0;
+		ie_len = min_t(int, ie_len, sizeof(pmlmepriv->htpriv.ht_cap));
 		memcpy(&pmlmepriv->htpriv.ht_cap, p + 2, ie_len);
 	}
 
-- 
2.30.1


