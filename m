Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D14B32E5ED
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 11:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhCEKOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 05:14:11 -0500
Received: from mga12.intel.com ([192.55.52.136]:30324 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229608AbhCEKOE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 05:14:04 -0500
IronPort-SDR: D3uejRIGl7QfBiXy6Np0rCWz6k09IpjISpUy73Psxf2iuXNs62k2C2MuP4yaEyzPc+/MCoaMXD
 34LgcdBWSrCg==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="166879650"
X-IronPort-AV: E=Sophos;i="5.81,224,1610438400"; 
   d="scan'208";a="166879650"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 02:14:03 -0800
IronPort-SDR: eRLZviK3oIdTJe+TDl6Vnuvfv0YG6Ru+nccKjqqvNupam0mWQjhmaIV+rTVwdyX8Na0zoJPYSc
 2x+JJCxFspqA==
X-IronPort-AV: E=Sophos;i="5.81,224,1610438400"; 
   d="scan'208";a="370134132"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 02:14:02 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id 02B9820815;
        Fri,  5 Mar 2021 12:14:00 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.92)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1lI7Te-0001aC-JR; Fri, 05 Mar 2021 12:14:34 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     gregkh@linuxfoundation.org
Cc:     arnd@arndb.de, arnd@kernel.org, hverkuil-cisco@xs4all.nl,
        laurent.pinchart@ideasonboard.com, mchehab+huawei@kernel.org,
        stable@vger.kernel.org
Subject: [PATCH FOR stable v4.19 1/1] media: v4l: ioctl: Fix memory leak in video_usercopy
Date:   Fri,  5 Mar 2021 12:14:30 +0200
Message-Id: <20210305101434.6038-2-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210305101329.GP3@paasikivi.fi.intel.com>
References: <20210305101329.GP3@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fb18802a338b36f675a388fc03d2aa504a0d0899 ]

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
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index f75d892b6f033..76ef79733a4e5 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2939,7 +2939,7 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 	       v4l2_kioctl func)
 {
 	char	sbuf[128];
-	void    *mbuf = NULL;
+	void    *mbuf = NULL, *array_buf = NULL;
 	void	*parg = (void *)arg;
 	long	err  = -EINVAL;
 	bool	has_array_args;
@@ -2998,20 +2998,14 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
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
@@ -3030,7 +3024,7 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 
 	if (has_array_args) {
 		*kernel_ptr = (void __force *)user_ptr;
-		if (copy_to_user(user_ptr, mbuf, array_size))
+		if (copy_to_user(user_ptr, array_buf, array_size))
 			err = -EFAULT;
 		goto out_array_args;
 	}
@@ -3052,6 +3046,7 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 	}
 
 out:
+	kvfree(array_buf);
 	kvfree(mbuf);
 	return err;
 }
-- 
2.20.1

