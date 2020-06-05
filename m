Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BACC1EFA41
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbgFEOQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:16:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728028AbgFEOQA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:16:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEDBB2063A;
        Fri,  5 Jun 2020 14:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366560;
        bh=D4r6OX5ozF6eB8oFMSsc6D1ClCAeu0v3Pg3qY5inDxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eN1BQSLOo5V4ZGS6hVLXxcku+0q8UbqLfb2yH1Cm/KEXuiFIMu5sZRTen8XAo2ei0
         etyhwoJN+pXdby4AHdDjHXps8W507h7dq0rzdfmQChy8BtlLmkdZ/VzJ+HfFv81Oej
         czZBqaOf8ZoTZgTeq7OaU8zPeK86l1PC4ohmausk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Shumate <scott.shumate@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.7 03/14] HID: sony: Fix for broken buttons on DS3 USB dongles
Date:   Fri,  5 Jun 2020 16:14:53 +0200
Message-Id: <20200605135951.231302633@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605135951.018731965@linuxfoundation.org>
References: <20200605135951.018731965@linuxfoundation.org>
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
 


