Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFFFE3D60E9
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237705AbhGZPZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:25:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238031AbhGZPYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:24:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72EE960240;
        Mon, 26 Jul 2021 16:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315503;
        bh=PhZhRfJRPe3LexCSI2vN0G6CEGAKLiy1QknDRae4hDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gX5DnwYj4CSON4c9p5G6yBnMEx1sLAtAC/7YzzMaXGLZRt4zMqG8Hs01bJ1zWoHss
         onZp3Cr/OEmbD2Jgq4kU8mLGC/FanVhqnuqvlk2l6hwiqwc09WZXpFX89vTwauJb8d
         KAbncDDC+CAzJRDitJWwBWxiTcG+kGN5iygvMZ1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Sikorski <belegdol+github@gmail.com>
Subject: [PATCH 5.10 123/167] USB: usb-storage: Add LaCie Rugged USB3-FW to IGNORE_UAS
Date:   Mon, 26 Jul 2021 17:39:16 +0200
Message-Id: <20210726153843.530624951@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Sikorski <belegdol@gmail.com>

commit 6abf2fe6b4bf6e5256b80c5817908151d2d33e9f upstream.

LaCie Rugged USB3-FW appears to be incompatible with UAS. It generates
errors like:
[ 1151.582598] sd 14:0:0:0: tag#16 uas_eh_abort_handler 0 uas-tag 1 inflight: IN
[ 1151.582602] sd 14:0:0:0: tag#16 CDB: Report supported operation codes a3 0c 01 12 00 00 00 00 02 00 00 00
[ 1151.588594] scsi host14: uas_eh_device_reset_handler start
[ 1151.710482] usb 2-4: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
[ 1151.741398] scsi host14: uas_eh_device_reset_handler success
[ 1181.785534] scsi host14: uas_eh_device_reset_handler start

Signed-off-by: Julian Sikorski <belegdol+github@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210720171910.36497-1-belegdol+github@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_uas.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -45,6 +45,13 @@ UNUSUAL_DEV(0x059f, 0x105f, 0x0000, 0x99
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_REPORT_OPCODES | US_FL_NO_SAME),
 
+/* Reported-by: Julian Sikorski <belegdol@gmail.com> */
+UNUSUAL_DEV(0x059f, 0x1061, 0x0000, 0x9999,
+		"LaCie",
+		"Rugged USB3-FW",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
+
 /*
  * Apricorn USB3 dongle sometimes returns "USBSUSBSUSBS" in response to SCSI
  * commands in UAS mode.  Observed with the 1.28 firmware; are there others?


