Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378F64388A3
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 13:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhJXLkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 07:40:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229867AbhJXLkA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Oct 2021 07:40:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAAE660D43;
        Sun, 24 Oct 2021 11:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635075460;
        bh=xyPGrsI0EUgHTgDgIw9fHUseaHjWeumEeZ2wzM8NPXM=;
        h=Subject:To:Cc:From:Date:From;
        b=NYiglEKMHXFJE6Deq37LvFpzFHD6iyQgbWf4wXUNHKUZSdUOrpcShKd9S4rQ7eVmf
         0iVUBH0FRPIqbyL8t2W+JYSASd2eDsOPRmMHM0J43ScBvieNmh4L/Pfsn0NwPq1ObR
         D9p7LAx0/B4cL06ieHKHBgpCB9VGMRNgkYNSmrIU=
Subject: FAILED: patch "[PATCH] ucounts: Move get_ucounts from cred_alloc_blank to" failed to apply to 5.10-stable tree
To:     ebiederm@xmission.com, legion@kernel.org, yuzhao@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Oct 2021 13:37:37 +0200
Message-ID: <1635075457230115@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5ebcbe342b1c12fae44b4f83cbeae1520e09857e Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sat, 16 Oct 2021 12:17:30 -0500
Subject: [PATCH] ucounts: Move get_ucounts from cred_alloc_blank to
 key_change_session_keyring

Setting cred->ucounts in cred_alloc_blank does not make sense.  The
uid and user_ns are deliberately not set in cred_alloc_blank but
instead the setting is delayed until key_change_session_keyring.

So move dealing with ucounts into key_change_session_keyring as well.

Unfortunately that movement of get_ucounts adds a new failure mode to
key_change_session_keyring.  I do not see anything stopping the parent
process from calling setuid and changing the relevant part of it's
cred while keyctl_session_to_parent is running making it fundamentally
necessary to call get_ucounts in key_change_session_keyring.  Which
means that the new failure mode cannot be avoided.

A failure of key_change_session_keyring results in a single threaded
parent keeping it's existing credentials.  Which results in the parent
process not being able to access the session keyring and whichever
keys are in the new keyring.

Further get_ucounts is only expected to fail if the number of bits in
the refernece count for the structure is too few.

Since the code has no other way to report the failure of get_ucounts
and because such failures are not expected to be common add a WARN_ONCE
to report this problem to userspace.

Between the WARN_ONCE and the parent process not having access to
the keys in the new session keyring I expect any failure of get_ucounts
will be noticed and reported and we can find another way to handle this
condition.  (Possibly by just making ucounts->count an atomic_long_t).

Cc: stable@vger.kernel.org
Fixes: 905ae01c4ae2 ("Add a reference to ucounts for each cred")
Link: https://lkml.kernel.org/r/7k0ias0uf.fsf_-_@disp2133
Tested-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Alexey Gladkov <legion@kernel.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

diff --git a/kernel/cred.c b/kernel/cred.c
index 16c05dfbec4d..1ae0b4948a5a 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -225,8 +225,6 @@ struct cred *cred_alloc_blank(void)
 #ifdef CONFIG_DEBUG_CREDENTIALS
 	new->magic = CRED_MAGIC;
 #endif
-	new->ucounts = get_ucounts(&init_ucounts);
-
 	if (security_cred_alloc_blank(new, GFP_KERNEL_ACCOUNT) < 0)
 		goto error;
 
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index e3d79a7b6db6..b5d5333ab330 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -918,6 +918,13 @@ void key_change_session_keyring(struct callback_head *twork)
 		return;
 	}
 
+	/* If get_ucounts fails more bits are needed in the refcount */
+	if (unlikely(!get_ucounts(old->ucounts))) {
+		WARN_ONCE(1, "In %s get_ucounts failed\n", __func__);
+		put_cred(new);
+		return;
+	}
+
 	new->  uid	= old->  uid;
 	new-> euid	= old-> euid;
 	new-> suid	= old-> suid;
@@ -927,6 +934,7 @@ void key_change_session_keyring(struct callback_head *twork)
 	new-> sgid	= old-> sgid;
 	new->fsgid	= old->fsgid;
 	new->user	= get_uid(old->user);
+	new->ucounts	= old->ucounts;
 	new->user_ns	= get_user_ns(old->user_ns);
 	new->group_info	= get_group_info(old->group_info);
 

