Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F5132EADF
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbhCEMkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:40:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:55238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233414AbhCEMkQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:40:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D38865012;
        Fri,  5 Mar 2021 12:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614948015;
        bh=NH6m+oKyLWRksVitxGNPrtEuM5pzmvRBpVdaqwItRLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fG2BJgpUqFMbjW+FpsxuGnIWeOZs98RtjfwP9wDeP/b7tJ6PQwNnvCmj/5RARj5V2
         O7mOb+NGSC+dNKuTk7uY3d0UqnHR71E/0rsfC0gpiE1Fg7VrcL+ToaRxvQwCwpOFKn
         z+mRGLLvCjzhHuvmAG8Tbi9f33rNF48Fmgl3yHX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
        syzbot+1115e79c8df6472c612b@syzkaller.appspotmail.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.14 39/39] media: v4l: ioctl: Fix memory leak in video_usercopy
Date:   Fri,  5 Mar 2021 13:22:38 +0100
Message-Id: <20210305120853.731590407@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120851.751937389@linuxfoundation.org>
References: <20210305120851.751937389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit fb18802a338b36f675a388fc03d2aa504a0d0899 upstream.

When an IOCTL with argument size larger than 128 that also used array
arguments were handled, two memory allocations were made but alas, only
the latter one of them was released. This happened because there was only
a single local variable to hold such a temporary allocation.

Fix this by adding separate variables to hold the pointers to the
temporary allocations.

Reported-by: Arnd Bergmann <arnd@kernel.org>
Reported-by: syzbot+1115e79c8df6472c612b@syzkaller.appspotmail.com
Fixes: d14e6d76ebf7 ("[media] v4l: Add multi-planar ioctl handling code")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-ioctl.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2836,7 +2836,7 @@ video_usercopy(struct file *file, unsign
 	       v4l2_kioctl func)
 {
 	char	sbuf[128];
-	void    *mbuf = NULL;
+	void    *mbuf = NULL, *array_buf = NULL;
 	void	*parg = (void *)arg;
 	long	err  = -EINVAL;
 	bool	has_array_args;
@@ -2894,20 +2894,14 @@ video_usercopy(struct file *file, unsign
 	has_array_args = err;
 
 	if (has_array_args) {
-		/*
-		 * When adding new types of array args, make sure that the
-		 * parent argument to ioctl (which contains the pointer to the
-		 * array) fits into sbuf (so that mbuf will still remain
-		 * unused up to here).
-		 */
-		mbuf = kvmalloc(array_size, GFP_KERNEL);
+		array_buf = kvmalloc(array_size, GFP_KERNEL);
 		err = -ENOMEM;
-		if (NULL == mbuf)
+		if (array_buf == NULL)
 			goto out_array_args;
 		err = -EFAULT;
-		if (copy_from_user(mbuf, user_ptr, array_size))
+		if (copy_from_user(array_buf, user_ptr, array_size))
 			goto out_array_args;
-		*kernel_ptr = mbuf;
+		*kernel_ptr = array_buf;
 	}
 
 	/* Handles IOCTL */
@@ -2926,7 +2920,7 @@ video_usercopy(struct file *file, unsign
 
 	if (has_array_args) {
 		*kernel_ptr = (void __force *)user_ptr;
-		if (copy_to_user(user_ptr, mbuf, array_size))
+		if (copy_to_user(user_ptr, array_buf, array_size))
 			err = -EFAULT;
 		goto out_array_args;
 	}
@@ -2948,6 +2942,7 @@ out_array_args:
 	}
 
 out:
+	kvfree(array_buf);
 	kvfree(mbuf);
 	return err;
 }


