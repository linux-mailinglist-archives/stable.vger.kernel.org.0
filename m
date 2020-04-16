Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A585D1AC49E
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409628AbgDPOCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:02:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409617AbgDPOCQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:02:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF8432078B;
        Thu, 16 Apr 2020 14:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045736;
        bh=SJKfbcTMFH18rnumuVrFY/CSI7v7IEsH07v35ULM5S0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JSdVC1U/cRmqop0BQuBtPGQfjWabsp3TnC5AeLxDoczTvKT7reGU9VkWE9BKvqfUb
         I+jnrOJ7NtjjLh1yGvcUvb0fynUQUYgW9gNN255PRlct2dvZueBkgXr9j890uiwv4R
         /zqymyOdBvlRglL88AkxZ9xCL9qIGtdbf5HlD0Qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Jessica Yu <jeyu@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Ben Hutchings <benh@debian.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.6 228/254] kmod: make request_module() return an error when autoloading is disabled
Date:   Thu, 16 Apr 2020 15:25:17 +0200
Message-Id: <20200416131354.225618687@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit d7d27cfc5cf0766a26a8f56868c5ad5434735126 upstream.

Patch series "module autoloading fixes and cleanups", v5.

This series fixes a bug where request_module() was reporting success to
kernel code when module autoloading had been completely disabled via
'echo > /proc/sys/kernel/modprobe'.

It also addresses the issues raised on the original thread
(https://lkml.kernel.org/lkml/20200310223731.126894-1-ebiggers@kernel.org/T/#u)
bydocumenting the modprobe sysctl, adding a self-test for the empty path
case, and downgrading a user-reachable WARN_ONCE().

This patch (of 4):

It's long been possible to disable kernel module autoloading completely
(while still allowing manual module insertion) by setting
/proc/sys/kernel/modprobe to the empty string.

This can be preferable to setting it to a nonexistent file since it
avoids the overhead of an attempted execve(), avoids potential
deadlocks, and avoids the call to security_kernel_module_request() and
thus on SELinux-based systems eliminates the need to write SELinux rules
to dontaudit module_request.

However, when module autoloading is disabled in this way,
request_module() returns 0.  This is broken because callers expect 0 to
mean that the module was successfully loaded.

Apparently this was never noticed because this method of disabling
module autoloading isn't used much, and also most callers don't use the
return value of request_module() since it's always necessary to check
whether the module registered its functionality or not anyway.

But improperly returning 0 can indeed confuse a few callers, for example
get_fs_type() in fs/filesystems.c where it causes a WARNING to be hit:

	if (!fs && (request_module("fs-%.*s", len, name) == 0)) {
		fs = __get_fs_type(name, len);
		WARN_ONCE(!fs, "request_module fs-%.*s succeeded, but still no fs?\n", len, name);
	}

This is easily reproduced with:

	echo > /proc/sys/kernel/modprobe
	mount -t NONEXISTENT none /

It causes:

	request_module fs-NONEXISTENT succeeded, but still no fs?
	WARNING: CPU: 1 PID: 1106 at fs/filesystems.c:275 get_fs_type+0xd6/0xf0
	[...]

This should actually use pr_warn_once() rather than WARN_ONCE(), since
it's also user-reachable if userspace immediately unloads the module.
Regardless, request_module() should correctly return an error when it
fails.  So let's make it return -ENOENT, which matches the error when
the modprobe binary doesn't exist.

I've also sent patches to document and test this case.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Jessica Yu <jeyu@kernel.org>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeff Vander Stoep <jeffv@google.com>
Cc: Ben Hutchings <benh@debian.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200310223731.126894-1-ebiggers@kernel.org
Link: http://lkml.kernel.org/r/20200312202552.241885-1-ebiggers@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/kmod.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -120,7 +120,7 @@ out:
  * invoke it.
  *
  * If module auto-loading support is disabled then this function
- * becomes a no-operation.
+ * simply returns -ENOENT.
  */
 int __request_module(bool wait, const char *fmt, ...)
 {
@@ -137,7 +137,7 @@ int __request_module(bool wait, const ch
 	WARN_ON_ONCE(wait && current_is_async());
 
 	if (!modprobe_path[0])
-		return 0;
+		return -ENOENT;
 
 	va_start(args, fmt);
 	ret = vsnprintf(module_name, MODULE_NAME_LEN, fmt, args);


