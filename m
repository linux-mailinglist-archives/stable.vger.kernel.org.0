Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E32040DD64
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 16:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239031AbhIPO6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 10:58:10 -0400
Received: from smtp78.iad3a.emailsrvr.com ([173.203.187.78]:59458 "EHLO
        smtp78.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238991AbhIPO6G (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 10:58:06 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Sep 2021 10:58:06 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1631803835;
        bh=ARRShqYel/AFPgRIrMAGJ0CCJl0lX8sUyPk06CsbnLQ=;
        h=From:To:Subject:Date:From;
        b=JyZrHXC0EhhT0ccYrGDyFYJR0/Bi/a3uV1my7NtCphcVbS1xSN+RYJqXI0yMEQtAE
         2kFZDioQBMkjuNCYIbnxWfdBzCUQwxC7GakCmif4sD4m6ihOqmVsCZhEbGUE+Vh1T+
         2xpPf1HuwTmCZ0nNXy38FhjxbVasqQFLZQwBKZwo=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp2.relay.iad3a.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 469B2282B;
        Thu, 16 Sep 2021 10:50:34 -0400 (EDT)
From:   Ian Abbott <abbotti@mev.co.uk>
To:     linux-kernel@vger.kernel.org
Cc:     Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-staging@lists.linux.dev, stable@vger.kernel.org
Subject: [PATCH v2] comedi: Fix memory leak in compat_insnlist()
Date:   Thu, 16 Sep 2021 15:50:23 +0100
Message-Id: <20210916145023.157479-1-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916144438.156858-1-abbotti@mev.co.uk>
References: <20210916144438.156858-1-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Classification-ID: 6b5d46b7-08db-410e-b953-84ff91fa7dea-1-1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

`compat_insnlist()` handles the 32-bit version of the `COMEDI_INSNLIST`
ioctl (whenwhen `CONFIG_COMPAT` is enabled).  It allocates memory to
temporarily hold an array of `struct comedi_insn` converted from the
32-bit version in user space.  This memory is only being freed if there
is a fault while filling the array, otherwise it is leaked.

Add a call to `kfree()` to fix the leak.

Fixes: b8d47d881305 ("comedi: get rid of compat_alloc_user_space() mess in COMEDI_INSNLIST compat"
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-staging@lists.linux.dev
Cc: <stable@vger.kernel.org> # 5.13+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
v2: Corrected typo in Greg's email address.

N.B. Also need patches for 5.8+ from before comedi moved out of staging.
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

