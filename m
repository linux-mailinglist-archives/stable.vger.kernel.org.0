Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8707F316
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406358AbfHBJyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:54:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406352AbfHBJyA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:54:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8CC92086A;
        Fri,  2 Aug 2019 09:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739640;
        bh=ExIxciwL4p3Iiw0dYT41FO4aUG21VvQNi6AcAHP3soU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HjwtejAEm9s0S5KyaVxge/soQU2kVHZ+eB4870ZNa8TSESLrNJ3hdVo1A4KgPjbW/
         xseLBG6zSsSE+wGBEyMPXHp5LbZ+5eYt3UUDiFYxG/637B/4Ijs0N2OxHeRyN6HnJ7
         emxeAl5gQDq3F9freAn32kjaXa/336yus0YDTRsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        syzbot+0c90fc937c84f97d0aa6@syzkaller.appspotmail.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.14 13/25] media: cpia2_usb: first wake up, then free in disconnect
Date:   Fri,  2 Aug 2019 11:39:45 +0200
Message-Id: <20190802092103.738229528@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092058.428079740@linuxfoundation.org>
References: <20190802092058.428079740@linuxfoundation.org>
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
@@ -901,7 +901,6 @@ static void cpia2_usb_disconnect(struct
 	cpia2_unregister_camera(cam);
 	v4l2_device_disconnect(&cam->v4l2_dev);
 	mutex_unlock(&cam->v4l2_lock);
-	v4l2_device_put(&cam->v4l2_dev);
 
 	if(cam->buffers) {
 		DBG("Wakeup waiting processes\n");
@@ -913,6 +912,8 @@ static void cpia2_usb_disconnect(struct
 	DBG("Releasing interface\n");
 	usb_driver_release_interface(&cpia2_driver, intf);
 
+	v4l2_device_put(&cam->v4l2_dev);
+
 	LOG("CPiA2 camera disconnected.\n");
 }
 


