Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618A41AC1F1
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894707AbgDPNBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:01:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2894531AbgDPNBE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:01:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 663B7206B9;
        Thu, 16 Apr 2020 13:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587042063;
        bh=fksYkj1bbYlMIjSA14x3M3OD7XTeBPHNy17Ti+blPoI=;
        h=Subject:To:From:Date:From;
        b=OVO5LNTT9xI6pVgNA1aQqUI9BKy2bLSgc+Hk1cRzIiOGJ8DQVCAsIkxvNoWG3P1or
         lC8Di7uw0yG7f8hHXhF6xUN3UDKVd9gO0HNHzvPf2U93cxEOZZ/W1IXCbL4UHv3oup
         C4CB3SrO19XD5/FS0VMz/6uKAgwoS0TBw1nkVyLE=
Subject: patch "UAS: no use logging any details in case of ENODEV" added to usb-linus
To:     oneukum@suse.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Apr 2020 15:01:01 +0200
Message-ID: <1587042061228180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    UAS: no use logging any details in case of ENODEV

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5963dec98dc52d52476390485f07a29c30c6a582 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Wed, 15 Apr 2020 16:17:49 +0200
Subject: UAS: no use logging any details in case of ENODEV

Once a device is gone, the internal state does not matter anymore.
There is no need to spam the logs.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Fixes: 326349f824619 ("uas: add dead request list")
Link: https://lore.kernel.org/r/20200415141750.811-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/uas.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 3670fda02c34..08503e3507bf 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -190,6 +190,9 @@ static void uas_log_cmd_state(struct scsi_cmnd *cmnd, const char *prefix,
 	struct uas_cmd_info *ci = (void *)&cmnd->SCp;
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 
+	if (status == -ENODEV) /* too late */
+		return;
+
 	scmd_printk(KERN_INFO, cmnd,
 		    "%s %d uas-tag %d inflight:%s%s%s%s%s%s%s%s%s%s%s%s ",
 		    prefix, status, cmdinfo->uas_tag,
-- 
2.26.1


