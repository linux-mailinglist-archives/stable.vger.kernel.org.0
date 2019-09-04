Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86A46A91A3
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389416AbfIDSU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:20:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389643AbfIDSH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:07:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E3BA206B8;
        Wed,  4 Sep 2019 18:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620446;
        bh=0yclGDOg7Dy3vf9xGWlNF8+UryRlkRqDD76l1GgU0bU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0eRDfi7Cp0t6c2RCyqiDVZWMZeYhfiA/zfbghxCtu4v71ohNRMoJIZ6aTirp0tH/6
         AppEsrjjuOJCEvIzXcpMiiQmeFPw88DA+PwMWAZn9NUtNOtF1tjgQ3KYtmCswbQr4m
         8EeFKy6ldAFo0e4LVCd7x05IIvJx9+tQLWj18gD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 4.19 61/93] USB: storage: ums-realtek: Whitelist auto-delink support
Date:   Wed,  4 Sep 2019 19:54:03 +0200
Message-Id: <20190904175308.301296683@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190827173450.13572-2-kai.heng.feng@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/realtek_cr.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -996,12 +996,15 @@ static int init_realtek_cr(struct us_dat
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


