Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51BB1B5AB3
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 13:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgDWLpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 07:45:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727088AbgDWLpf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 07:45:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B29C2077D;
        Thu, 23 Apr 2020 11:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587642334;
        bh=pZa2nkfiz+IeJ4GJXA5/5UFzWbJg3mh7gXzhLHL+GPs=;
        h=Subject:To:From:Date:From;
        b=SuHNw/dhj423ReowN3PsfcFMAfL4/94FbYkzu+NVi34dxXdqQSGhgIojtl7pQuieO
         j/YjJmRBxOfM0j8OQE6LwJW+jjKBuanMUTA3y3maBb3Qe8mWzEgVH5yW7Q4T4pMt4i
         ZC/FY9W3qVSBxrJ70qUm3hL/taTk1Cota+ejSFNQ=
Subject: patch "staging: comedi: Fix comedi_device refcnt leak in comedi_open" added to staging-linus
To:     xiyuyang19@fudan.edu.cn, abbotti@mev.co.uk,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        tanxin.ctf@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 Apr 2020 13:45:32 +0200
Message-ID: <1587642332209228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: comedi: Fix comedi_device refcnt leak in comedi_open

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 332e0e17ad49e084b7db670ef43b5eb59abd9e34 Mon Sep 17 00:00:00 2001
From: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Date: Mon, 20 Apr 2020 13:44:16 +0800
Subject: staging: comedi: Fix comedi_device refcnt leak in comedi_open

comedi_open() invokes comedi_dev_get_from_minor(), which returns a
reference of the COMEDI device to "dev" with increased refcount.

When comedi_open() returns, "dev" becomes invalid, so the refcount
should be decreased to keep refcount balanced.

The reference counting issue happens in one exception handling path of
comedi_open(). When "cfp" allocation is failed, the refcnt increased by
comedi_dev_get_from_minor() is not decreased, causing a refcnt leak.

Fix this issue by calling comedi_dev_put() on this error path when "cfp"
allocation is failed.

Fixes: 20f083c07565 ("staging: comedi: prepare support for per-file read and write subdevices")
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/1587361459-83622-1-git-send-email-xiyuyang19@fudan.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/comedi_fops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 08d1bbbebf2d..e84b4fb493d6 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -2725,8 +2725,10 @@ static int comedi_open(struct inode *inode, struct file *file)
 	}
 
 	cfp = kzalloc(sizeof(*cfp), GFP_KERNEL);
-	if (!cfp)
+	if (!cfp) {
+		comedi_dev_put(dev);
 		return -ENOMEM;
+	}
 
 	cfp->dev = dev;
 
-- 
2.26.2


