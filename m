Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7F7A180CAB
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 00:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbgCJX7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 19:59:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726899AbgCJX7v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 19:59:51 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C969321D56;
        Tue, 10 Mar 2020 23:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583884790;
        bh=TMdhroAJRZ9oswsPRaEANwLbztV9biiW6mC2xeCNGJA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hWFx1of7PoY+qvzVtZ1g8yIBDZdBXfOcr+vIMLLRloEyZIxBtDB2HWPUs8nu0bvWo
         mNkz84vGaepX+faCi3kstRx75DwCPPHbJRE9Ukr7mrVLcVpTEd5k5dshIT5fgQ4BPu
         LKuMsuWwrBfWVyEwE3MiQzxONOZ/hn2MsUe/gtVY=
Date:   Tue, 10 Mar 2020 16:59:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     ast@kernel.org, ebiggers@google.com, gregkh@linuxfoundation.org,
        jeffv@google.com, jeyu@kernel.org, keescook@chromium.org,
        mcgrof@kernel.org, mm-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject:  +
 kmod-make-request_module-return-an-error-when-autoloading-is-disabled.patch
 added to -mm tree
Message-ID: <20200310235949.Ms2NVumcd%akpm@linux-foundation.org>
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kmod: make request_module() return an error when autoloading is disabled
has been added to the -mm tree.  Its filename is
     kmod-make-request_module-return-an-error-when-autoloading-is-disabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kmod-make-request_module-return-an-error-when-autoloading-is-disabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kmod-make-request_module-return-an-error-when-autoloading-is-disabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: kmod: make request_module() return an error when autoloading is disabled

It's long been possible to disable kernel module autoloading completely by
setting /proc/sys/kernel/modprobe to the empty string.  This can be
preferable to setting it to a nonexistent file since it avoids the
overhead of an attempted execve(), avoids potential deadlocks, and avoids
the call to security_kernel_module_request() and thus on SELinux-based
systems eliminates the need to write SELinux rules to dontaudit
module_request.

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
		WARN_ONCE(!fs, "request_module fs-%.*s succeeded, but still no fs?
", len, name);
	}

This is easily reproduced with:

	echo > /proc/sys/kernel/modprobe
	mount -t NONEXISTENT none /

It causes:

	request_module fs-NONEXISTENT succeeded, but still no fs?
	WARNING: CPU: 1 PID: 1106 at fs/filesystems.c:275 get_fs_type+0xd6/0xf0
	[...]

Arguably this warning is broken and should be removed, since the module
could have been unloaded already.  However, request_module() should also
correctly return an error when it fails.  So let's make it return -ENOENT,
which matches the error when the modprobe binary doesn't exist.

Link: http://lkml.kernel.org/r/20200310223731.126894-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeff Vander Stoep <jeffv@google.com>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
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

kmod-make-request_module-return-an-error-when-autoloading-is-disabled.patch

