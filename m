Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E513E8141
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbhHJR5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:57:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237800AbhHJRy4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:54:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4A2B61051;
        Tue, 10 Aug 2021 17:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617478;
        bh=QZCKsrutDYD/xHxMxm/pYSbdmmE2ELG/mHw1a7U2EO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZSgVEohqHseCqLAA2dGKG4nFsz8Ab8SqVwZnTnesAjsSU76zx1K80W6aR/L54+/pw
         OIuC6lpHCv6064gHfV6EzpMgmIwJj1u/vgkby7aihgjRic4V61R79avkb2nxlYLS9t
         //BK5TV6P+rmmr/Oo3j4gyPqt9ZAUdMRVKMrwRpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris <chris@cyber-anlage.de>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.13 077/175] USB: serial: pl2303: fix HX type detection
Date:   Tue, 10 Aug 2021 19:29:45 +0200
Message-Id: <20210810173003.476450744@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 1e9faef4d26de33bd6b5018695996e7394119e5b upstream.

The device release number for HX-type devices is configurable in
EEPROM/OTPROM and cannot be used reliably for type detection.

Assume all (non-H) devices with bcdUSB 1.1 and unknown bcdDevice to be
of HX type while adding a bcdDevice check for HXD and TB (1.1 and 2.0,
respectively).

Reported-by: Chris <chris@cyber-anlage.de>
Fixes: 8a7bf7510d1f ("USB: serial: pl2303: amend and tighten type detection")
Cc: stable@vger.kernel.org	# 5.13
Link: https://lore.kernel.org/r/20210730122156.718-1-johan@kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/pl2303.c |   41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -418,24 +418,33 @@ static int pl2303_detect_type(struct usb
 	bcdDevice = le16_to_cpu(desc->bcdDevice);
 	bcdUSB = le16_to_cpu(desc->bcdUSB);
 
-	switch (bcdDevice) {
-	case 0x100:
-		/*
-		 * Assume it's an HXN-type if the device doesn't support the old read
-		 * request value.
-		 */
-		if (bcdUSB == 0x200 && !pl2303_supports_hx_status(serial))
-			return TYPE_HXN;
+	switch (bcdUSB) {
+	case 0x110:
+		switch (bcdDevice) {
+		case 0x300:
+			return TYPE_HX;
+		case 0x400:
+			return TYPE_HXD;
+		default:
+			return TYPE_HX;
+		}
 		break;
-	case 0x300:
-		if (bcdUSB == 0x200)
+	case 0x200:
+		switch (bcdDevice) {
+		case 0x100:
+			/*
+			 * Assume it's an HXN-type if the device doesn't
+			 * support the old read request value.
+			 */
+			if (!pl2303_supports_hx_status(serial))
+				return TYPE_HXN;
+			break;
+		case 0x300:
 			return TYPE_TA;
-
-		return TYPE_HX;
-	case 0x400:
-		return TYPE_HXD;
-	case 0x500:
-		return TYPE_TB;
+		case 0x500:
+			return TYPE_TB;
+		}
+		break;
 	}
 
 	dev_err(&serial->interface->dev,


