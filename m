Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5B3B1858D9
	for <lists+stable@lfdr.de>; Sun, 15 Mar 2020 03:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgCOCYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Mar 2020 22:24:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727944AbgCOCYP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 14 Mar 2020 22:24:15 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B195B20838;
        Sat, 14 Mar 2020 21:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584221808;
        bh=UWIFamZriIq7pwiuAN2fl1MmSck4XAGVejYX5mG6Jxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AvTfc8sqkulB3uIPpZNdObWRiomad5SEfy3ynWmovFPeS/Yd49cABntT1I+dx0iWB
         aPFND4R8F+u8hEYJubREDBRDtRB7r9yGPwLvDMDglKzQmLAOfGYjUkQoJ2PqJk/LUk
         EDuobPpXenbOaz0CDl5diR9aXB9dGh2PpxTFlzTw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Jessica Yu <jeyu@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        NeilBrown <neilb@suse.com>, stable@vger.kernel.org
Subject: [PATCH v3 1/5] kmod: make request_module() return an error when autoloading is disabled
Date:   Sat, 14 Mar 2020 14:34:22 -0700
Message-Id: <20200314213426.134866-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200314213426.134866-1-ebiggers@kernel.org>
References: <20200314213426.134866-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

It's long been possible to disable kernel module autoloading completely
(while still allowing manual module insertion) by setting
/proc/sys/kernel/modprobe to the empty string.  This can be preferable
to setting it to a nonexistent file since it avoids the overhead of an
attempted execve(), avoids potential deadlocks, and avoids the call to
security_kernel_module_request() and thus on SELinux-based systems
eliminates the need to write SELinux rules to dontaudit module_request.

However, when module autoloading is disabled in this way,
request_module() returns 0.  This is broken because callers expect 0 to
mean that the module was successfully loaded.

Apparently this was never noticed because this method of disabling
module autoloading isn't used much, and also most callers don't use the
return value of request_module() since it's always necessary to check
whether the module registered its functionality or not anyway.  But
improperly returning 0 can indeed confuse a few callers, for example
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

Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: stable@vger.kernel.org
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeff Vander Stoep <jeffv@google.com>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: NeilBrown <neilb@suse.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 kernel/kmod.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index bc6addd9152b4..a2de58de6ab62 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -120,7 +120,7 @@ static int call_modprobe(char *module_name, int wait)
  * invoke it.
  *
  * If module auto-loading support is disabled then this function
- * becomes a no-operation.
+ * simply returns -ENOENT.
  */
 int __request_module(bool wait, const char *fmt, ...)
 {
@@ -137,7 +137,7 @@ int __request_module(bool wait, const char *fmt, ...)
 	WARN_ON_ONCE(wait && current_is_async());
 
 	if (!modprobe_path[0])
-		return 0;
+		return -ENOENT;
 
 	va_start(args, fmt);
 	ret = vsnprintf(module_name, MODULE_NAME_LEN, fmt, args);
-- 
2.25.1

