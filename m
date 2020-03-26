Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6D911941E5
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 15:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgCZOsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 10:48:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgCZOsW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 10:48:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 394442076A;
        Thu, 26 Mar 2020 14:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585234101;
        bh=eM4Q9aTXcwoom5gH24Hz6fO+8BSzmhHf/Mq5hJ1mDKA=;
        h=Subject:To:From:Date:From;
        b=bZPT300XuzyRgZCgU8Fmy/bsAHt6nVjZ2f/hfXtMs6EpqK7R8Y7faHyJGJ1BnaSdj
         87+g/h3LR20YVu6t9hcWecglr8I9y+/xBy8INktHFlQ82QW3lzFh6Asa6Htie0rKEd
         6ErYPgfzMXB6fgtzrNVXtEEO1kiC0Do/OiD2ys5g=
Subject: patch "staging: wlan-ng: fix use-after-free Read in hfa384x_usbin_callback" added to staging-testing
To:     hqjagain@gmail.com, gregkh@linuxfoundation.org, hdanton@sina.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 26 Mar 2020 15:48:09 +0100
Message-ID: <158523408946255@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: wlan-ng: fix use-after-free Read in hfa384x_usbin_callback

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 1165dd73e811a07d947aee218510571f516081f6 Mon Sep 17 00:00:00 2001
From: Qiujun Huang <hqjagain@gmail.com>
Date: Thu, 26 Mar 2020 21:18:50 +0800
Subject: staging: wlan-ng: fix use-after-free Read in hfa384x_usbin_callback

We can't handle the case length > WLAN_DATA_MAXLEN.
Because the size of rxfrm->data is WLAN_DATA_MAXLEN(2312), and we can't
read more than that.

Thanks-to: Hillf Danton <hdanton@sina.com>
Reported-and-tested-by: syzbot+7d42d68643a35f71ac8a@syzkaller.appspotmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200326131850.17711-1-hqjagain@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/wlan-ng/hfa384x_usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index e38acb58cd5e..fa1bf8b069fd 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -3376,6 +3376,8 @@ static void hfa384x_int_rxmonitor(struct wlandevice *wlandev,
 	     WLAN_HDR_A4_LEN + WLAN_DATA_MAXLEN + WLAN_CRC_LEN)) {
 		pr_debug("overlen frm: len=%zd\n",
 			 skblen - sizeof(struct p80211_caphdr));
+
+		return;
 	}
 
 	skb = dev_alloc_skb(skblen);
-- 
2.26.0


