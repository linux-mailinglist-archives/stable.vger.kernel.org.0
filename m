Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B9A32E5E7
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 11:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhCEKOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 05:14:12 -0500
Received: from mga18.intel.com ([134.134.136.126]:34847 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhCEKOI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 05:14:08 -0500
IronPort-SDR: 5UeJy5giVT0bUYj9XdYneP28BlbVpnrNo97nNNGT5qhxPKx/TtsdC4ozm04PTKgmyuC5VRn+A+
 amcQwNq55XfA==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="175245108"
X-IronPort-AV: E=Sophos;i="5.81,224,1610438400"; 
   d="scan'208";a="175245108"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 02:14:08 -0800
IronPort-SDR: khWhyoCtIx+y/oovbljgzYxWEIKYIyP1jQxezmJZfx1TpITvn6VgjSTCQ1S3SdiaDD0esBw5GC
 saeWcAHdCFHA==
X-IronPort-AV: E=Sophos;i="5.81,224,1610438400"; 
   d="scan'208";a="374929596"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 02:14:05 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id 1EB5F211D8;
        Fri,  5 Mar 2021 12:14:00 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.92)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1lI7Te-0001aL-NT; Fri, 05 Mar 2021 12:14:34 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     gregkh@linuxfoundation.org
Cc:     arnd@arndb.de, arnd@kernel.org, hverkuil-cisco@xs4all.nl,
        laurent.pinchart@ideasonboard.com, mchehab+huawei@kernel.org,
        stable@vger.kernel.org
Subject: [PATCH FOR stable v5.10 1/1] media: v4l: ioctl: Fix memory leak in video_usercopy
Date:   Fri,  5 Mar 2021 12:14:33 +0200
Message-Id: <20210305101434.6038-5-sakari.ailus@linux.intel.com>
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
index eeff398fbdcc1..9eda8b91d17af 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -3251,7 +3251,7 @@ video_usercopy(struct file *file, unsigned int orig_cmd, unsigned long arg,
 	       v4l2_kioctl func)
 {
 	char	sbuf[128];
-	void    *mbuf = NULL;
+	void    *mbuf = NULL, *array_buf = NULL;
 	void	*parg = (void *)arg;
 	long	err  = -EINVAL;
 	bool	has_array_args;
@@ -3286,20 +3286,14 @@ video_usercopy(struct file *file, unsigned int orig_cmd, unsigned long arg,
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
@@ -3318,7 +3312,7 @@ video_usercopy(struct file *file, unsigned int orig_cmd, unsigned long arg,
 
 	if (has_array_args) {
 		*kernel_ptr = (void __force *)user_ptr;
-		if (copy_to_user(user_ptr, mbuf, array_size))
+		if (copy_to_user(user_ptr, array_buf, array_size))
 			err = -EFAULT;
 		goto out_array_args;
 	}
@@ -3333,6 +3327,7 @@ video_usercopy(struct file *file, unsigned int orig_cmd, unsigned long arg,
 	if (video_put_user((void __user *)arg, parg, orig_cmd))
 		err = -EFAULT;
 out:
+	kvfree(array_buf);
 	kvfree(mbuf);
 	return err;
 }
-- 
2.20.1

