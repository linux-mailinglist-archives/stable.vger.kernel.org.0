Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBEE12E6908
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgL1M4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:56:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:52674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728775AbgL1M4h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:56:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 665DF208B6;
        Mon, 28 Dec 2020 12:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160182;
        bh=hN//SUe8IPgpmWtUUzsfGKLVhQz8xJVBNrm0Inhur+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H7AUfV57IUBWGNaNBgVxUQxS9KO/fkUGuv0TTDAShAEY66W87xYQIW8LqPjIc3cRK
         OpTvjkisJ26r5dKqWALrWJTEps9uhDsckd2SF5U09uC80FxQsPrMIXhfRGvnPzwZ0I
         PGuBKHx9cLRvcjWbSC9W13Fm4T+e1BnAIlUplx2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        syzbot+44e64397bd81d5e84cba@syzkaller.appspotmail.com
Subject: [PATCH 4.4 097/132] media: gspca: Fix memory leak in probe
Date:   Mon, 28 Dec 2020 13:49:41 +0100
Message-Id: <20201228124851.099553745@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit e469d0b09a19496e1972a20974bbf55b728151eb upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/gspca/gspca.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -2130,6 +2130,7 @@ out:
 		input_unregister_device(gspca_dev->input_dev);
 #endif
 	v4l2_ctrl_handler_free(gspca_dev->vdev.ctrl_handler);
+	v4l2_device_unregister(&gspca_dev->v4l2_dev);
 	kfree(gspca_dev->usb_buf);
 	kfree(gspca_dev);
 	return ret;


