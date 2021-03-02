Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF2A32B141
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237641AbhCCAok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:44:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:51904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1445858AbhCBQDE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 11:03:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 269BD64F19;
        Tue,  2 Mar 2021 14:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614695378;
        bh=AnrDXOmmPuuUhfjDRUeEsqGL/MKbbS5taMUdawmB8YA=;
        h=Subject:To:From:Date:From;
        b=xRiUfoslDKT9G62gO0BrfVpjnb/KfMx5Q/rnumWvQjYjjU0hIej5CwB22ofFsTB+F
         inGWspBHWjanBbd16C4F0DAv35Xru/8tfvmIwG15HTFMnUWnZnSGdOvW7gSdUr6l/w
         Wg9H8jLwe3UqyL/YtLFZd8zanXL4d0SLQH+N33Ro=
Subject: patch "staging: comedi: pcl818: Fix endian problem for AI command data" added to staging-linus
To:     abbotti@mev.co.uk, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 02 Mar 2021 15:29:19 +0100
Message-ID: <16146953592464@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: comedi: pcl818: Fix endian problem for AI command data

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 6eec186a44c67a5c08adda8fc9d3cd833532a824 Mon Sep 17 00:00:00 2001
From: Ian Abbott <abbotti@mev.co.uk>
Date: Tue, 23 Feb 2021 14:30:50 +0000
Subject: staging: comedi: pcl818: Fix endian problem for AI command data

The analog input subdevice supports Comedi asynchronous commands that
use Comedi's 16-bit sample format.  However, the call to
`comedi_buf_write_samples()` is passing the address of a 32-bit integer
parameter.  On bigendian machines, this will copy 2 bytes from the wrong
end of the 32-bit value.  Fix it by changing the type of the parameter
holding the sample value to `unsigned short`.

[Note: the bug was introduced in commit edf4537bcbf5 ("staging: comedi:
pcl818: use comedi_buf_write_samples()") but the patch applies better to
commit d615416de615 ("staging: comedi: pcl818: introduce
pcl818_ai_write_sample()").]

Fixes: d615416de615 ("staging: comedi: pcl818: introduce pcl818_ai_write_sample()")
Cc: <stable@vger.kernel.org> # 4.0+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20210223143055.257402-10-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/pcl818.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 63e3011158f2..f4b4a686c710 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -423,7 +423,7 @@ static int pcl818_ai_eoc(struct comedi_device *dev,
 
 static bool pcl818_ai_write_sample(struct comedi_device *dev,
 				   struct comedi_subdevice *s,
-				   unsigned int chan, unsigned int val)
+				   unsigned int chan, unsigned short val)
 {
 	struct pcl818_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
-- 
2.30.1


