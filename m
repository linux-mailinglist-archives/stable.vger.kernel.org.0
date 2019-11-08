Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF997F58A5
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbfKHUh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 15:37:29 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:43475 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729617AbfKHUh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 15:37:29 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MJW5G-1iDiWE2fua-00Jr4T; Fri, 08 Nov 2019 21:37:18 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     y2038@lists.linaro.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        stable@vger.kernel.org,
        Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 7/8] ppdev: fix PPGETTIME/PPSETTIME ioctls
Date:   Fri,  8 Nov 2019 21:34:30 +0100
Message-Id: <20191108203435.112759-8-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191108203435.112759-1-arnd@arndb.de>
References: <20191108203435.112759-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:qYLl7Lv1RPZHuaMmx5Y4HTBUG3IUIT6OHrwxfxk1rYIY9q0J5mB
 ID3W+2I3bIRJN9pb9/4We7gDyPXbqHtuj1j4jbHZqPHOQssbaXzIS5oG4kS2fmZvcPatud4
 28UbJl9c5SgBe7fdAKp7oJ+CbG/oBp2vCDyjiOe+T82VoBh+JiGWqcuzcRbpDWbUGG9ilIT
 oXkl6SZaCeu/b9K9+rWgA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:27jegMmATLs=:NTdMdmiXmyy5b2BfGtixk+
 QSkp4BY2cue8C4JNNeidfsutKRhw3wMg3l/slepabQusaphf9a2XzM/Xib4pCK19c/jh6uVYw
 qgoqRcope7ZcvaczaCTqwuVEOQ19cb1yCth63skQddVaME5+3q0OiGk14MCUEu+SyPOElob9b
 Qn/YeUBZAR3oXA2iHAYPA7mROXI3Bn7dgaIShyHnylMLGP2uqmZMOllngsqQHKIWE89EWnRug
 18W44axbZpxj22LSrEmOeVvaa4iJIkOdHDnXjF6hx8fT24K5b1x9XnNBqnzPwuOG0bYWl8D3+
 tDSlHep+MWILVxEz0z2VBYIFRb/gqAtqd0edvpKxcnv4Q6auK3yIGRJayQS962j4gNgOndn77
 0fXWlAP0cS3hrK6+4LrfRAdwDWQEM2OYpI5pP7j/hi8Wm+jrmvLn9PYgU68KOKoPMCa1q2Yhj
 h9nfnueEp5sP8Y6GnRXHD51s4wdw6vjhs9M6W5j4NodYDU1pyZiWYbKIAlPNRF6eH7l5AQjsS
 ogCgJxDmRvlDQ1MdM2xC0EnxSzjPcLA7GGrAWgVfNevSn0DIwiUxCtGZIiFgo/HG/2reHnWw2
 2cMlV1d4OLUq6tEx14Z8gWn5FdQBJpS3h1RQDXv5keY2Lbz/EBwscpvG+QqeHjF2SXoz/OBpH
 T4vEyyqnuyq1z4hRmUI0mYY+hNztZI18aZDDo+/iy9qlGDbIc0PCwp1/RHEdM5Xjfoy9+7Jmm
 MTgQ64hTlGXkXWvKrIp/7yenLu4c9AKDQqLC42HchjLAPJ6crLFiylBhIItSCnYqCWe8Tyle3
 mNAzDqk5r3RJ1GgTpL4QW8DP8nhhYfuSFLqdmsNXGmvrPVtcClQZK5bb+XFwFrqMAehuhAUZN
 BhhYhfG6EkYlzncjY87g==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Going through the uses of timeval in the user space API,
I noticed two bugs in ppdev that were introduced in the y2038
conversion:

* The range check was accidentally moved from ppsettime to
  ppgettime

* On sparc64, the microseconds are in the other half of the
  64-bit word.

Fix both, and mark the fix for stable backports.

Cc: stable@vger.kernel.org
Fixes: 3b9ab374a1e6 ("ppdev: convert to y2038 safe")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/ppdev.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/char/ppdev.c b/drivers/char/ppdev.c
index c86f18aa8985..34bb88fe0b0a 100644
--- a/drivers/char/ppdev.c
+++ b/drivers/char/ppdev.c
@@ -619,20 +619,27 @@ static int pp_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if (copy_from_user(time32, argp, sizeof(time32)))
 			return -EFAULT;
 
+		if ((time32[0] < 0) || (time32[1] < 0))
+			return -EINVAL;
+
 		return pp_set_timeout(pp->pdev, time32[0], time32[1]);
 
 	case PPSETTIME64:
 		if (copy_from_user(time64, argp, sizeof(time64)))
 			return -EFAULT;
 
+		if ((time64[0] < 0) || (time64[1] < 0))
+			return -EINVAL;
+
+		if (IS_ENABLED(CONFIG_SPARC64) && !in_compat_syscall())
+			time64[1] >>= 32;
+
 		return pp_set_timeout(pp->pdev, time64[0], time64[1]);
 
 	case PPGETTIME32:
 		jiffies_to_timespec64(pp->pdev->timeout, &ts);
 		time32[0] = ts.tv_sec;
 		time32[1] = ts.tv_nsec / NSEC_PER_USEC;
-		if ((time32[0] < 0) || (time32[1] < 0))
-			return -EINVAL;
 
 		if (copy_to_user(argp, time32, sizeof(time32)))
 			return -EFAULT;
@@ -643,8 +650,9 @@ static int pp_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		jiffies_to_timespec64(pp->pdev->timeout, &ts);
 		time64[0] = ts.tv_sec;
 		time64[1] = ts.tv_nsec / NSEC_PER_USEC;
-		if ((time64[0] < 0) || (time64[1] < 0))
-			return -EINVAL;
+
+		if (IS_ENABLED(CONFIG_SPARC64) && !in_compat_syscall())
+			time64[1] <<= 32;
 
 		if (copy_to_user(argp, time64, sizeof(time64)))
 			return -EFAULT;
-- 
2.20.0

