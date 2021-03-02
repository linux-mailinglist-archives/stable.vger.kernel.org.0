Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8987932B0D7
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236192AbhCCAjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:39:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:46236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376906AbhCBOYv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 09:24:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20BCE64F11;
        Tue,  2 Mar 2021 14:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614694976;
        bh=zvGcXbUDRp2bL8M1+C8xkwHGzC3raelpLHtLlgksUiM=;
        h=Subject:To:From:Date:From;
        b=1qhDnBY+rLZrGGiGHVkssgNea51GzX6RPzXFWbaxZKgnnZZZ1kGuDH2AsNyESmL7a
         w+HI7Ah+ho5Mmmzm0SIEzxtdlrd7F20F6PbFuZ9sR1sd0RZSrHCF9Vo++YKj7ttXca
         qUhX8g2jybgR1rV3o7S2sjCeCoRus/Vc+EckE5IQ=
Subject: patch "staging: ks7010: prevent buffer overflow in ks_wlan_set_scan()" added to staging-linus
To:     dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 02 Mar 2021 15:22:44 +0100
Message-ID: <16146949642227@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: ks7010: prevent buffer overflow in ks_wlan_set_scan()

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 651652def082ef79ea85ad2ca4f19167d927e330 Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 2 Mar 2021 14:19:39 +0300
Subject: staging: ks7010: prevent buffer overflow in ks_wlan_set_scan()

The user can specify a "req->essid_len" of up to 255 but if it's
over IW_ESSID_MAX_SIZE (32) that can lead to memory corruption.

Fixes: 13a9930d15b4 ("staging: ks7010: add driver from Nanonote extra-repository")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/YD4fS8+HmM/Qmrw6@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/ks7010/ks_wlan_net.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ks7010/ks_wlan_net.c b/drivers/staging/ks7010/ks_wlan_net.c
index dc09cc6e1c47..09e7b4cd0138 100644
--- a/drivers/staging/ks7010/ks_wlan_net.c
+++ b/drivers/staging/ks7010/ks_wlan_net.c
@@ -1120,6 +1120,7 @@ static int ks_wlan_set_scan(struct net_device *dev,
 {
 	struct ks_wlan_private *priv = netdev_priv(dev);
 	struct iw_scan_req *req = NULL;
+	int len;
 
 	if (priv->sleep_mode == SLP_SLEEP)
 		return -EPERM;
@@ -1129,8 +1130,9 @@ static int ks_wlan_set_scan(struct net_device *dev,
 	if (wrqu->data.length == sizeof(struct iw_scan_req) &&
 	    wrqu->data.flags & IW_SCAN_THIS_ESSID) {
 		req = (struct iw_scan_req *)extra;
-		priv->scan_ssid_len = req->essid_len;
-		memcpy(priv->scan_ssid, req->essid, priv->scan_ssid_len);
+		len = min_t(int, req->essid_len, IW_ESSID_MAX_SIZE);
+		priv->scan_ssid_len = len;
+		memcpy(priv->scan_ssid, req->essid, len);
 	} else {
 		priv->scan_ssid_len = 0;
 	}
-- 
2.30.1


