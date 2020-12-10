Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF642D55E0
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 09:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbgLJI4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 03:56:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:48956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388373AbgLJIzh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 03:55:37 -0500
Subject: patch "staging: comedi: mf6x4: Fix AI end-of-conversion detection" added to staging-next
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607590496;
        bh=6JINkBcoj+cM9Y9z2Qfe8XdvcPeAHprwGqz9T1xca6U=;
        h=To:From:Date:From;
        b=zezfpdGKlUDklUFZyjIDh3OKvVdS8cfDuRtTWOkVgSsQ0aE5SVnYGQu7iqLRqP4Vo
         ojx1sZaEX82M6M4BdjMUaXTf94bObxPOpg75juKZ6dHh4+8YkrOx45wbclNJQaconf
         uhW77meugmP6KJbbEFPwgCiryyS6uSWOSETWXVcA=
To:     abbotti@mev.co.uk, gregkh@linuxfoundation.org, lisovy@gmail.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 10 Dec 2020 09:56:00 +0100
Message-ID: <1607590560243112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: comedi: mf6x4: Fix AI end-of-conversion detection

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 56c90457ebfe9422496aac6ef3d3f0f0ea8b2ec2 Mon Sep 17 00:00:00 2001
From: Ian Abbott <abbotti@mev.co.uk>
Date: Mon, 7 Dec 2020 14:58:06 +0000
Subject: staging: comedi: mf6x4: Fix AI end-of-conversion detection

I have had reports from two different people that attempts to read the
analog input channels of the MF624 board fail with an `ETIMEDOUT` error.

After triggering the conversion, the code calls `comedi_timeout()` with
`mf6x4_ai_eoc()` as the callback function to check if the conversion is
complete.  The callback returns 0 if complete or `-EBUSY` if not yet
complete.  `comedi_timeout()` returns `-ETIMEDOUT` if it has not
completed within a timeout period which is propagated as an error to the
user application.

The existing code considers the conversion to be complete when the EOLC
bit is high.  However, according to the user manuals for the MF624 and
MF634 boards, this test is incorrect because EOLC is an active low
signal that goes high when the conversion is triggered, and goes low
when the conversion is complete.  Fix the problem by inverting the test
of the EOLC bit state.

Fixes: 04b565021a83 ("comedi: Humusoft MF634 and MF624 DAQ cards driver")
Cc: <stable@vger.kernel.org> # v4.4+
Cc: Rostislav Lisovy <lisovy@gmail.com>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20201207145806.4046-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/mf6x4.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/mf6x4.c b/drivers/staging/comedi/drivers/mf6x4.c
index ea430237efa7..9da8dd748078 100644
--- a/drivers/staging/comedi/drivers/mf6x4.c
+++ b/drivers/staging/comedi/drivers/mf6x4.c
@@ -112,8 +112,9 @@ static int mf6x4_ai_eoc(struct comedi_device *dev,
 	struct mf6x4_private *devpriv = dev->private;
 	unsigned int status;
 
+	/* EOLC goes low at end of conversion. */
 	status = ioread32(devpriv->gpioc_reg);
-	if (status & MF6X4_GPIOC_EOLC)
+	if ((status & MF6X4_GPIOC_EOLC) == 0)
 		return 0;
 	return -EBUSY;
 }
-- 
2.29.2


