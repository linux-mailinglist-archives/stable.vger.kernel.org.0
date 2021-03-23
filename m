Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEFA345D73
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 12:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbhCWLze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 07:55:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229944AbhCWLzJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Mar 2021 07:55:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AB07601FF;
        Tue, 23 Mar 2021 11:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616500509;
        bh=hPmHJKLQOjF245FFsrf2R7JYhaz14P4ZZSyjfkhBif0=;
        h=Subject:To:From:Date:From;
        b=m4YFCYovYJBQ5P9j2fWPdso1CIMi44/Fz3wm3ZejnayvMWk96LpNiCIi6wKfJuIXp
         UlIM+Zzt5PT95k7KzmQKEsI7yHTeJO48f/UIURzZ5YiHgQDf4MnUFt98rU2hqty14m
         qCLuB6FmEPn8Bzdz7EWKNH3Fodr0n0lJN1C9bPJY=
Subject: patch "usb: gadget/function/f_fs string table fix for multiple languages" added to usb-testing
To:     dean@sensoray.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Mar 2021 12:55:06 +0100
Message-ID: <161650050614049@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget/function/f_fs string table fix for multiple languages

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 55b74ce7d2ce0b0058f3e08cab185a0afacfe39e Mon Sep 17 00:00:00 2001
From: Dean Anderson <dean@sensoray.com>
Date: Wed, 17 Mar 2021 15:41:09 -0700
Subject: usb: gadget/function/f_fs string table fix for multiple languages

Fixes bug with the handling of more than one language in
the string table in f_fs.c.
str_count was not reset for subsequent language codes.
str_count-- "rolls under" and processes u32 max strings on
the processing of the second language entry.
The existing bug can be reproduced by adding a second language table
to the structure "strings" in tools/usb/ffs-test.c.

Signed-off-by: Dean Anderson <dean@sensoray.com>
Link: https://lore.kernel.org/r/20210317224109.21534-1-dean@sensoray.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 801a8b668a35..10a5d9f0f2b9 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -2640,6 +2640,7 @@ static int __ffs_data_got_strings(struct ffs_data *ffs,
 
 	do { /* lang_count > 0 so we can use do-while */
 		unsigned needed = needed_count;
+		u32 str_per_lang = str_count;
 
 		if (len < 3)
 			goto error_free;
@@ -2675,7 +2676,7 @@ static int __ffs_data_got_strings(struct ffs_data *ffs,
 
 			data += length + 1;
 			len -= length + 1;
-		} while (--str_count);
+		} while (--str_per_lang);
 
 		s->id = 0;   /* terminator */
 		s->s = NULL;
-- 
2.31.0


