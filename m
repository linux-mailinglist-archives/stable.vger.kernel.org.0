Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0DCF32B0E1
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237331AbhCCAkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:40:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348786AbhCBPqC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 10:46:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B35B60C3E;
        Tue,  2 Mar 2021 14:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614695364;
        bh=pEEF2b+EhWyoGe+XMpA//gkD+beGLLVdMpbluCTSXT4=;
        h=Subject:To:From:Date:From;
        b=QbIfp9xZdYmnLiodT8fRbWGzB3/bmIDqycqYmxKO5EFVjlYTeREhpljWiJvEbMtkD
         rR0HRtRwlsMT8tGGlvbcaojqLluLfzqAHBZe0eKNbbWFjOquVFsvbiaCQTEcNOESFv
         f6QKMPzWgUeoNjQviNYryr1/d1fOAIgb7DPLvQiU=
Subject: patch "staging: comedi: das6402: Fix endian problem for AI command data" added to staging-linus
To:     abbotti@mev.co.uk, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 02 Mar 2021 15:29:15 +0100
Message-ID: <1614695355465@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: comedi: das6402: Fix endian problem for AI command data

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b8c94370d1b3b29e7356e43ddfe0727f79a9b78f Mon Sep 17 00:00:00 2001
From: Ian Abbott <abbotti@mev.co.uk>
Date: Tue, 23 Feb 2021 14:30:45 +0000
Subject: staging: comedi: das6402: Fix endian problem for AI command data

The analog input subdevice supports Comedi asynchronous commands that
use Comedi's 16-bit sample format.  However, the call to
`comedi_buf_write_samples()` is passing the address of a 32-bit integer
variable.  On bigendian machines, this will copy 2 bytes from the wrong
end of the 32-bit value.  Fix it by changing the type of the variable
holding the sample value to `unsigned short`.

Fixes: d1d24cb65ee3 ("staging: comedi: das6402: read analog input samples in interrupt handler")
Cc: <stable@vger.kernel.org> # 3.19+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20210223143055.257402-5-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/das6402.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/das6402.c b/drivers/staging/comedi/drivers/das6402.c
index 04e224f8b779..96f4107b8054 100644
--- a/drivers/staging/comedi/drivers/das6402.c
+++ b/drivers/staging/comedi/drivers/das6402.c
@@ -186,7 +186,7 @@ static irqreturn_t das6402_interrupt(int irq, void *d)
 	if (status & DAS6402_STATUS_FFULL) {
 		async->events |= COMEDI_CB_OVERFLOW;
 	} else if (status & DAS6402_STATUS_FFNE) {
-		unsigned int val;
+		unsigned short val;
 
 		val = das6402_ai_read_sample(dev, s);
 		comedi_buf_write_samples(s, &val, 1);
-- 
2.30.1


