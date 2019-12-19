Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD64126A72
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbfLSSrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:47:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:40254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729229AbfLSSrX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:47:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A9E1206D7;
        Thu, 19 Dec 2019 18:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781243;
        bh=nuHAsepJtngeuassJ0DTBPKJvjsLu9vQprBq1cI/L3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YBcyH0zNZTphoEgz7OHafA+krKDksNRg3wiEhi/jIULlvwbShb5bzeiSe34Mgl4EB
         Y0eFJHDsvOPP19KzMij5fY5FaW36STrb38RYvgM/6SUtU5b4RQVRNFEn4VC9uN+vQN
         SfxdntyNSawSR1eZLFgP/MqiJ59jA9qlsqC/5UR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4.9 141/199] ppdev: fix PPGETTIME/PPSETTIME ioctls
Date:   Thu, 19 Dec 2019 19:33:43 +0100
Message-Id: <20191219183222.973502841@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
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
@@ -624,20 +624,27 @@ static int pp_do_ioctl(struct file *file
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
@@ -648,8 +655,9 @@ static int pp_do_ioctl(struct file *file
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


