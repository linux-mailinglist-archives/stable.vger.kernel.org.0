Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131452E3FDD
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503094AbgL1OpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:45:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:48074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506447AbgL1OpX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:45:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DE99207B2;
        Mon, 28 Dec 2020 14:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609166682;
        bh=soi/Z39qfKjvX2EvWkUsD9CGtTo7GaIJO72sPMu2zVc=;
        h=Subject:To:From:Date:From;
        b=qnlUu7YD5Mh4t768hVtuX8FM4vfHHJT+QcYsdztKCtuztT0KSeR7PmEnmitTM18vv
         6rEmjpaHhvCIJzbvYOarcc9KyqfYusWTUV7rZROljg3pQzyaBoUlUNkyKb/hM/lqxC
         7jP6J0Uu4ORRbzRA9cLSh7sSgK8OJl4cKDDQHcdk=
Subject: patch "usb: gadget: function: printer: Fix a memory leak for interface" added to usb-linus
To:     qiang.zhang@windriver.com, gregkh@linuxfoundation.org,
        peter.chen@nxp.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 15:46:02 +0100
Message-ID: <160916676239178@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: function: printer: Fix a memory leak for interface

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 2cc332e4ee4febcbb685e2962ad323fe4b3b750a Mon Sep 17 00:00:00 2001
From: Zqiang <qiang.zhang@windriver.com>
Date: Thu, 10 Dec 2020 10:01:48 +0800
Subject: usb: gadget: function: printer: Fix a memory leak for interface
 descriptor

When printer driver is loaded, the printer_func_bind function is called, in
this function, the interface descriptor be allocated memory, if after that,
the error occurred, the interface descriptor memory need to be free.

Reviewed-by: Peter Chen <peter.chen@nxp.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Zqiang <qiang.zhang@windriver.com>
Link: https://lore.kernel.org/r/20201210020148.6691-1-qiang.zhang@windriver.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_printer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/function/f_printer.c b/drivers/usb/gadget/function/f_printer.c
index 64a4112068fc..2f1eb2e81d30 100644
--- a/drivers/usb/gadget/function/f_printer.c
+++ b/drivers/usb/gadget/function/f_printer.c
@@ -1162,6 +1162,7 @@ static int printer_func_bind(struct usb_configuration *c,
 		printer_req_free(dev->in_ep, req);
 	}
 
+	usb_free_all_descriptors(f);
 	return ret;
 
 }
-- 
2.29.2


