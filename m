Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 527F1347154
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 07:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhCXGCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 02:02:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229963AbhCXGBy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Mar 2021 02:01:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E898601FA;
        Wed, 24 Mar 2021 06:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616565714;
        bh=qjAwgMGS0rM0MMoRcg9uYBex/xw8mgXrvFUXBUzKhXw=;
        h=Subject:To:From:Date:From;
        b=MM4hrHoQkE1P2AznG3COunjWnCIVNX/AK/bHg30i2v4IrDEgf1zQLwUy8wFywOF18
         2zfuQOgwVBN9Y1GPb8dYh5bOQDxRoDwZ4clnMNlLUYA06ZhTOrFPDuexpExfSjsRGF
         VI3pW5EngWyWjP/NPQ+0/q25dRG4Bh/GnUr0lZWY=
Subject: patch "usb: gadget/function/f_fs string table fix for multiple languages" added to usb-next
To:     dean@sensoray.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 24 Mar 2021 07:01:08 +0100
Message-ID: <161656566832144@kroah.com>
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
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


