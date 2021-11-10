Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1079944C702
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbhKJSre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:47:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:46092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232845AbhKJSrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:47:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 378FC61205;
        Wed, 10 Nov 2021 18:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636569859;
        bh=f3ccSE1tL1LOo6UtJCpOCCFVaVTv1tNMq5fnMOqcWWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pWQaROiybgMErNlkvqWfpZMVj1erjmGnuvxWRfo56SUkwjyZs7rNrB53OUNbBaTdT
         OoutfW7WYVN6KCVLkVXhTrz2Jaag41rSchiUN1pm84wdULKj1OoFRIVK+F9TYTdyMX
         7wApUp6Lg1HnhnD7/u+my3fuMRbVIEnzEbz+T7Oc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        James Buren <braewoods+lkml@braewoods.net>
Subject: [PATCH 4.4 07/19] usb-storage: Add compatibility quirk flags for iODD 2531/2541
Date:   Wed, 10 Nov 2021 19:43:09 +0100
Message-Id: <20211110182001.498181764@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182001.257350381@linuxfoundation.org>
References: <20211110182001.257350381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Buren <braewoods+lkml@braewoods.net>

commit 05c8f1b67e67dcd786ae3fe44492bbc617b4bd12 upstream.

These drive enclosures have firmware bugs that make it impossible to mount
a new virtual ISO image after Linux ejects the old one if the device is
locked by Linux. Windows bypasses this problem by the fact that they do
not lock the device. Add a quirk to disable device locking for these
drive enclosures.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: James Buren <braewoods+lkml@braewoods.net>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211014015504.2695089-1-braewoods+lkml@braewoods.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_devs.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -311,6 +311,16 @@ UNUSUAL_DEV(  0x045e, 0xffff, 0x0000, 0x
 		US_FL_MAX_SECTORS_64 ),
 
 /*
+ * Reported by James Buren <braewoods+lkml@braewoods.net>
+ * Virtual ISOs cannot be remounted if ejected while the device is locked
+ * Disable locking to mimic Windows behavior that bypasses the issue
+ */
+UNUSUAL_DEV(  0x04c5, 0x2028, 0x0001, 0x0001,
+		"iODD",
+		"2531/2541",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_NOT_LOCKABLE),
+
+/*
  * This virtual floppy is found in Sun equipment (x4600, x4200m2, etc.)
  * Reported by Pete Zaitcev <zaitcev@redhat.com>
  * This device chokes on both version of MODE SENSE which we have, so


