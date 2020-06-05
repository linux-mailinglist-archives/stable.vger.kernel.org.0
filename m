Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7F31EFAD2
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgFEOVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:21:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728941AbgFEOUS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:20:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01309206DC;
        Fri,  5 Jun 2020 14:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366817;
        bh=2Ovjp60VIwBljOoEVFT7uq/DsgfITO8n10lmxaues1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s5sFn0khgzdFQ8FgjdVtxwvAydZu1QazSIU4Iqm9kBKdOJ8QGoQHVTlmMckCitwpk
         aN+THsDAQmDgeJqokR2aYql6SKspCJ4mAsohm2qFfF0D+i8NxuuNNk9p2EpdrSe9fg
         Osi28PGRa3KRrEbfCKjtCS/DHTJ+uFN5Z4dNn1+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Shumate <scott.shumate@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.19 04/28] HID: sony: Fix for broken buttons on DS3 USB dongles
Date:   Fri,  5 Jun 2020 16:15:06 +0200
Message-Id: <20200605140252.586688136@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140252.338635395@linuxfoundation.org>
References: <20200605140252.338635395@linuxfoundation.org>
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
@@ -869,6 +869,23 @@ static u8 *sony_report_fixup(struct hid_
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
 


