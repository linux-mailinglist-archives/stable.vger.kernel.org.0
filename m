Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30A241A869
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 08:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239038AbhI1GEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 02:04:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239871AbhI1GCs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 02:02:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AED8E61391;
        Tue, 28 Sep 2021 05:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808660;
        bh=mi15zyT9T6+AXpeD0B5QFINjteCdWDkTRSQg1MPD12E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cubo2lxYcjV8ViwKRyErXDe9gjcqe//lBHwZRbFPSL7fY86SSrVNkJDliqnRouHcu
         BHeaKsGow45rhBX+txeiK3tFPZG1pJ6Cer+Kgad0VVJ4R9FQkEA9S2nmp0J8D7ebN+
         6W0V/7tYFEvCdrmwA6nQ2Uu0vJKklWcfecJ29ppHHEM2eDUesFUaaZhlwz5sTFTHgx
         9xi9HZCMUjBoqjXpfF5nEq3aYU3duENGwPzIgEFtC8HiW4BGWn19vYh59GbY65dxLZ
         IP09ZIbMrrZ3BmvrGmhc8MXIrxR89oVGr1cHZbjSnEu9aO2VHWvbUkUSgUk9OvLMXS
         j0kespRgssCmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Faizel K B <faizel.kb@dicortech.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 6/6] usb: testusb: Fix for showing the connection speed
Date:   Tue, 28 Sep 2021 01:57:34 -0400
Message-Id: <20210928055734.173182-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055734.173182-1-sashal@kernel.org>
References: <20210928055734.173182-1-sashal@kernel.org>
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
index 0692d99b6d8f..18c895654e76 100644
--- a/tools/usb/testusb.c
+++ b/tools/usb/testusb.c
@@ -278,12 +278,6 @@ static int find_testdev(const char *name, const struct stat *sb, int flag)
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
@@ -312,6 +306,14 @@ static void *handle_testdev (void *arg)
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

