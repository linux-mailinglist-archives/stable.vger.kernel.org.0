Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DE24136BE
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 17:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhIUPzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 11:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhIUPzk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 11:55:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34A8961183;
        Tue, 21 Sep 2021 15:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632239651;
        bh=jvHTgUXU3x96sVQ5vy4SBCcOHjGkXAFprBzdH03EReo=;
        h=Subject:To:From:Date:From;
        b=mmfpEnZ/QwwWMa1Qg7W3NxcoL7eZxSxnZvucFJCbiEqIDe65Gn8khFV2jH/9vddJg
         XwEcK3xThk6PsOGeqJCvX9Kx02bVDdX5XHfs/B+Cs9NoGlO9Lvfsr+zX+DAVW+bQH1
         LkfLRAu8c9DJ5py6XXcapEv7STjd0bvvWD4fZpK8=
Subject: patch "comedi: Fix memory leak in compat_insnlist()" added to char-misc-linus
To:     abbotti@mev.co.uk, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Sep 2021 17:54:09 +0200
Message-ID: <163223964913653@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    comedi: Fix memory leak in compat_insnlist()

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From bb509a6ffed2c8b0950f637ab5779aa818ed1596 Mon Sep 17 00:00:00 2001
From: Ian Abbott <abbotti@mev.co.uk>
Date: Thu, 16 Sep 2021 15:50:23 +0100
Subject: comedi: Fix memory leak in compat_insnlist()

`compat_insnlist()` handles the 32-bit version of the `COMEDI_INSNLIST`
ioctl (whenwhen `CONFIG_COMPAT` is enabled).  It allocates memory to
temporarily hold an array of `struct comedi_insn` converted from the
32-bit version in user space.  This memory is only being freed if there
is a fault while filling the array, otherwise it is leaked.

Add a call to `kfree()` to fix the leak.

Fixes: b8d47d881305 ("comedi: get rid of compat_alloc_user_space() mess in COMEDI_INSNLIST compat")
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-staging@lists.linux.dev
Cc: <stable@vger.kernel.org> # 5.13+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20210916145023.157479-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/comedi_fops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/comedi/comedi_fops.c b/drivers/comedi/comedi_fops.c
index df77b6bf5c64..763cea8418f8 100644
--- a/drivers/comedi/comedi_fops.c
+++ b/drivers/comedi/comedi_fops.c
@@ -3090,6 +3090,7 @@ static int compat_insnlist(struct file *file, unsigned long arg)
 	mutex_lock(&dev->mutex);
 	rc = do_insnlist_ioctl(dev, insns, insnlist32.n_insns, file);
 	mutex_unlock(&dev->mutex);
+	kfree(insns);
 	return rc;
 }
 
-- 
2.33.0


