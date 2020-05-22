Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FA61DE55A
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 13:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbgEVL1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 07:27:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728281AbgEVL1w (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 07:27:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA09A206BE;
        Fri, 22 May 2020 11:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590146871;
        bh=STpKmfdYolBfupbwpDAqY4JB1JK4PcdG+xwdfcis508=;
        h=Subject:To:From:Date:From;
        b=uhrD2pIKl719tVngZvSoNNw0Z86Ykw9yLknAxbT6Gis7MvNvOF05XqlPigRj2agFf
         13bnyvX6lHbIKIuP+puDUb/+5bIGGVf3cgoSyMy48A6UgdzIGKRK7KbvqgA/nt1osz
         Luxn1DRKIzZHHA7tpzZvjUmmMej5MquKGPctp0Wg=
Subject: patch "misc: rtsx: Add short delay after exit from ASPM" added to char-misc-linus
To:     kdlnx@doth.eu, gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 22 May 2020 13:27:49 +0200
Message-ID: <159014686948249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    misc: rtsx: Add short delay after exit from ASPM

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7a839dbab1be59f5ed3b3b046de29e166784c9b4 Mon Sep 17 00:00:00 2001
From: Klaus Doth <kdlnx@doth.eu>
Date: Fri, 22 May 2020 12:56:04 +0200
Subject: misc: rtsx: Add short delay after exit from ASPM

DMA transfers to and from the SD card stall for 10 seconds and run into
timeout on RTS5260 card readers after ASPM was enabled.

Adding a short msleep after disabling ASPM fixes the issue on several
Dell Precision 7530/7540 systems I tested.

This function is only called when waking up after the chip went into
power-save after not transferring data for a few seconds. The added
msleep does therefore not change anything in data transfer speed or
induce any excessive waiting while data transfers are running, or the
chip is sleeping. Only the transition from sleep to active is affected.

Signed-off-by: Klaus Doth <kdlnx@doth.eu>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/4434eaa7-2ee3-a560-faee-6cee63ebd6d4@doth.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/cardreader/rtsx_pcr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/misc/cardreader/rtsx_pcr.c b/drivers/misc/cardreader/rtsx_pcr.c
index 06038b325b02..55da6428ceb0 100644
--- a/drivers/misc/cardreader/rtsx_pcr.c
+++ b/drivers/misc/cardreader/rtsx_pcr.c
@@ -142,6 +142,9 @@ static void rtsx_comm_pm_full_on(struct rtsx_pcr *pcr)
 
 	rtsx_disable_aspm(pcr);
 
+	/* Fixes DMA transfer timout issue after disabling ASPM on RTS5260 */
+	msleep(1);
+
 	if (option->ltr_enabled)
 		rtsx_set_ltr_latency(pcr, option->ltr_active_latency);
 
-- 
2.26.2


