Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52A551008C0
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 16:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfKRPzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 10:55:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:60100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726216AbfKRPzP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Nov 2019 10:55:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 822602071B;
        Mon, 18 Nov 2019 15:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574092515;
        bh=l27dw5JMOy4lAK+oyaoMZyhMu1C8lk7UhPZgQfU6RxM=;
        h=Subject:To:From:Date:From;
        b=V/7X3wOQ9IgChwUkrXIw2hWYBAAC3FVi4jTgmGrGcMrv8b/vjl7M/kKzYnYdWrbhy
         ZUeCEnDii6hNWvgVdKj+mSSbMdewFTJ9UN8QSugKnQqTWgE0u5l6Og+DLZoniI8Rny
         CI4PQEFoRhW9AQ9FVfQm/h8q5KKTdxoxeDDn2GKw=
Subject: patch "USB: uas: heed CAPACITY_HEURISTICS" added to usb-next
To:     oneukum@suse.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Nov 2019 16:53:12 +0100
Message-ID: <157409239248126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: uas: heed CAPACITY_HEURISTICS

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 335cbbd5762d5e5c67a8ddd6e6362c2aa42a328f Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Thu, 14 Nov 2019 12:27:57 +0100
Subject: USB: uas: heed CAPACITY_HEURISTICS

There is no need to ignore this flag. We should be as close
to storage in that regard as makes sense, so honor flags whose
cost is tiny.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191114112758.32747-3-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/uas.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index def2d4aba549..475b9c692827 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -837,6 +837,12 @@ static int uas_slave_configure(struct scsi_device *sdev)
 	if (devinfo->flags & US_FL_FIX_CAPACITY)
 		sdev->fix_capacity = 1;
 
+	/*
+	 * in some cases we have to guess
+	 */
+	if (devinfo->flags & US_FL_CAPACITY_HEURISTICS)
+		sdev->guess_capacity = 1;
+
 	/*
 	 * Some devices don't like MODE SENSE with page=0x3f,
 	 * which is the command used for checking if a device
-- 
2.24.0


