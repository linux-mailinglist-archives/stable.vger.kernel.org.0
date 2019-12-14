Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8608B11F0DA
	for <lists+stable@lfdr.de>; Sat, 14 Dec 2019 09:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbfLNIKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Dec 2019 03:10:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbfLNIKy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 14 Dec 2019 03:10:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15A8024656;
        Sat, 14 Dec 2019 08:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576311053;
        bh=ADa8El2Myo/GlZv7V5v5N3f5TmlzoeOFLu7hcyUeq6E=;
        h=Subject:To:From:Date:From;
        b=CNj5/hiJQswZ9F0ma07tATSS5pIyo3Yqvn+vmPOhSIe4NqlPyRfx0S2CP8tUY9350
         bOyqs+ZVYt7NJHs09mpQJdpp8rkr3R31bS9Q3OQMGZtF+fwWyt1C8Y3NQ3MVSy+AVo
         bRgXVHh8MImUCMPf6dHWEtA4E8GTHnshG18iRHAE=
Subject: patch "binder: fix incorrect calculation for num_valid" added to char-misc-linus
To:     tkjos@android.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tkjos@google.com
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 14 Dec 2019 09:10:50 +0100
Message-ID: <157631105050246@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    binder: fix incorrect calculation for num_valid

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 16981742717b04644a41052570fb502682a315d2 Mon Sep 17 00:00:00 2001
From: Todd Kjos <tkjos@android.com>
Date: Fri, 13 Dec 2019 12:25:31 -0800
Subject: binder: fix incorrect calculation for num_valid

For BINDER_TYPE_PTR and BINDER_TYPE_FDA transactions, the
num_valid local was calculated incorrectly causing the
range check in binder_validate_ptr() to miss out-of-bounds
offsets.

Fixes: bde4a19fc04f ("binder: use userspace pointer as base of buffer space")
Signed-off-by: Todd Kjos <tkjos@google.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191213202531.55010-1-tkjos@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index e9bc9fcc7ea5..b2dad43dbf82 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -3310,7 +3310,7 @@ static void binder_transaction(struct binder_proc *proc,
 			binder_size_t parent_offset;
 			struct binder_fd_array_object *fda =
 				to_binder_fd_array_object(hdr);
-			size_t num_valid = (buffer_offset - off_start_offset) *
+			size_t num_valid = (buffer_offset - off_start_offset) /
 						sizeof(binder_size_t);
 			struct binder_buffer_object *parent =
 				binder_validate_ptr(target_proc, t->buffer,
@@ -3384,7 +3384,7 @@ static void binder_transaction(struct binder_proc *proc,
 				t->buffer->user_data + sg_buf_offset;
 			sg_buf_offset += ALIGN(bp->length, sizeof(u64));
 
-			num_valid = (buffer_offset - off_start_offset) *
+			num_valid = (buffer_offset - off_start_offset) /
 					sizeof(binder_size_t);
 			ret = binder_fixup_parent(t, thread, bp,
 						  off_start_offset,
-- 
2.24.1


