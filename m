Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25D597F11B
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404807AbfHBJgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:36:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404798AbfHBJgE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:36:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6386217F5;
        Fri,  2 Aug 2019 09:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738563;
        bh=pyIvImfViMLtxcGU82rheuavpva3hfqIVCdWvLh4K7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KgR5DXdinecTEiPbHLsA30SNBKcw+yohHv2sD+hBiy+WbOO1hzQzWB/brZL5LeVep
         Jug5ZzJ9yKKzT4lFZt6kAm5vuWe/9sFFJfyjtq21ama8buljFOjf/CNTE4ukhPKEX+
         Ddvs8HA+YDE7+0Z/Kb9zVZv6YNrefvjbkl0Glqw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        syzbot+0c90fc937c84f97d0aa6@syzkaller.appspotmail.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.4 153/158] media: cpia2_usb: first wake up, then free in disconnect
Date:   Fri,  2 Aug 2019 11:29:34 +0200
Message-Id: <20190802092233.082892221@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit eff73de2b1600ad8230692f00bc0ab49b166512a upstream.

Kasan reported a use after free in cpia2_usb_disconnect()
It first freed everything and then woke up those waiting.
The reverse order is correct.

Fixes: 6c493f8b28c67 ("[media] cpia2: major overhaul to get it in a working state again")

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-by: syzbot+0c90fc937c84f97d0aa6@syzkaller.appspotmail.com
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/cpia2/cpia2_usb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -884,7 +884,6 @@ static void cpia2_usb_disconnect(struct
 	cpia2_unregister_camera(cam);
 	v4l2_device_disconnect(&cam->v4l2_dev);
 	mutex_unlock(&cam->v4l2_lock);
-	v4l2_device_put(&cam->v4l2_dev);
 
 	if(cam->buffers) {
 		DBG("Wakeup waiting processes\n");
@@ -897,6 +896,8 @@ static void cpia2_usb_disconnect(struct
 	DBG("Releasing interface\n");
 	usb_driver_release_interface(&cpia2_driver, intf);
 
+	v4l2_device_put(&cam->v4l2_dev);
+
 	LOG("CPiA2 camera disconnected.\n");
 }
 


