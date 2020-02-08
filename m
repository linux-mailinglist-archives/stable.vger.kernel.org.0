Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 265CB156707
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgBHS3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:29:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33560 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727543AbgBHS3e (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:34 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrE-0003bV-Kj; Sat, 08 Feb 2020 18:29:32 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrD-000CK9-Ko; Sat, 08 Feb 2020 18:29:31 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
        "Hans Verkuil" <hans.verkuil@cisco.com>,
        "Dan Carpenter" <dan.carpenter@oracle.com>
Date:   Sat, 08 Feb 2020 18:19:21 +0000
Message-ID: <lsq.1581185940.714653414@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 022/148] [media] usbvision-video: two use after frees
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 470a9147899500eb4898f77816520c4b4aa1a698 upstream.

The lock has been freed in usbvision_release() so there is no need to
call mutex_unlock() here.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/usb/usbvision/usbvision-video.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -424,6 +424,7 @@ static int usbvision_v4l2_close(struct f
 	if (usbvision->remove_pending) {
 		printk(KERN_INFO "%s: Final disconnect\n", __func__);
 		usbvision_release(usbvision);
+		return 0;
 	}
 	mutex_unlock(&usbvision->v4l2_lock);
 
@@ -1178,6 +1179,7 @@ static int usbvision_radio_close(struct
 	if (usbvision->remove_pending) {
 		printk(KERN_INFO "%s: Final disconnect\n", __func__);
 		usbvision_release(usbvision);
+		return err_code;
 	}
 
 	mutex_unlock(&usbvision->v4l2_lock);

