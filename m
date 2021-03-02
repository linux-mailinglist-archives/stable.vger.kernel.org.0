Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7C032B0D5
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236085AbhCCAjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:39:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:46690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351420AbhCBOXf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 09:23:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16EC861494;
        Tue,  2 Mar 2021 14:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614694965;
        bh=zMs14VPDu4FfiLYhUROZoXcX4IVVFn0Z/XTiKkyfP00=;
        h=Subject:To:From:Date:From;
        b=X1RHMMxrsQa/rMjFCzLz3wBMU49f8RbQV2mbHAf/hSMynZIbtqCN0d+HVmjVpkNBj
         cC1b1r2X+3yczoRuX/B6X5Dx+a3MRkw6JOVKTbHa902xFb6ULWaLtPOntTOEdARdn/
         p2P4lnlNpCgmDAiFimnWk14619J8e8siGY61PqtA=
Subject: patch "staging: rtl8192e: Fix possible buffer overflow in" added to staging-linus
To:     leegib@gmail.com, dan.carpenter@oracle.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 02 Mar 2021 15:22:43 +0100
Message-ID: <161469496372167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: rtl8192e: Fix possible buffer overflow in

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 35eda75caac975e1912acdf9635f8f23c8e5db4e Mon Sep 17 00:00:00 2001
From: Lee Gibson <leegib@gmail.com>
Date: Fri, 26 Feb 2021 14:51:57 +0000
Subject: staging: rtl8192e: Fix possible buffer overflow in
 _rtl92e_wx_set_scan

Function _rtl92e_wx_set_scan calls memcpy without checking the length.
A user could control that length and trigger a buffer overflow.
Fix by checking the length is within the maximum allowed size.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Lee Gibson <leegib@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210226145157.424065-1-leegib@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8192e/rtl8192e/rtl_wx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
index 16bcee13f64b..407effde5e71 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
@@ -406,9 +406,10 @@ static int _rtl92e_wx_set_scan(struct net_device *dev,
 		struct iw_scan_req *req = (struct iw_scan_req *)b;
 
 		if (req->essid_len) {
-			ieee->current_network.ssid_len = req->essid_len;
-			memcpy(ieee->current_network.ssid, req->essid,
-			       req->essid_len);
+			int len = min_t(int, req->essid_len, IW_ESSID_MAX_SIZE);
+
+			ieee->current_network.ssid_len = len;
+			memcpy(ieee->current_network.ssid, req->essid, len);
 		}
 	}
 
-- 
2.30.1


