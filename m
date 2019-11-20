Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A18B103F42
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731807AbfKTPm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:42:29 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52898 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731462AbfKTPkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:20 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5V-0004ag-NT; Wed, 20 Nov 2019 15:40:13 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5U-0004K2-JD; Wed, 20 Nov 2019 15:40:12 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Kai-Heng Feng" <kai.heng.feng@canonical.com>
Date:   Wed, 20 Nov 2019 15:38:06 +0000
Message-ID: <lsq.1574264230.62727835@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 56/83] USB: storage: ums-realtek: Whitelist
 auto-delink support
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 1902a01e2bcc3abd7c9a18dc05e78c7ab4a53c54 upstream.

Auto-delink requires writing special registers to ums-realtek devices.
Unconditionally enable auto-delink may break newer devices.

So only enable auto-delink by default for the original three IDs,
0x0138, 0x0158 and 0x0159.

Realtek is working on a patch to properly support auto-delink for other
IDs.

BugLink: https://bugs.launchpad.net/bugs/1838886
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20190827173450.13572-2-kai.heng.feng@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/storage/realtek_cr.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -1001,12 +1001,15 @@ static int init_realtek_cr(struct us_dat
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

