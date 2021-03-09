Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65CB33276F
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 14:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhCINoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 08:44:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:53238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231132AbhCINnx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Mar 2021 08:43:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42A6A64F69;
        Tue,  9 Mar 2021 13:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615297432;
        bh=JV7PzbsDUe+YH3mcuCXlQY0Nsqkna0nCWusSy4rhbmw=;
        h=Subject:To:From:Date:From;
        b=MTM/YvL37Fav6YI7ZQzOJNlgYEZSM+/nRhSBxEEjwW4WDfA3hRtmXWKNCp1RYUDcK
         GPEIDTSd7Y1rOnJJoySSUGUZ6DZN9qVKIejDfGCt+0sJSFtGHFYJhmv1tRFsJyn0kr
         c1m2b/0txRD8bUHYqHo1pZCMaD5dI75GkTdfnNVo=
Subject: patch "staging: rtl8192u: fix ->ssid overflow in r8192_wx_set_scan()" added to staging-linus
To:     dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 09 Mar 2021 14:43:50 +0100
Message-ID: <1615297430110191@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: rtl8192u: fix ->ssid overflow in r8192_wx_set_scan()

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3b897cb890d5cfb8111987b10f675525cacdab2a Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Fri, 5 Mar 2021 11:12:49 +0300
Subject: staging: rtl8192u: fix ->ssid overflow in r8192_wx_set_scan()

We need to cap len at IW_ESSID_MAX_SIZE (32) to avoid memory corruption.
This can be controlled by the user via the ioctl.

Fixes: 5f53d8ca3d5d ("Staging: add rtl8192SU wireless usb driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/YEHoAWMOSZBUw91F@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8192u/r8192U_wx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
index d853586705fc..77bf88696a84 100644
--- a/drivers/staging/rtl8192u/r8192U_wx.c
+++ b/drivers/staging/rtl8192u/r8192U_wx.c
@@ -331,8 +331,10 @@ static int r8192_wx_set_scan(struct net_device *dev, struct iw_request_info *a,
 		struct iw_scan_req *req = (struct iw_scan_req *)b;
 
 		if (req->essid_len) {
-			ieee->current_network.ssid_len = req->essid_len;
-			memcpy(ieee->current_network.ssid, req->essid, req->essid_len);
+			int len = min_t(int, req->essid_len, IW_ESSID_MAX_SIZE);
+
+			ieee->current_network.ssid_len = len;
+			memcpy(ieee->current_network.ssid, req->essid, len);
 		}
 	}
 
-- 
2.30.1


