Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E03AFA0BD5
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 22:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfH1UtK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 16:49:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbfH1UtK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 16:49:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C90A422DA7;
        Wed, 28 Aug 2019 20:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567025349;
        bh=EecSsAZcVN8XMkT8NHO5mdbEG5MjSJPnIkYkhoNQbIQ=;
        h=Subject:To:From:Date:From;
        b=R65YCMZTsMFvfhHE+XUHKWF8t9K3xfRSd+bdsewxBhBPQ24iviwberRSldjkN98bW
         e7s/LBT9cSGSCP5ca3zHAHoYV9skkdL85zoEn07IDkic1KXzmtuSUDMom9Gsy9ppVI
         pwNtTQOuOhW4ZWbE5M9duEqG+/RpBVXoREOyiNMY=
Subject: patch "USB: storage: ums-realtek: Whitelist auto-delink support" added to usb-linus
To:     kai.heng.feng@canonical.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Aug 2019 22:48:58 +0200
Message-ID: <1567025338157107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: storage: ums-realtek: Whitelist auto-delink support

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1902a01e2bcc3abd7c9a18dc05e78c7ab4a53c54 Mon Sep 17 00:00:00 2001
From: Kai-Heng Feng <kai.heng.feng@canonical.com>
Date: Wed, 28 Aug 2019 01:34:50 +0800
Subject: USB: storage: ums-realtek: Whitelist auto-delink support

Auto-delink requires writing special registers to ums-realtek devices.
Unconditionally enable auto-delink may break newer devices.

So only enable auto-delink by default for the original three IDs,
0x0138, 0x0158 and 0x0159.

Realtek is working on a patch to properly support auto-delink for other
IDs.

BugLink: https://bugs.launchpad.net/bugs/1838886
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190827173450.13572-2-kai.heng.feng@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/realtek_cr.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
index beaffac805af..1d9ce9cbc831 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -996,12 +996,15 @@ static int init_realtek_cr(struct us_data *us)
 			goto INIT_FAIL;
 	}
 
-	if (CHECK_FW_VER(chip, 0x5888) || CHECK_FW_VER(chip, 0x5889) ||
-	    CHECK_FW_VER(chip, 0x5901))
-		SET_AUTO_DELINK(chip);
-	if (STATUS_LEN(chip) == 16) {
-		if (SUPPORT_AUTO_DELINK(chip))
+	if (CHECK_PID(chip, 0x0138) || CHECK_PID(chip, 0x0158) ||
+	    CHECK_PID(chip, 0x0159)) {
+		if (CHECK_FW_VER(chip, 0x5888) || CHECK_FW_VER(chip, 0x5889) ||
+				CHECK_FW_VER(chip, 0x5901))
 			SET_AUTO_DELINK(chip);
+		if (STATUS_LEN(chip) == 16) {
+			if (SUPPORT_AUTO_DELINK(chip))
+				SET_AUTO_DELINK(chip);
+		}
 	}
 #ifdef CONFIG_REALTEK_AUTOPM
 	if (ss_en)
-- 
2.23.0


