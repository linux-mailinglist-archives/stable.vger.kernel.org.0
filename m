Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 264871A5D10
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 08:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgDLGpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Apr 2020 02:45:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgDLGpj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 Apr 2020 02:45:39 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EE052070A;
        Sun, 12 Apr 2020 06:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586673938;
        bh=q3JJe3Ajosy+72KIMwQfaYGeJIjgunRu63lV7ntqSGU=;
        h=Date:From:To:Subject:From;
        b=gJDGsB4d8DxiPl5mu5j35dxpAYfhzsbUJXbFmOZhweMXnwzvUoK8fw+Xb79+3ujKy
         vsDE+C4JVNrjvXFY+3oPEutaJTdGv9P3EgPFbB6o2crmCx0zC0gGQC3sCNbE6l+LwX
         YylofI/r4U4ItDoM2nM5VH6pSd5KDew6kVy0PCDo=
Date:   Sat, 11 Apr 2020 23:45:37 -0700
From:   akpm@linux-foundation.org
To:     ast@kernel.org, benh@debian.org, ebiggers@google.com,
        gregkh@linuxfoundation.org, jeffv@google.com, jeyu@kernel.org,
        josh@joshtriplett.org, keescook@chromium.org, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  [merged]
 kmod-make-request_module-return-an-error-when-autoloading-is-disabled.patch
 removed from -mm tree
Message-ID: <20200412064537.g2j1XXAd_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kmod: make request_module() return an error when autoloading is disabled
has been removed from the -mm tree.  Its filename was
     kmod-make-request_module-return-an-error-when-autoloading-is-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: kmod: make request_module() return an error when autoloading is disabled

Patch series "module autoloading fixes and cleanups", v5.

This series fixes a bug where request_module() was reporting success to
kernel code when module autoloading had been completely disabled via 'echo
> /proc/sys/kernel/modprobe'.

It also addresses the issues raised on the original thread
(https://lkml.kernel.org/lkml/20200310223731.126894-1-ebiggers@kernel.org/T/#u)
by documenting the modprobe sysctl, adding a self-test for the empty path
case, and downgrading a user-reachable WARN_ONCE().


This patch (of 4):

It's long been possible to disable kernel module autoloading completely
(while still allowing manual module insertion) by setting
/proc/sys/kernel/modprobe to the empty string.  This can be preferable to
setting it to a nonexistent file since it avoids the overhead of an
attempted execve(), avoids potential deadlocks, and avoids the call to
security_kernel_module_request() and thus on SELinux-based systems
eliminates the need to write SELinux rules to dontaudit module_request.

However, when module autoloading is disabled in this way, request_module()
returns 0.  This is broken because callers expect 0 to mean that the
module was successfully loaded.

Apparently this was never noticed because this method of disabling module
autoloading isn't used much, and also most callers don't use the return
value of request_module() since it's always necessary to check whether the
module registered its functionality or not anyway.  But improperly
returning 0 can indeed confuse a few callers, for example get_fs_type() in
fs/filesystems.c where it causes a WARNING to be hit:

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
fails.  So let's make it return -ENOENT, which matches the error when the
modprobe binary doesn't exist.

I've also sent patches to document and test this case.

Link: http://lkml.kernel.org/r/20200310223731.126894-1-ebiggers@kernel.org
Link: http://lkml.kernel.org/r/20200312202552.241885-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Jessica Yu <jeyu@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeff Vander Stoep <jeffv@google.com>
Cc: Ben Hutchings <benh@debian.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/kmod.c~kmod-make-request_module-return-an-error-when-autoloading-is-disabled
+++ a/kernel/kmod.c
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
_

Patches currently in -mm which might be from ebiggers@google.com are


