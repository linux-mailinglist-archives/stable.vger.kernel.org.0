Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155E32E3EF3
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505179AbgL1Oem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:34:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:42622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505180AbgL1Oek (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:34:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF9FE206D4;
        Mon, 28 Dec 2020 14:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609166040;
        bh=GF05NxWV2kcZZ0i9OH8fSmj5XB+uPKJ5Ypt34NRf4Tc=;
        h=Subject:To:From:Date:From;
        b=FwrUy+CsrKjPUSF3cFsAJB2oWbzwXaeAmF0CzoQ0xAGWGC0gYbn4qvC3VAHwvfSKT
         OZrRJikjoZq9S/weF3N8HgULj/MdlwRtfroe7UuCUd6P+vaRLlBFo9UDugEL2BimZR
         V4leuDCKIg/VSH516wgD0zxUmIFAVyH6osmjlbu0=
Subject: patch "Staging: comedi: Return -EFAULT if copy_to_user() fails" added to staging-linus
To:     dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 15:15:10 +0100
Message-ID: <1609164910103190@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Staging: comedi: Return -EFAULT if copy_to_user() fails

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From cab36da4bf1a35739b091b73714a39a1bbd02b05 Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 2 Dec 2020 09:43:49 +0300
Subject: Staging: comedi: Return -EFAULT if copy_to_user() fails

Return -EFAULT on error instead of the number of bytes remaining to be
copied.

Fixes: bac42fb21259 ("comedi: get rid of compat_alloc_user_space() mess in COMEDI_CMD{,TEST} compat")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/X8c3pfwFy2jpy4BP@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/comedi_fops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index d99231c737fb..80d74cce2a01 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -2987,7 +2987,9 @@ static int put_compat_cmd(struct comedi32_cmd_struct __user *cmd32,
 	v32.chanlist_len = cmd->chanlist_len;
 	v32.data = ptr_to_compat(cmd->data);
 	v32.data_len = cmd->data_len;
-	return copy_to_user(cmd32, &v32, sizeof(v32));
+	if (copy_to_user(cmd32, &v32, sizeof(v32)))
+		return -EFAULT;
+	return 0;
 }
 
 /* Handle 32-bit COMEDI_CMD ioctl. */
-- 
2.29.2


