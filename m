Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D8B1C74A7
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 17:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730288AbgEFP1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 11:27:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730283AbgEFP1H (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 May 2020 11:27:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2680420A8B;
        Wed,  6 May 2020 15:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588778826;
        bh=tq0zDJN1uUafbY21zuUhY3aF+EoubSO5Ny2LXvGM7AM=;
        h=Subject:To:From:Date:From;
        b=gicrV9gQNwOd+Zq8aGLsDneyhEbJTX/230euVhsVmTYlcBgVkWhh7tLDvZhe/z0xh
         7lamcDjEyOR8l6lI/eTYWU6VwReM+bykREkE+H0LiCRG8fNzbxUoaJBNKzVq4kkwrD
         SNkD5Np00PJ2Dmi81rKCHjiZCXPyHYNldECaoFy0=
Subject: patch "USB: serial: garmin_gps: add sanity checking for data length" added to usb-linus
To:     oneukum@suse.com, johan@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 06 May 2020 17:27:04 +0200
Message-ID: <158877882416649@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: garmin_gps: add sanity checking for data length

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e9b3c610a05c1cdf8e959a6d89c38807ff758ee6 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Wed, 15 Apr 2020 16:03:04 +0200
Subject: USB: serial: garmin_gps: add sanity checking for data length

We must not process packets shorter than a packet ID

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-and-tested-by: syzbot+d29e9263e13ce0b9f4fd@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/garmin_gps.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/garmin_gps.c b/drivers/usb/serial/garmin_gps.c
index ffd984142171..d63072fee099 100644
--- a/drivers/usb/serial/garmin_gps.c
+++ b/drivers/usb/serial/garmin_gps.c
@@ -1138,8 +1138,8 @@ static void garmin_read_process(struct garmin_data *garmin_data_p,
 		   send it directly to the tty port */
 		if (garmin_data_p->flags & FLAGS_QUEUING) {
 			pkt_add(garmin_data_p, data, data_length);
-		} else if (bulk_data ||
-			   getLayerId(data) == GARMIN_LAYERID_APPL) {
+		} else if (bulk_data || (data_length >= sizeof(u32) &&
+				getLayerId(data) == GARMIN_LAYERID_APPL)) {
 
 			spin_lock_irqsave(&garmin_data_p->lock, flags);
 			garmin_data_p->flags |= APP_RESP_SEEN;
-- 
2.26.2


