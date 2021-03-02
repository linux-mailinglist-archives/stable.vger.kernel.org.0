Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD82132B0DC
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237092AbhCCAjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:39:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:44196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1448849AbhCBPnB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 10:43:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24BCF64F0B;
        Tue,  2 Mar 2021 14:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614695367;
        bh=gKBn3Qx9rLNDsEAm5121CvbzSUyeC3eu2btPlcSPjbg=;
        h=Subject:To:From:Date:From;
        b=C+vFdRgNFS+rToFD17WBaZTFRyn44IUogWtSo34UbCgWkGhlcYbwowSiGAF0C+xVD
         /g3zOVnyOkOeBOfXnF9eNFQggi787/XtiYqeATUceT9jC+OmONLLYqLjsndx5TWb/p
         XVEuUSO3JjSA9AGNMOYdeqAGbRD0q/cfy3wLbiNU=
Subject: patch "staging: comedi: das800: Fix endian problem for AI command data" added to staging-linus
To:     abbotti@mev.co.uk, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 02 Mar 2021 15:29:16 +0100
Message-ID: <1614695356634@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: comedi: das800: Fix endian problem for AI command data

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4ed84e4c429fbe8453f88276cc48caecd97127de Mon Sep 17 00:00:00 2001
From: Ian Abbott <abbotti@mev.co.uk>
Date: Tue, 23 Feb 2021 14:30:46 +0000
Subject: staging: comedi: das800: Fix endian problem for AI command data

The analog input subdevice supports Comedi asynchronous commands that
use Comedi's 16-bit sample format.  However, the call to
`comedi_buf_write_samples()` is passing the address of a 32-bit integer
variable.  On bigendian machines, this will copy 2 bytes from the wrong
end of the 32-bit value.  Fix it by changing the type of the variable
holding the sample value to `unsigned short`.

Fixes: ad9eb43c93d8 ("staging: comedi: das800: use comedi_buf_write_samples()")
Cc: <stable@vger.kernel.org> # 3.19+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20210223143055.257402-6-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/das800.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/das800.c b/drivers/staging/comedi/drivers/das800.c
index 4ea100ff6930..2881808d6606 100644
--- a/drivers/staging/comedi/drivers/das800.c
+++ b/drivers/staging/comedi/drivers/das800.c
@@ -427,7 +427,7 @@ static irqreturn_t das800_interrupt(int irq, void *d)
 	struct comedi_cmd *cmd;
 	unsigned long irq_flags;
 	unsigned int status;
-	unsigned int val;
+	unsigned short val;
 	bool fifo_empty;
 	bool fifo_overflow;
 	int i;
-- 
2.30.1


