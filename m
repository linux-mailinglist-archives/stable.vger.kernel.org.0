Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2462D1321
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 15:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgLGOJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 09:09:07 -0500
Received: from www.linuxtv.org ([130.149.80.248]:36794 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726603AbgLGOJH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Dec 2020 09:09:07 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1kmHBh-009CER-0L; Mon, 07 Dec 2020 14:08:25 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Mon, 07 Dec 2020 14:00:15 +0000
Subject: [git:media_tree/master] media: gspca: Fix memory leak in probe
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org,
        syzbot+44e64397bd81d5e84cba@syzkaller.appspotmail.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Alan Stern <stern@rowland.harvard.edu>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1kmHBh-009CER-0L@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: gspca: Fix memory leak in probe
Author:  Alan Stern <stern@rowland.harvard.edu>
Date:    Wed Dec 2 18:20:04 2020 +0100

The gspca driver leaks memory when a probe fails.  gspca_dev_probe2()
calls v4l2_device_register(), which takes a reference to the
underlying device node (in this case, a USB interface).  But the
failure pathway neglects to call v4l2_device_unregister(), the routine
responsible for dropping this reference.  Consequently the memory for
the USB interface and its device never gets released.

This patch adds the missing function call.

Reported-and-tested-by: syzbot+44e64397bd81d5e84cba@syzkaller.appspotmail.com

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: <stable@vger.kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/usb/gspca/gspca.c | 1 +
 1 file changed, 1 insertion(+)

---

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index c295f642d352..158c8e28ed2c 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -1575,6 +1575,7 @@ out:
 		input_unregister_device(gspca_dev->input_dev);
 #endif
 	v4l2_ctrl_handler_free(gspca_dev->vdev.ctrl_handler);
+	v4l2_device_unregister(&gspca_dev->v4l2_dev);
 	kfree(gspca_dev->usb_buf);
 	kfree(gspca_dev);
 	return ret;
