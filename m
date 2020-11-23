Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47ACE2C0790
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732640AbgKWMmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:42:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732556AbgKWMkx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:40:53 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C91D2076E;
        Mon, 23 Nov 2020 12:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135252;
        bh=64H2hiQ4enESAv9cU4VMaEvAEFea5P3rJu/9zIILp+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nl5mDVR6ZxhFSNzrD+obsWDWP0a44Ermzjj6kuqDrs8cRZRxFU8WwbDsmzEgCghsH
         pSiniE23jadB42yDcAZLebqNaQ4K+YYEBTpGgpx0IsyLMvfVgG47UTJ9MWg1I16dce
         ncxwpUY3gFtgNPmXG8pkpMi6UpJBZc7fU5aa94iA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Will Drewry <wad@chromium.org>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>
Subject: [PATCH 5.4 153/158] seccomp: Set PF_SUPERPRIV when checking capability
Date:   Mon, 23 Nov 2020 13:23:01 +0100
Message-Id: <20201123121827.314118849@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mickaël Salaün <mic@linux.microsoft.com>

commit fb14528e443646dd3fd02df4437fcf5265b66baa upstream.

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
Reviewed-by: Jann Horn <jannh@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20201030123849.770769-3-mic@digikod.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/seccomp.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -37,7 +37,7 @@
 #include <linux/filter.h>
 #include <linux/pid.h>
 #include <linux/ptrace.h>
-#include <linux/security.h>
+#include <linux/capability.h>
 #include <linux/tracehook.h>
 #include <linux/uaccess.h>
 #include <linux/anon_inodes.h>
@@ -453,8 +453,7 @@ static struct seccomp_filter *seccomp_pr
 	 * behavior of privileged children.
 	 */
 	if (!task_no_new_privs(current) &&
-	    security_capable(current_cred(), current_user_ns(),
-				     CAP_SYS_ADMIN, CAP_OPT_NOAUDIT) != 0)
+			!ns_capable_noaudit(current_user_ns(), CAP_SYS_ADMIN))
 		return ERR_PTR(-EACCES);
 
 	/* Allocate a new seccomp_filter */


