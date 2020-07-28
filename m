Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11259230529
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 10:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgG1ITc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 04:19:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727941AbgG1ITc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jul 2020 04:19:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFF4F22B43;
        Tue, 28 Jul 2020 08:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595924370;
        bh=fI0ucN88cyGU6HQnxFIkIeNlRc0fGigJY4sCKc30R3w=;
        h=Subject:To:From:Date:From;
        b=ob4RpMa7cekeaxzTOon3/bWqTmwMxp+AlLAMpWPl7fKaPCXuk0BNCRsynahzUsd9n
         8gL6IsdKysAaMzSZ4LNPV4sr/UqlYUlE5t1q/FoDpyDyrlTqt3O83Q3eunMyMFs5AK
         nqCR5f11XD0FsyhpcJ6yvjyyTLBDRHjb8fhvx/ts=
Subject: patch "Staging: rtl8188eu: rtw_mlme: Fix uninitialized variable authmode" added to staging-testing
To:     dinghao.liu@zju.edu.cn, dan.carpenter@oracle.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Jul 2020 10:19:05 +0200
Message-ID: <1595924345226158@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Staging: rtl8188eu: rtw_mlme: Fix uninitialized variable authmode

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 11536442a3b4e1de6890ea5e805908debb74f94a Mon Sep 17 00:00:00 2001
From: Dinghao Liu <dinghao.liu@zju.edu.cn>
Date: Tue, 28 Jul 2020 15:21:51 +0800
Subject: Staging: rtl8188eu: rtw_mlme: Fix uninitialized variable authmode

The variable authmode can be uninitialized. The danger would be if
it equals to _WPA_IE_ID_ (0xdd) or _WPA2_IE_ID_ (0x33). We can avoid
this by setting it to zero instead. This is the approach that was
used in the rtl8723bs driver.

Fixes: 7b464c9fa5cc ("staging: r8188eu: Add files for new driver - part 4")
Co-developed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200728072153.9202-1-dinghao.liu@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8188eu/core/rtw_mlme.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index 5d7a749f1aac..d334dc335914 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -1729,9 +1729,11 @@ int rtw_restruct_sec_ie(struct adapter *adapter, u8 *in_ie, u8 *out_ie, uint in_
 	if ((ndisauthmode == Ndis802_11AuthModeWPA) ||
 	    (ndisauthmode == Ndis802_11AuthModeWPAPSK))
 		authmode = _WPA_IE_ID_;
-	if ((ndisauthmode == Ndis802_11AuthModeWPA2) ||
+	else if ((ndisauthmode == Ndis802_11AuthModeWPA2) ||
 	    (ndisauthmode == Ndis802_11AuthModeWPA2PSK))
 		authmode = _WPA2_IE_ID_;
+	else
+		authmode = 0x0;
 
 	if (check_fwstate(pmlmepriv, WIFI_UNDER_WPS)) {
 		memcpy(out_ie + ielength, psecuritypriv->wps_ie, psecuritypriv->wps_ie_len);
-- 
2.27.0


