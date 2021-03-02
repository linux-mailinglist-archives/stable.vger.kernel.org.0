Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBE032B20E
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241137AbhCCAv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:51:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:54088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347026AbhCBRgL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 12:36:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB8A164F12;
        Tue,  2 Mar 2021 14:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614695376;
        bh=Sh3BXtF0F6vgRGuqfsmwdTYLnu10wIWkFUd0lbw8wWo=;
        h=Subject:To:From:Date:From;
        b=SnJq8ShLRzBuEaD+37CxjwMHJ/LppbCnYUPCQa7CSgaPJl+uSYXKGaHjqwASjwDEN
         c9ZtVjszgznJXZEcSqpsQ1R3KhnLvHZfzCVrJQh/vJbqq43fzhnvjM3CZpHCSKkw3J
         rH5GxG4/BeT8X0QH2gevR3LouafOYbZfRUuqBc3U=
Subject: patch "staging: comedi: pcl711: Fix endian problem for AI command data" added to staging-linus
To:     abbotti@mev.co.uk, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 02 Mar 2021 15:29:18 +0100
Message-ID: <161469535824528@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: comedi: pcl711: Fix endian problem for AI command data

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 44f26e028c88555ac92532bac0401f91e6df08a2 Mon Sep 17 00:00:00 2001
From: Ian Abbott <abbotti@mev.co.uk>
Date: Tue, 23 Feb 2021 14:30:49 +0000
Subject: staging: comedi: pcl711: Fix endian problem for AI command data

The analog input subdevice supports Comedi asynchronous commands that
use Comedi's 16-bit sample format.  However, the call to
`comedi_buf_write_samples()` is passing the address of a 32-bit integer
variable.  On bigendian machines, this will copy 2 bytes from the wrong
end of the 32-bit value.  Fix it by changing the type of the variable
holding the sample value to `unsigned short`.

Fixes: 1f44c034de2e ("staging: comedi: pcl711: use comedi_buf_write_samples()")
Cc: <stable@vger.kernel.org> # 3.19+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20210223143055.257402-9-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/pcl711.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/pcl711.c b/drivers/staging/comedi/drivers/pcl711.c
index 2dbf69e30965..bd6f42fe9e3c 100644
--- a/drivers/staging/comedi/drivers/pcl711.c
+++ b/drivers/staging/comedi/drivers/pcl711.c
@@ -184,7 +184,7 @@ static irqreturn_t pcl711_interrupt(int irq, void *d)
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->read_subdev;
 	struct comedi_cmd *cmd = &s->async->cmd;
-	unsigned int data;
+	unsigned short data;
 
 	if (!dev->attached) {
 		dev_err(dev->class_dev, "spurious interrupt\n");
-- 
2.30.1


