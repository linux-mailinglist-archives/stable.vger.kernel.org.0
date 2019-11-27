Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4978610BECD
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729056AbfK0UpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:45:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:55918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728535AbfK0UpU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:45:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 864B52166E;
        Wed, 27 Nov 2019 20:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887520;
        bh=0GZ1QDRmv1Yd2SEj8LE3ig5owC1stBMxq0NMsin0smg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OECsIFU3oeIddi3FZHgf0tJsyfYQXdcGR91I+sULLn8HHpBI93PYHUys3ufgnPzq0
         T4ZWmYWOrzs6dbB2i2jBKRzT09JSO1u1r5Q1JrWsrIiCPHzv3t2lwrL5OVRytn3rCt
         vHXCm3zKTHS60ZnxX5xwXhQx2UGxm6WAo/hOuHmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        syzbot+495dab1f175edc9c2f13@syzkaller.appspotmail.com
Subject: [PATCH 4.9 142/151] appledisplay: fix error handling in the scheduled work
Date:   Wed, 27 Nov 2019 21:32:05 +0100
Message-Id: <20191127203047.166875788@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 91feb01596e5efc0cc922cc73f5583114dccf4d2 upstream.

The work item can operate on

1. stale memory left over from the last transfer
the actual length of the data transfered needs to be checked
2. memory already freed
the error handling in appledisplay_probe() needs
to cancel the work in that case

Reported-and-tested-by: syzbot+495dab1f175edc9c2f13@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191106124902.7765-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/appledisplay.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -182,7 +182,12 @@ static int appledisplay_bl_get_brightnes
 		0,
 		pdata->msgdata, 2,
 		ACD_USB_TIMEOUT);
-	brightness = pdata->msgdata[1];
+	if (retval < 2) {
+		if (retval >= 0)
+			retval = -EMSGSIZE;
+	} else {
+		brightness = pdata->msgdata[1];
+	}
 	mutex_unlock(&pdata->sysfslock);
 
 	if (retval < 0)
@@ -324,6 +329,7 @@ error:
 	if (pdata) {
 		if (pdata->urb) {
 			usb_kill_urb(pdata->urb);
+			cancel_delayed_work_sync(&pdata->work);
 			if (pdata->urbdata)
 				usb_free_coherent(pdata->udev, ACD_URB_BUFFER_LEN,
 					pdata->urbdata, pdata->urb->transfer_dma);


