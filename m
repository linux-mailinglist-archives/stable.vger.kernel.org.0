Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75BD41A794
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238957AbhI1F6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:58:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239016AbhI1F5j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:57:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6651611C3;
        Tue, 28 Sep 2021 05:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808561;
        bh=vBP9kGpPB2LUkidY5Rs17sJhXZcp4qG1Xsc7PRaOPcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L3PZlCVV16GWBj+S0+STMtbvO+1MvPWjy3GjcKJIAzxupPKLUkx1FTq9Hndeyu6hK
         1AnxBt8exmI/ANiml/mOfLaQ7cWyzCh7v9oow35+mjzA8ip6OMJsqDio9BZSKdvwel
         3PnKC0tvFEaOWkX7dXenEbv9LpWVUhy0qr8RpAFmkz9T813Id6kalmM2YZ3wMCVRRW
         g7VlDdrZD7Q/aBlNjQ3+B3cP+0Xm0OoBLVbgK/t8572+rF4M85OTzDT8BO+7uZBtvG
         +f8VIrQltLxeLTEIZh7W6MtyOM3lY2+STUFr/0CttiEwyOWo75j8u4ZmTBU3JffR8O
         wJc0DnG/2sbYw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Faizel K B <faizel.kb@dicortech.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.14 18/40] usb: testusb: Fix for showing the connection speed
Date:   Tue, 28 Sep 2021 01:55:02 -0400
Message-Id: <20210928055524.172051-18-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055524.172051-1-sashal@kernel.org>
References: <20210928055524.172051-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Faizel K B <faizel.kb@dicortech.com>

[ Upstream commit f81c08f897adafd2ed43f86f00207ff929f0b2eb ]

testusb' application which uses 'usbtest' driver reports 'unknown speed'
from the function 'find_testdev'. The variable 'entry->speed' was not
updated from  the application. The IOCTL mentioned in the FIXME comment can
only report whether the connection is low speed or not. Speed is read using
the IOCTL USBDEVFS_GET_SPEED which reports the proper speed grade.  The
call is implemented in the function 'handle_testdev' where the file
descriptor was availble locally. Sample output is given below where 'high
speed' is printed as the connected speed.

sudo ./testusb -a
high speed      /dev/bus/usb/001/011    0
/dev/bus/usb/001/011 test 0,    0.000015 secs
/dev/bus/usb/001/011 test 1,    0.194208 secs
/dev/bus/usb/001/011 test 2,    0.077289 secs
/dev/bus/usb/001/011 test 3,    0.170604 secs
/dev/bus/usb/001/011 test 4,    0.108335 secs
/dev/bus/usb/001/011 test 5,    2.788076 secs
/dev/bus/usb/001/011 test 6,    2.594610 secs
/dev/bus/usb/001/011 test 7,    2.905459 secs
/dev/bus/usb/001/011 test 8,    2.795193 secs
/dev/bus/usb/001/011 test 9,    8.372651 secs
/dev/bus/usb/001/011 test 10,    6.919731 secs
/dev/bus/usb/001/011 test 11,   16.372687 secs
/dev/bus/usb/001/011 test 12,   16.375233 secs
/dev/bus/usb/001/011 test 13,    2.977457 secs
/dev/bus/usb/001/011 test 14 --> 22 (Invalid argument)
/dev/bus/usb/001/011 test 17,    0.148826 secs
/dev/bus/usb/001/011 test 18,    0.068718 secs
/dev/bus/usb/001/011 test 19,    0.125992 secs
/dev/bus/usb/001/011 test 20,    0.127477 secs
/dev/bus/usb/001/011 test 21 --> 22 (Invalid argument)
/dev/bus/usb/001/011 test 24,    4.133763 secs
/dev/bus/usb/001/011 test 27,    2.140066 secs
/dev/bus/usb/001/011 test 28,    2.120713 secs
/dev/bus/usb/001/011 test 29,    0.507762 secs

Signed-off-by: Faizel K B <faizel.kb@dicortech.com>
Link: https://lore.kernel.org/r/20210902114444.15106-1-faizel.kb@dicortech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/usb/testusb.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/tools/usb/testusb.c b/tools/usb/testusb.c
index ee8208b2f946..69c3ead25313 100644
--- a/tools/usb/testusb.c
+++ b/tools/usb/testusb.c
@@ -265,12 +265,6 @@ static int find_testdev(const char *name, const struct stat *sb, int flag)
 	}
 
 	entry->ifnum = ifnum;
-
-	/* FIXME update USBDEVFS_CONNECTINFO so it tells about high speed etc */
-
-	fprintf(stderr, "%s speed\t%s\t%u\n",
-		speed(entry->speed), entry->name, entry->ifnum);
-
 	entry->next = testdevs;
 	testdevs = entry;
 	return 0;
@@ -299,6 +293,14 @@ static void *handle_testdev (void *arg)
 		return 0;
 	}
 
+	status  =  ioctl(fd, USBDEVFS_GET_SPEED, NULL);
+	if (status < 0)
+		fprintf(stderr, "USBDEVFS_GET_SPEED failed %d\n", status);
+	else
+		dev->speed = status;
+	fprintf(stderr, "%s speed\t%s\t%u\n",
+			speed(dev->speed), dev->name, dev->ifnum);
+
 restart:
 	for (i = 0; i < TEST_CASES; i++) {
 		if (dev->test != -1 && dev->test != i)
-- 
2.33.0

