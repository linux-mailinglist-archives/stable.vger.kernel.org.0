Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956E437FB8C
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 18:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbhEMQea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 12:34:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232881AbhEMQeX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 12:34:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF2F461106;
        Thu, 13 May 2021 16:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620923593;
        bh=vBQjaaHSANyzm9JFoFE/baKXArk+csZbiGrMEDy8Pzk=;
        h=Subject:To:From:Date:From;
        b=JuotRvk3g1i5sYh6SxMMb6gqtUUu8Hy/z3Ifmfd70ZYakdvsx/xEZY2kI3eblQL/1
         Vou/CCeeQcVCKC4v1UoA6cG/Sqm3bPYHe2EeUxAxj4Fx1RthuAJej3FBruavFf1Y3c
         lmV87anWATuk6+ySA8xnzPthdA5Zz8YYOUvO02AY=
Subject: patch "Revert "ecryptfs: replace BUG_ON with error handling code"" added to char-misc-linus
To:     gregkh@linuxfoundation.org, code@tyhicks.com, pakki001@umn.edu,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 18:32:57 +0200
Message-ID: <1620923577785@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "ecryptfs: replace BUG_ON with error handling code"

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e1436df2f2550bc89d832ffd456373fdf5d5b5d7 Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 3 May 2021 13:57:15 +0200
Subject: Revert "ecryptfs: replace BUG_ON with error handling code"

This reverts commit 2c2a7552dd6465e8fde6bc9cccf8d66ed1c1eb72.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original commit log for this change was incorrect, no "error
handling code" was added, things will blow up just as badly as before if
any of these cases ever were true.  As this BUG_ON() never fired, and
most of these checks are "obviously" never going to be true, let's just
revert to the original code for now until this gets unwound to be done
correctly in the future.

Cc: Aditya Pakki <pakki001@umn.edu>
Fixes: 2c2a7552dd64 ("ecryptfs: replace BUG_ON with error handling code")
Cc: stable <stable@vger.kernel.org>
Acked-by: Tyler Hicks <code@tyhicks.com>
Link: https://lore.kernel.org/r/20210503115736.2104747-49-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ecryptfs/crypto.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 345f8061e3b4..b1aa993784f7 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -296,10 +296,8 @@ static int crypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
 	struct extent_crypt_result ecr;
 	int rc = 0;
 
-	if (!crypt_stat || !crypt_stat->tfm
-	       || !(crypt_stat->flags & ECRYPTFS_STRUCT_INITIALIZED))
-		return -EINVAL;
-
+	BUG_ON(!crypt_stat || !crypt_stat->tfm
+	       || !(crypt_stat->flags & ECRYPTFS_STRUCT_INITIALIZED));
 	if (unlikely(ecryptfs_verbosity > 0)) {
 		ecryptfs_printk(KERN_DEBUG, "Key size [%zd]; key:\n",
 				crypt_stat->key_size);
-- 
2.31.1


