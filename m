Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405AD4268C4
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240465AbhJHLax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:30:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240468AbhJHLan (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:30:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 934A161040;
        Fri,  8 Oct 2021 11:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692528;
        bh=g4j72Mh0bdT8fhD8A5kB7UcOUznHv2SleGFFDzh1U20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4E+QPFlicEmH84+pcn2PcUFQIA7ONZkBTMMsNec287eAI6ob7d+K45rIEcJXcQBL
         Qtxmg0pRBXGCfY3yHRrrU7e8VSYButGaIxVuIWKiVw5TBohULNHlStINtsTDWTwTLs
         zTGbGYNal1ucP0kVzsib02KNpKBJJW1uduTz56ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Faizel K B <faizel.kb@dicortech.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 6/7] usb: testusb: Fix for showing the connection speed
Date:   Fri,  8 Oct 2021 13:27:38 +0200
Message-Id: <20211008112713.718332587@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112713.515980393@linuxfoundation.org>
References: <20211008112713.515980393@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -278,12 +278,6 @@ nomem:
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



