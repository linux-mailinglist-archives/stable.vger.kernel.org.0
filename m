Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907942E3FD1
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506409AbgL1Oor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:44:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:60678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503147AbgL1OYw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:24:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6FA020731;
        Mon, 28 Dec 2020 14:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165477;
        bh=TBN0Rupb7x2AMhVcEwary34ZDTbkcSxfptAImk294So=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gE1IR0X5rIXpkC08wwDJ0eDlSw9axEwHYv5ar2k/sSaKO4vS6MGAEFrUT94cV183Q
         vngbBhE//EnrKTxdN6LAISXC9GmAYVucCYLClyeoV48pWCaeDvnVhZyU+eqzgjh9i9
         y4r4vlIGsDRuLXMSyiRgKt8fRZAW7gBh6u/7tlF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        syzbot+44e64397bd81d5e84cba@syzkaller.appspotmail.com
Subject: [PATCH 5.10 515/717] media: gspca: Fix memory leak in probe
Date:   Mon, 28 Dec 2020 13:48:33 +0100
Message-Id: <20201228125045.636623499@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
@@ -1575,6 +1575,7 @@ out:
 		input_unregister_device(gspca_dev->input_dev);
 #endif
 	v4l2_ctrl_handler_free(gspca_dev->vdev.ctrl_handler);
+	v4l2_device_unregister(&gspca_dev->v4l2_dev);
 	kfree(gspca_dev->usb_buf);
 	kfree(gspca_dev);
 	return ret;


