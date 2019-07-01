Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5BE14F72
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfEFPKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 11:10:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbfEFOeJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:34:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2110E20C01;
        Mon,  6 May 2019 14:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153248;
        bh=C1jL5xd+iDU1mafVM9Qi8hHy+7kHs/6vpAvJf3AD2h0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OE3Egd00i5AwAOsIKHohaMaWt67kJVi8mvCmNGCRQ492PB3e6i/bHeAWqe1LGyJYf
         WYqR8y1tiYjAdyLX8lPu2qNYtfOlRAYSLt8RVHPZSfyz4NeA1qK4P/R5ZkiNpD7AU3
         csAQ1+ZfiNaMak7mPpbJRs12mgXmKLtSftYrwvqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b562969adb2e04af3442@syzkaller.appspotmail.com,
        Tycho Andersen <tycho@tycho.ws>,
        Kees Cook <keescook@chromium.org>,
        James Morris <jamorris@linux.microsoft.com>
Subject: [PATCH 5.0 002/122] seccomp: Make NEW_LISTENER and TSYNC flags exclusive
Date:   Mon,  6 May 2019 16:31:00 +0200
Message-Id: <20190506143054.928504763@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tycho Andersen <tycho@tycho.ws>

commit 7a0df7fbc14505e2e2be19ed08654a09e1ed5bf6 upstream.

As the comment notes, the return codes for TSYNC and NEW_LISTENER
conflict, because they both return positive values, one in the case of
success and one in the case of error. So, let's disallow both of these
flags together.

While this is technically a userspace break, all the users I know
of are still waiting on me to land this feature in libseccomp, so I
think it'll be safe. Also, at present my use case doesn't require
TSYNC at all, so this isn't a big deal to disallow. If someone
wanted to support this, a path forward would be to add a new flag like
TSYNC_AND_LISTENER_YES_I_UNDERSTAND_THAT_TSYNC_WILL_JUST_RETURN_EAGAIN,
but the use cases are so different I don't see it really happening.

Finally, it's worth noting that this does actually fix a UAF issue: at the
end of seccomp_set_mode_filter(), we have:

        if (flags & SECCOMP_FILTER_FLAG_NEW_LISTENER) {
                if (ret < 0) {
                        listener_f->private_data = NULL;
                        fput(listener_f);
                        put_unused_fd(listener);
                } else {
                        fd_install(listener, listener_f);
                        ret = listener;
                }
        }
out_free:
        seccomp_filter_free(prepared);

But if ret > 0 because TSYNC raced, we'll install the listener fd and then
free the filter out from underneath it, causing a UAF when the task closes
it or dies. This patch also switches the condition to be simply if (ret),
so that if someone does add the flag mentioned above, they won't have to
remember to fix this too.

Reported-by: syzbot+b562969adb2e04af3442@syzkaller.appspotmail.com
Fixes: 6a21cc50f0c7 ("seccomp: add a return code to trap to userspace")
CC: stable@vger.kernel.org # v5.0+
Signed-off-by: Tycho Andersen <tycho@tycho.ws>
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: James Morris <jamorris@linux.microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/seccomp.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -500,7 +500,10 @@ out:
  *
  * Caller must be holding current->sighand->siglock lock.
  *
- * Returns 0 on success, -ve on error.
+ * Returns 0 on success, -ve on error, or
+ *   - in TSYNC mode: the pid of a thread which was either not in the correct
+ *     seccomp mode or did not have an ancestral seccomp filter
+ *   - in NEW_LISTENER mode: the fd of the new listener
  */
 static long seccomp_attach_filter(unsigned int flags,
 				  struct seccomp_filter *filter)
@@ -1256,6 +1259,16 @@ static long seccomp_set_mode_filter(unsi
 	if (flags & ~SECCOMP_FILTER_FLAG_MASK)
 		return -EINVAL;
 
+	/*
+	 * In the successful case, NEW_LISTENER returns the new listener fd.
+	 * But in the failure case, TSYNC returns the thread that died. If you
+	 * combine these two flags, there's no way to tell whether something
+	 * succeeded or failed. So, let's disallow this combination.
+	 */
+	if ((flags & SECCOMP_FILTER_FLAG_TSYNC) &&
+	    (flags & SECCOMP_FILTER_FLAG_NEW_LISTENER))
+		return -EINVAL;
+
 	/* Prepare the new filter before holding any locks. */
 	prepared = seccomp_prepare_user_filter(filter);
 	if (IS_ERR(prepared))
@@ -1302,7 +1315,7 @@ out:
 		mutex_unlock(&current->signal->cred_guard_mutex);
 out_put_fd:
 	if (flags & SECCOMP_FILTER_FLAG_NEW_LISTENER) {
-		if (ret < 0) {
+		if (ret) {
 			listener_f->private_data = NULL;
 			fput(listener_f);
 			put_unused_fd(listener);


