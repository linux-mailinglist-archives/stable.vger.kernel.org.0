Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92AC1D9F36
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 20:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbgESSWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 14:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbgESSWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 14:22:37 -0400
X-Greylist: delayed 318 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 19 May 2020 11:22:36 PDT
Received: from valentin-vidic.from.hr (valentin-vidic.from.hr [IPv6:2001:470:1f0b:3b7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5EDC08C5C0;
        Tue, 19 May 2020 11:22:36 -0700 (PDT)
X-Virus-Scanned: Debian amavisd-new at valentin-vidic.from.hr
Received: by valentin-vidic.from.hr (Postfix, from userid 1000)
        id 8DE56543; Tue, 19 May 2020 20:17:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=valentin-vidic.from.hr; s=2020; t=1589912232;
        bh=agIZSkznk24x5nRuX+3INPmxl6trTGmhxoT+BEZ/4+w=;
        h=From:To:Cc:Subject:Date:From;
        b=WqVM+uuRUgP1oDGP2/fRdKOzfeQmkdqItQhcBecTsN9KS2cJ4MLGHyqHmuFWWOJGd
         EaHbHtp/gY5HAEAfJf5DIcSWCdgd2TwZ5vzc0vbX0S3oMcCrf7xEeu5Od3k1G/7YuT
         Q6tgt3+H+BWkviCXAwZfriVt9yeJ9XNAuARUMZL4FOSL9jGiM+17P8CwwE0JhdcPgf
         jL6L4/ir+35XVDbrTsq9SWUuFS6wWYAc3MG2uKM6nfcKa0LGm75Ohwn3GkiXm4Tb8W
         MQD0BvC+JLyyHOzFpskrIHev9+T7BPIlhCs4kSm7XPGDeCMdxlWlOeXYx63Bsp+xHh
         aDmMFxWSEpTj6WcJVTQ4DIXHoYCWlqBYfiyK7RBhaSHZMED56bKVRn81BgmbvclSdW
         J7cEjgaVGmt4iFxyNBMt7kvWnZIs5KMQ4xs51ad1ZuqoOl6wVf33wBXiWslwftRwnQ
         meQZZfPHOVeHBe/mYt7UQqWdrYIu43CjQHulvp8ZCzFBp8HdnFBHg1U1hNRT+tloUY
         YBi8u9SkXnc9h60uisWqLmj28RZetBPaMMeAj/qyF6zgXJOdP+8d/dn8GiIt733iQN
         0iYCBxK+/bJ8zAX5t2+Jqo5iRxV2zcrHkvWuYhwfFVvFzMhb4hn+ZB3Dh04eBKwgR6
         4cb7wMcsCXGYJ38rKOwgodJ4=
From:   Valentin Vidic <vvidic@valentin-vidic.from.hr>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Valentin Vidic <vvidic@valentin-vidic.from.hr>,
        stable@vger.kernel.org
Subject: [PATCH] s390/sclp_vt220: Fix console name to match device
Date:   Tue, 19 May 2020 20:16:54 +0200
Message-Id: <20200519181654.16765-1-vvidic@valentin-vidic.from.hr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Console name reported in /proc/consoles:

  ttyS1                -W- (EC p  )    4:65

does not match device name:

  crw--w----    1 root     root        4,  65 May 17 12:18 /dev/ttysclp0

so debian-installer gets confused and fails to start.

Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
Cc: stable@vger.kernel.org
---
 drivers/s390/char/sclp_vt220.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/char/sclp_vt220.c b/drivers/s390/char/sclp_vt220.c
index 3f9a6ef650fa..3c2ed6d01387 100644
--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -35,8 +35,8 @@
 #define SCLP_VT220_MINOR		65
 #define SCLP_VT220_DRIVER_NAME		"sclp_vt220"
 #define SCLP_VT220_DEVICE_NAME		"ttysclp"
-#define SCLP_VT220_CONSOLE_NAME		"ttyS"
-#define SCLP_VT220_CONSOLE_INDEX	1	/* console=ttyS1 */
+#define SCLP_VT220_CONSOLE_NAME		"ttysclp"
+#define SCLP_VT220_CONSOLE_INDEX	0	/* console=ttysclp0 */
 
 /* Representation of a single write request */
 struct sclp_vt220_request {
-- 
2.20.1

