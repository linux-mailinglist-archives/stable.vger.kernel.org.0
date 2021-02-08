Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BACEE3137A6
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbhBHP2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:28:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:35678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233483AbhBHPYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:24:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF8AE64F27;
        Mon,  8 Feb 2021 15:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797300;
        bh=xXJ5/yDK5HzwY3DJB0kbYLLWEuIm1TU9GLMSZYKPr2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zsI2G+ALfwRPWUpY9rpl45sNZPyCVeCNWt512AsYZZveHNLXNVIaXholu4IaUhWJG
         5nNfLhd7moIntfpvLu1wOjlIYggXH8gwiLRRwOHo9yEBtI5QI3+q2PVPG2xXYNZqfY
         /PS2R6imxjgZ0sk4IX5jifJ9vgpXUx4/4c2jgP1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Gow <davidgow@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/120] bpf, preload: Fix build when $(O) points to a relative path
Date:   Mon,  8 Feb 2021 16:00:17 +0100
Message-Id: <20210208145819.587284870@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Monnet <quentin@isovalent.com>

[ Upstream commit 150a27328b681425c8cab239894a48f2aeb870e9 ]

Building the kernel with CONFIG_BPF_PRELOAD, and by providing a relative
path for the output directory, may fail with the following error:

  $ make O=build bindeb-pkg
  ...
  /.../linux/tools/scripts/Makefile.include:5: *** O=build does not exist.  Stop.
  make[7]: *** [/.../linux/kernel/bpf/preload/Makefile:9: kernel/bpf/preload/libbpf.a] Error 2
  make[6]: *** [/.../linux/scripts/Makefile.build:500: kernel/bpf/preload] Error 2
  make[5]: *** [/.../linux/scripts/Makefile.build:500: kernel/bpf] Error 2
  make[4]: *** [/.../linux/Makefile:1799: kernel] Error 2
  make[4]: *** Waiting for unfinished jobs....

In the case above, for the "bindeb-pkg" target, the error is produced by
the "dummy" check in Makefile.include, called from libbpf's Makefile.
This check changes directory to $(PWD) before checking for the existence
of $(O). But at this step we have $(PWD) pointing to "/.../linux/build",
and $(O) pointing to "build". So the Makefile.include tries in fact to
assert the existence of a directory named "/.../linux/build/build",
which does not exist.

Note that the error does not occur for all make targets and
architectures combinations. This was observed on x86 for "bindeb-pkg",
or for a regular build for UML [0].

Here are some details. The root Makefile recursively calls itself once,
after changing directory to $(O). The content for the variable $(PWD) is
preserved across recursive calls to make, so it is unchanged at this
step. For "bindeb-pkg", $(PWD) is eventually updated because the target
writes a new Makefile (as debian/rules) and calls it indirectly through
dpkg-buildpackage. This script does not preserve $(PWD), which is reset
to the current working directory when the target in debian/rules is
called.

Although not investigated, it seems likely that something similar causes
UML to change its value for $(PWD).

Non-trivial fixes could be to remove the use of $(PWD) from the "dummy"
check, or to make sure that $(PWD) and $(O) are preserved or updated to
always play well and form a valid $(PWD)/$(O) path across the different
targets and architectures. Instead, we take a simpler approach and just
update $(O) when calling libbpf's Makefile, so it points to an absolute
path which should always resolve for the "dummy" check run (through
includes) by that Makefile.

David Gow previously posted a slightly different version of this patch
as a RFC [0], two months ago or so.

  [0] https://lore.kernel.org/bpf/20201119085022.3606135-1-davidgow@google.com/t/#u

Fixes: d71fa5c9763c ("bpf: Add kernel module with user mode driver that populates bpffs.")
Reported-by: David Gow <davidgow@google.com>
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/bpf/20210126161320.24561-1-quentin@isovalent.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/preload/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/preload/Makefile b/kernel/bpf/preload/Makefile
index 23ee310b6eb49..1951332dd15f5 100644
--- a/kernel/bpf/preload/Makefile
+++ b/kernel/bpf/preload/Makefile
@@ -4,8 +4,11 @@ LIBBPF_SRCS = $(srctree)/tools/lib/bpf/
 LIBBPF_A = $(obj)/libbpf.a
 LIBBPF_OUT = $(abspath $(obj))
 
+# Although not in use by libbpf's Makefile, set $(O) so that the "dummy" test
+# in tools/scripts/Makefile.include always succeeds when building the kernel
+# with $(O) pointing to a relative path, as in "make O=build bindeb-pkg".
 $(LIBBPF_A):
-	$(Q)$(MAKE) -C $(LIBBPF_SRCS) OUTPUT=$(LIBBPF_OUT)/ $(LIBBPF_OUT)/libbpf.a
+	$(Q)$(MAKE) -C $(LIBBPF_SRCS) O=$(LIBBPF_OUT)/ OUTPUT=$(LIBBPF_OUT)/ $(LIBBPF_OUT)/libbpf.a
 
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi \
 	-I $(srctree)/tools/lib/ -Wno-unused-result
-- 
2.27.0



