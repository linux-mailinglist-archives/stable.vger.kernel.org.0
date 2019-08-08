Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3E185AF8
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 08:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730149AbfHHGl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 02:41:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728167AbfHHGl5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 02:41:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED5EF20880;
        Thu,  8 Aug 2019 06:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565246517;
        bh=g6lkpe/gilZTn/iqseDo2rhLG3Z/sb2PgYBcZ1LT9+Q=;
        h=Subject:To:From:Date:From;
        b=vMxtOrKYf4WIKyH2enswkFDTVi9qI10IFr1c2h4SiB/enGgOA5RrWWhgvGIMG7z5i
         hFgWJgk8J/vsvKlNgtyQMh+7GsATYmT0BnlJCLlM9nvEBD+3eC8ILMzfW0Hqo3JxAu
         3StzJ8FhbIyKcharUT7/IhZ/x7JRqpYpGX1xOeJ4=
Subject: patch "Revert "kernfs: fix memleak in kernel_ops_readdir()"" added to driver-core-linus
To:     gregkh@linuxfoundation.org, aarcange@redhat.com,
        stable@vger.kernel.org, tj@kernel.org, tony@atomide.com
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 08 Aug 2019 08:41:55 +0200
Message-ID: <156524651515552@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "kernfs: fix memleak in kernel_ops_readdir()"

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 8097c43bcbec56fbd0788d99e1e236c0e0d4013f Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 8 Aug 2019 08:39:35 +0200
Subject: Revert "kernfs: fix memleak in kernel_ops_readdir()"

This reverts commit cc798c83898ea0a77fcaa1a92afda35c3c3ded74.

Tony writes:
	Somehow this causes a regression in Linux next for me where I'm
	seeing lots of sysfs entries now missing under
	/sys/bus/platform/devices.

	For example, I now only see one .serial entry show up in sysfs.
	Things work again if I revert commit cc798c83898e ("kernfs: fix
	memleak inkernel_ops_readdir()"). Any ideas why that would be?

Tejun says:
	Ugh, you're right.  It can get double-put cuz ctx->pos is put by
	release too.

So reverting it for now.

Reported-by: Tony Lindgren <tony@atomide.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Fixes: cc798c83898e ("kernfs: fix memleak in kernel_ops_readdir()")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/kernfs/dir.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 1e98efc2bf6d..a387534c9577 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1684,14 +1684,11 @@ static int kernfs_fop_readdir(struct file *file, struct dir_context *ctx)
 		kernfs_get(pos);
 
 		mutex_unlock(&kernfs_mutex);
-		if (unlikely(!dir_emit(ctx, name, len, ino, type))) {
-			kernfs_put(pos);
-			goto out;
-		}
+		if (!dir_emit(ctx, name, len, ino, type))
+			return 0;
 		mutex_lock(&kernfs_mutex);
 	}
 	mutex_unlock(&kernfs_mutex);
-out:
 	file->private_data = NULL;
 	ctx->pos = INT_MAX;
 	return 0;
-- 
2.22.0


