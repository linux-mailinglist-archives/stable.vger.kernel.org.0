Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC5212159E
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732015AbfLPSUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:20:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:49252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732012AbfLPSUD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:20:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7158221739;
        Mon, 16 Dec 2019 18:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520402;
        bh=pDM9YgV4ACQyf4D8/DQYrmhcjDCqeiLjgwAC5zEHwIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MybrmzorL1vVGDsDwQ3Un/sxWHr5cmaFovWq3aDR/lt3IuiL1fRx/4qOANhAuM/pJ
         wsb9iSyq+vsd1S2wg+63xySKT5kQ1i+XB+n5bGFdhG77ijacH5jodfJyrGLqCmwvic
         mDhwnL44h/GFGfRpFWl0sI/Fx+CNNlbdZ4OOwX1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.4 141/177] ppdev: fix PPGETTIME/PPSETTIME ioctls
Date:   Mon, 16 Dec 2019 18:49:57 +0100
Message-Id: <20191216174846.834159741@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 998174042da229e2cf5841f574aba4a743e69650 upstream.

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
Link: https://lore.kernel.org/r/20191108203435.112759-8-arnd@arndb.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/ppdev.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/char/ppdev.c
+++ b/drivers/char/ppdev.c
@@ -619,20 +619,27 @@ static int pp_do_ioctl(struct file *file
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
@@ -643,8 +650,9 @@ static int pp_do_ioctl(struct file *file
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


