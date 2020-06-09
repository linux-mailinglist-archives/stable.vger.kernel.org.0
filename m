Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61BED1F45B4
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732544AbgFISTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:19:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732521AbgFIRtc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:49:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13FA320825;
        Tue,  9 Jun 2020 17:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591724971;
        bh=SY18GA+tIARb2YcCuYXnUlMY8ORXBTCf1RfbNoTV/5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0EEVdbA5XtZf+u1K1ilcVksiHy3r9xnhndS73XgikRuxJn8iddoknyqH+OxfOOJ0S
         xl1H6BdqcPao/U43gC2hfa2sfhDhq3KiihkT+R5lB0QUpZcetNHObbH0D43cY3zXVv
         4rxH39J30Hda4yoweyIQknWyYa2kn3nkZBifnFJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Shumate <scott.shumate@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.14 16/46] HID: sony: Fix for broken buttons on DS3 USB dongles
Date:   Tue,  9 Jun 2020 19:44:32 +0200
Message-Id: <20200609174024.450732239@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174022.938987501@linuxfoundation.org>
References: <20200609174022.938987501@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Shumate <scott.shumate@gmail.com>

commit e72455b898ac678667c5674668186b4670d87d11 upstream.

Fix for non-working buttons on knock-off USB dongles for Sony
controllers. These USB dongles are used to connect older Sony DA/DS1/DS2
controllers via USB and are common on Amazon, AliExpress, etc.  Without
the patch, the square, X, and circle buttons do not function.  These
dongles used to work prior to kernel 4.10 but removing the global DS3
report fixup in commit e19a267b9987 ("HID: sony: DS3 comply to Linux gamepad
spec") exposed the problem.

Many people reported the problem on the Ubuntu forums and are working
around the problem by falling back to the 4.9 hid-sony driver.

The problem stems from these dongles incorrectly reporting their button
count as 13 instead of 16.  This patch fixes up the report descriptor by
changing the button report count to 16 and removing 3 padding bits.

Cc: stable@vger.kernel.org
Fixes: e19a267b9987 ("HID: sony: DS3 comply to Linux gamepad spec")
Signed-off-by: Scott Shumate <scott.shumate@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-sony.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -837,6 +837,23 @@ static u8 *sony_report_fixup(struct hid_
 	if (sc->quirks & PS3REMOTE)
 		return ps3remote_fixup(hdev, rdesc, rsize);
 
+	/*
+	 * Some knock-off USB dongles incorrectly report their button count
+	 * as 13 instead of 16 causing three non-functional buttons.
+	 */
+	if ((sc->quirks & SIXAXIS_CONTROLLER_USB) && *rsize >= 45 &&
+		/* Report Count (13) */
+		rdesc[23] == 0x95 && rdesc[24] == 0x0D &&
+		/* Usage Maximum (13) */
+		rdesc[37] == 0x29 && rdesc[38] == 0x0D &&
+		/* Report Count (3) */
+		rdesc[43] == 0x95 && rdesc[44] == 0x03) {
+		hid_info(hdev, "Fixing up USB dongle report descriptor\n");
+		rdesc[24] = 0x10;
+		rdesc[38] = 0x10;
+		rdesc[44] = 0x00;
+	}
+
 	return rdesc;
 }
 


