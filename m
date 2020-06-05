Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC171EFA6A
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbgFEORV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:17:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728420AbgFEORQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:17:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4171208FE;
        Fri,  5 Jun 2020 14:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366635;
        bh=D4r6OX5ozF6eB8oFMSsc6D1ClCAeu0v3Pg3qY5inDxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HAbK+27rAXlvb9Qs2QVCHydzrwP26N9Vd23lEcZcOgraL3mZfB5YoyQkL33ofGyXC
         qfTxv9+rYKKzM/s9d6vxnZZcl6X6RF++qg/HouvSsURmTmJygXfxvSfTZHrxYWbKSQ
         ii9KjH59Wfjz6oIXLtAKz3pyiF0ylv3MHULBI2wk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Shumate <scott.shumate@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.6 32/43] HID: sony: Fix for broken buttons on DS3 USB dongles
Date:   Fri,  5 Jun 2020 16:15:02 +0200
Message-Id: <20200605140154.206385189@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140152.493743366@linuxfoundation.org>
References: <20200605140152.493743366@linuxfoundation.org>
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
@@ -867,6 +867,23 @@ static u8 *sony_report_fixup(struct hid_
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
 


