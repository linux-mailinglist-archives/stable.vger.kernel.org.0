Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7552A590D
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730370AbgKCVza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:55:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:60770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730232AbgKCUo5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:44:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21AFA223EA;
        Tue,  3 Nov 2020 20:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436296;
        bh=xbDqOnu8uDwXWOmwTuYpPulpJ/NRJZMzLdeTlQsCZV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tnP4fhyGepdmq5wp6YFg8TzhybJWnkrqjTM8diT5DhpKRQjn1CFfvc67E28y1afIO
         XFOhrPQ5hgyXoJP63/3c5GsEx7NxlIOhTMAuqQRQfm1AaAeSjbzjGDFVFIMotC8a9g
         MdJ2OqaQAZKtPhYJP73Y2pWSIAF+6ULyBzBpOHq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tycho Andersen <tycho@tycho.pizza>,
        Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.9 189/391] seccomp: Make duplicate listener detection non-racy
Date:   Tue,  3 Nov 2020 21:34:00 +0100
Message-Id: <20201103203359.642648225@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit dfe719fef03d752f1682fa8aeddf30ba501c8555 upstream.

Currently, init_listener() tries to prevent adding a filter with
SECCOMP_FILTER_FLAG_NEW_LISTENER if one of the existing filters already
has a listener. However, this check happens without holding any lock that
would prevent another thread from concurrently installing a new filter
(potentially with a listener) on top of the ones we already have.

Theoretically, this is also a data race: The plain load from
current->seccomp.filter can race with concurrent writes to the same
location.

Fix it by moving the check into the region that holds the siglock to guard
against concurrent TSYNC.

(The "Fixes" tag points to the commit that introduced the theoretical
data race; concurrent installation of another filter with TSYNC only
became possible later, in commit 51891498f2da ("seccomp: allow TSYNC and
USER_NOTIF together").)

Fixes: 6a21cc50f0c7 ("seccomp: add a return code to trap to userspace")
Reviewed-by: Tycho Andersen <tycho@tycho.pizza>
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201005014401.490175-1-jannh@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/seccomp.c |   38 +++++++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 7 deletions(-)

--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -1472,13 +1472,7 @@ static const struct file_operations secc
 
 static struct file *init_listener(struct seccomp_filter *filter)
 {
-	struct file *ret = ERR_PTR(-EBUSY);
-	struct seccomp_filter *cur;
-
-	for (cur = current->seccomp.filter; cur; cur = cur->prev) {
-		if (cur->notif)
-			goto out;
-	}
+	struct file *ret;
 
 	ret = ERR_PTR(-ENOMEM);
 	filter->notif = kzalloc(sizeof(*(filter->notif)), GFP_KERNEL);
@@ -1504,6 +1498,31 @@ out:
 	return ret;
 }
 
+/*
+ * Does @new_child have a listener while an ancestor also has a listener?
+ * If so, we'll want to reject this filter.
+ * This only has to be tested for the current process, even in the TSYNC case,
+ * because TSYNC installs @child with the same parent on all threads.
+ * Note that @new_child is not hooked up to its parent at this point yet, so
+ * we use current->seccomp.filter.
+ */
+static bool has_duplicate_listener(struct seccomp_filter *new_child)
+{
+	struct seccomp_filter *cur;
+
+	/* must be protected against concurrent TSYNC */
+	lockdep_assert_held(&current->sighand->siglock);
+
+	if (!new_child->notif)
+		return false;
+	for (cur = current->seccomp.filter; cur; cur = cur->prev) {
+		if (cur->notif)
+			return true;
+	}
+
+	return false;
+}
+
 /**
  * seccomp_set_mode_filter: internal function for setting seccomp filter
  * @flags:  flags to change filter behavior
@@ -1575,6 +1594,11 @@ static long seccomp_set_mode_filter(unsi
 	if (!seccomp_may_assign_mode(seccomp_mode))
 		goto out;
 
+	if (has_duplicate_listener(prepared)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	ret = seccomp_attach_filter(flags, prepared);
 	if (ret)
 		goto out;


