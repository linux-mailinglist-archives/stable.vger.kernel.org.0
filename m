Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16D0A1938CA
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 07:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgCZGkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 02:40:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbgCZGkS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 02:40:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA72C20714;
        Thu, 26 Mar 2020 06:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585204818;
        bh=gsLTxxXQiOzSSzzr/IOVxAPaOV4RZUb4Q/dYT6a+wAg=;
        h=Subject:To:From:Date:From;
        b=GaBvnVWNSD/C/9LA7/NKjIsVaznDPqhBQF/ew9C+c1M2LtqQPw6D0b3eOIS19vTXE
         vL0h86ZMRw3+gfoWwHSg/LdpaV8zDrHzEPhrK7Q/bVD3gUct5THK+mxH3dTDJ3Guz9
         0O0UmtJ6KkLalL4LMAHedGSmxESTDOHy0lkmgFR0=
Subject: patch "staging: wlan-ng: fix ODEBUG bug in prism2sta_disconnect_usb" added to staging-next
To:     hqjagain@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 26 Mar 2020 07:40:11 +0100
Message-ID: <158520481116299@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: wlan-ng: fix ODEBUG bug in prism2sta_disconnect_usb

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From a1f165a6b738f0c9d744bad4af7a53909278f5fc Mon Sep 17 00:00:00 2001
From: Qiujun Huang <hqjagain@gmail.com>
Date: Wed, 25 Mar 2020 15:06:46 +0800
Subject: staging: wlan-ng: fix ODEBUG bug in prism2sta_disconnect_usb

We should cancel hw->usb_work before kfree(hw).

Reported-by: syzbot+6d2e7f6fa90e27be9d62@syzkaller.appspotmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1585120006-30042-1-git-send-email-hqjagain@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/wlan-ng/prism2usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wlan-ng/prism2usb.c b/drivers/staging/wlan-ng/prism2usb.c
index 352556f6870a..4689b2170e4f 100644
--- a/drivers/staging/wlan-ng/prism2usb.c
+++ b/drivers/staging/wlan-ng/prism2usb.c
@@ -180,6 +180,7 @@ static void prism2sta_disconnect_usb(struct usb_interface *interface)
 
 		cancel_work_sync(&hw->link_bh);
 		cancel_work_sync(&hw->commsqual_bh);
+		cancel_work_sync(&hw->usb_work);
 
 		/* Now we complete any outstanding commands
 		 * and tell everyone who is waiting for their
-- 
2.26.0


