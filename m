Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E91512D37F
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 19:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbfL3SqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 13:46:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:50964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727278AbfL3SqG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Dec 2019 13:46:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F08320722;
        Mon, 30 Dec 2019 18:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577731565;
        bh=cKb5UpuZFOHl1UNYsUiZ3SuY8fxaSvpf9z6xab6Um6I=;
        h=Subject:To:From:Date:From;
        b=mcF6SHwqkdzK8iYSxLKvhQCj4kwBlGLIAJlITtDah+zftjjDjDOcxK6J3HENi0x5K
         ujCu4RmqsIPqmcG50Dg+3AR9IJ+STBAY5wJcLao5Z4JXLQja/vl3m2Z7S89v5JBS2j
         8LTjuht0E24+2mnoWt/U4mVjB4egKzOC9lBj/BuM=
Subject: patch "tty: always relink the port" added to tty-linus
To:     sudipm.mukherjee@gmail.com, gregkh@linuxfoundation.org,
        kenny@panix.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 30 Dec 2019 19:46:02 +0100
Message-ID: <157773156293118@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: always relink the port

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 273f632912f1b24b642ba5b7eb5022e43a72f3b5 Mon Sep 17 00:00:00 2001
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date: Fri, 27 Dec 2019 17:44:34 +0000
Subject: tty: always relink the port

If the serial device is disconnected and reconnected, it re-enumerates
properly but does not link it. fwiw, linking means just saving the port
index, so allow it always as there is no harm in saving the same value
again even if it tries to relink with the same port.

Fixes: fb2b90014d78 ("tty: link tty and port before configuring it as console")
Reported-by: Kenneth R. Crudup <kenny@panix.com>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191227174434.12057-1-sudipm.mukherjee@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/tty_port.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 5023c85ebc6e..044c3cbdcfa4 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -89,8 +89,7 @@ void tty_port_link_device(struct tty_port *port,
 {
 	if (WARN_ON(index >= driver->num))
 		return;
-	if (!driver->ports[index])
-		driver->ports[index] = port;
+	driver->ports[index] = port;
 }
 EXPORT_SYMBOL_GPL(tty_port_link_device);
 
-- 
2.24.1


