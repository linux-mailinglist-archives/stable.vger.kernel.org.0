Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C775943F3A
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732270AbfFMPzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:55:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731541AbfFMIv4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:51:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE28120851;
        Thu, 13 Jun 2019 08:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415915;
        bh=0d8TI0j2ekShRSDHeOPaytIPYP4EAXukYrtUJzxK5FU=;
        h=Subject:To:From:Date:From;
        b=df62+liEde9fmi1pMCcl5AR9tUO46MhQLD9GvbXVTzUMSnDWJcm5hSiSZqRAlosqi
         N/ruMECpLi4uXpJLVwp9amgpEbqAo8Tvq2zKn/2WbWoZsMEAeYtodwRuC0B9TyiSOm
         SIbb7o9KwalztxFMoEiz7o4i8dtCHMIg0o8HE+oU=
Subject: patch "binder: fix possible UAF when freeing buffer" added to char-misc-linus
To:     tkjos@android.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tkjos@google.com
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 Jun 2019 10:36:21 +0200
Message-ID: <15604149819585@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    binder: fix possible UAF when freeing buffer

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a370003cc301d4361bae20c9ef615f89bf8d1e8a Mon Sep 17 00:00:00 2001
From: Todd Kjos <tkjos@android.com>
Date: Wed, 12 Jun 2019 13:29:27 -0700
Subject: binder: fix possible UAF when freeing buffer

There is a race between the binder driver cleaning
up a completed transaction via binder_free_transaction()
and a user calling binder_ioctl(BC_FREE_BUFFER) to
release a buffer. It doesn't matter which is first but
they need to be protected against running concurrently
which can result in a UAF.

Signed-off-by: Todd Kjos <tkjos@google.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 748ac489ef7e..bc26b5511f0a 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -1941,8 +1941,18 @@ static void binder_free_txn_fixups(struct binder_transaction *t)
 
 static void binder_free_transaction(struct binder_transaction *t)
 {
-	if (t->buffer)
-		t->buffer->transaction = NULL;
+	struct binder_proc *target_proc = t->to_proc;
+
+	if (target_proc) {
+		binder_inner_proc_lock(target_proc);
+		if (t->buffer)
+			t->buffer->transaction = NULL;
+		binder_inner_proc_unlock(target_proc);
+	}
+	/*
+	 * If the transaction has no target_proc, then
+	 * t->buffer->transaction has already been cleared.
+	 */
 	binder_free_txn_fixups(t);
 	kfree(t);
 	binder_stats_deleted(BINDER_STAT_TRANSACTION);
@@ -3551,10 +3561,12 @@ static void binder_transaction(struct binder_proc *proc,
 static void
 binder_free_buf(struct binder_proc *proc, struct binder_buffer *buffer)
 {
+	binder_inner_proc_lock(proc);
 	if (buffer->transaction) {
 		buffer->transaction->buffer = NULL;
 		buffer->transaction = NULL;
 	}
+	binder_inner_proc_unlock(proc);
 	if (buffer->async_transaction && buffer->target_node) {
 		struct binder_node *buf_node;
 		struct binder_work *w;
-- 
2.22.0


