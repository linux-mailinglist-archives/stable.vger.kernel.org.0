Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0431D122E
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 14:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731332AbgEMMEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 08:04:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728165AbgEMMEL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 08:04:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C83C3206CC;
        Wed, 13 May 2020 12:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589371451;
        bh=YuScssObo3ciT4aVVmpFuvNm4YA31sAk7dhs4oLi3Ms=;
        h=Subject:To:From:Date:From;
        b=YZcwKjIt/u7tQNu7uvRCyVhQZ2Qxn5FGsiwbcZXpu8TWF2B4fLsazHwZBeQW+ie3C
         CxC38/cWC0sjzVc3KB48M3A2KG4vkvXMGP7Cc8cpMIWNLrEsBYmQCV/AZ92wy7R6MV
         qKRIlh0iUZt4TUe8/Ivr5BDif69/Wbe+Tybm/ee4=
Subject: patch "staging: greybus: Fix uninitialized scalar variable" added to staging-linus
To:     oscar.carter@gmx.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 13 May 2020 14:03:58 +0200
Message-ID: <1589371438128160@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: greybus: Fix uninitialized scalar variable

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 34625c1931f8204c234c532b446b9f53c69f4b68 Mon Sep 17 00:00:00 2001
From: Oscar Carter <oscar.carter@gmx.com>
Date: Sun, 10 May 2020 12:14:26 +0200
Subject: staging: greybus: Fix uninitialized scalar variable

In the "gb_tty_set_termios" function the "newline" variable is declared
but not initialized. So the "flow_control" member is not initialized and
the OR / AND operations with itself results in an undefined value in
this member.

The purpose of the code is to set the flow control type, so remove the
OR / AND self operator and set the value directly.

Addresses-Coverity-ID: 1374016 ("Uninitialized scalar variable")
Fixes: e55c25206d5c9 ("greybus: uart: Handle CRTSCTS flag in termios")
Signed-off-by: Oscar Carter <oscar.carter@gmx.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200510101426.23631-1-oscar.carter@gmx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/greybus/uart.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/greybus/uart.c b/drivers/staging/greybus/uart.c
index 55c51143bb09..4ffb334cd5cd 100644
--- a/drivers/staging/greybus/uart.c
+++ b/drivers/staging/greybus/uart.c
@@ -537,9 +537,9 @@ static void gb_tty_set_termios(struct tty_struct *tty,
 	}
 
 	if (C_CRTSCTS(tty) && C_BAUD(tty) != B0)
-		newline.flow_control |= GB_SERIAL_AUTO_RTSCTS_EN;
+		newline.flow_control = GB_SERIAL_AUTO_RTSCTS_EN;
 	else
-		newline.flow_control &= ~GB_SERIAL_AUTO_RTSCTS_EN;
+		newline.flow_control = 0;
 
 	if (memcmp(&gb_tty->line_coding, &newline, sizeof(newline))) {
 		memcpy(&gb_tty->line_coding, &newline, sizeof(newline));
-- 
2.26.2


