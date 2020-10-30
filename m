Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49C72A05B5
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 13:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgJ3MrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 08:47:02 -0400
Received: from smtp-42ab.mail.infomaniak.ch ([84.16.66.171]:57937 "EHLO
        smtp-42ab.mail.infomaniak.ch" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725999AbgJ3MrB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 08:47:01 -0400
X-Greylist: delayed 479 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Oct 2020 08:47:00 EDT
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4CN21G6tpXzlhjYs;
        Fri, 30 Oct 2020 13:38:58 +0100 (CET)
Received: from localhost (unknown [94.23.54.103])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4CN21G5BxVzlh8TD;
        Fri, 30 Oct 2020 13:38:58 +0100 (CET)
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Eric Paris <eparis@redhat.com>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>
Subject: [PATCH v1 2/2] seccomp: Set PF_SUPERPRIV when checking capability
Date:   Fri, 30 Oct 2020 13:38:49 +0100
Message-Id: <20201030123849.770769-3-mic@digikod.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201030123849.770769-1-mic@digikod.net>
References: <20201030123849.770769-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mickaël Salaün <mic@linux.microsoft.com>

Replace the use of security_capable(current_cred(), ...) with
ns_capable_noaudit() which set PF_SUPERPRIV.

Since commit 98f368e9e263 ("kernel: Add noaudit variant of
ns_capable()"), a new ns_capable_noaudit() helper is available.  Let's
use it!

Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tyler Hicks <tyhicks@linux.microsoft.com>
Cc: Will Drewry <wad@chromium.org>
Cc: stable@vger.kernel.org
Fixes: e2cfabdfd075 ("seccomp: add system call filtering using BPF")
Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
---
 kernel/seccomp.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 8ad7a293255a..53a7d1512dd7 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -38,7 +38,7 @@
 #include <linux/filter.h>
 #include <linux/pid.h>
 #include <linux/ptrace.h>
-#include <linux/security.h>
+#include <linux/capability.h>
 #include <linux/tracehook.h>
 #include <linux/uaccess.h>
 #include <linux/anon_inodes.h>
@@ -558,8 +558,7 @@ static struct seccomp_filter *seccomp_prepare_filter(struct sock_fprog *fprog)
 	 * behavior of privileged children.
 	 */
 	if (!task_no_new_privs(current) &&
-	    security_capable(current_cred(), current_user_ns(),
-				     CAP_SYS_ADMIN, CAP_OPT_NOAUDIT) != 0)
+			!ns_capable_noaudit(current_user_ns(), CAP_SYS_ADMIN))
 		return ERR_PTR(-EACCES);
 
 	/* Allocate a new seccomp_filter */
-- 
2.28.0

