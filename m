Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC18B1FBEF7
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 21:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730928AbgFPTZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 15:25:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730800AbgFPTZx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 15:25:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D46F20776;
        Tue, 16 Jun 2020 19:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592335551;
        bh=9MnUrextx10lpFwUqHRyHTD2HLJSQskluQCjuezpaYo=;
        h=Subject:To:From:Date:From;
        b=Ky4/VlXUk63LodGTd0c81vfULyORpVhkY+sWS1puLqT7PsbSeOU3YJ50Fj/jWE8P5
         Zv16vrvkiAma0jKLcgF4/fP32+GdJaZz00EZjFmSxcFE8OHyfklRfe1RI9UmXjdYQ0
         ApjHbqwhJQg3ki+y7ujACEDp6YeRavCKahco/HwE=
Subject: patch "Staging: rtl8723bs: prevent buffer overflow in" added to staging-linus
To:     dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 16 Jun 2020 21:25:46 +0200
Message-ID: <1592335546130254@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Staging: rtl8723bs: prevent buffer overflow in

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b65a2d8c8614386f7e8d38ea150749f8a862f431 Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 3 Jun 2020 13:19:58 +0300
Subject: Staging: rtl8723bs: prevent buffer overflow in
 update_sta_support_rate()

The "ie_len" variable is in the 0-255 range and it comes from the
network.  If it's over NDIS_802_11_LENGTH_RATES_EX (16) then that will
lead to memory corruption.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200603101958.GA1845750@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_wlan_util.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_wlan_util.c b/drivers/staging/rtl8723bs/core/rtw_wlan_util.c
index 69bcd172b298..a3ea7ce3e12e 100644
--- a/drivers/staging/rtl8723bs/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8723bs/core/rtw_wlan_util.c
@@ -1824,12 +1824,14 @@ int update_sta_support_rate(struct adapter *padapter, u8 *pvar_ie, uint var_ie_l
 	pIE = (struct ndis_80211_var_ie *)rtw_get_ie(pvar_ie, _SUPPORTEDRATES_IE_, &ie_len, var_ie_len);
 	if (!pIE)
 		return _FAIL;
+	if (ie_len > sizeof(pmlmeinfo->FW_sta_info[cam_idx].SupportedRates))
+		return _FAIL;
 
 	memcpy(pmlmeinfo->FW_sta_info[cam_idx].SupportedRates, pIE->data, ie_len);
 	supportRateNum = ie_len;
 
 	pIE = (struct ndis_80211_var_ie *)rtw_get_ie(pvar_ie, _EXT_SUPPORTEDRATES_IE_, &ie_len, var_ie_len);
-	if (pIE)
+	if (pIE && (ie_len <= sizeof(pmlmeinfo->FW_sta_info[cam_idx].SupportedRates) - supportRateNum))
 		memcpy((pmlmeinfo->FW_sta_info[cam_idx].SupportedRates + supportRateNum), pIE->data, ie_len);
 
 	return _SUCCESS;
-- 
2.27.0


