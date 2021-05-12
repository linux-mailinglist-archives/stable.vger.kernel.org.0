Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A96037D26F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346760AbhELSJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:09:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352565AbhELSDe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:03:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 211A661433;
        Wed, 12 May 2021 18:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842545;
        bh=L1TraLPJIGnK4pTDFEezIQ9FbUehOUnWLcqyWq2g0cA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGGKZbW+WihAZx+x0eKK6rnEJfkRAKtK5Hsv9Al95Y118qirXDdaKOvBjfUwjGAie
         OJFIWPFcTDqnpsOTbN3exHqWVhkoVdWQxY/I1RBj9ZqgAX3dTXNl4EG3Nl8H6dYCxF
         +B6cC/D8J1VIIYS00TAbrX0AztTueYZzX3GM+9zZhX3NCs88qx3cZvP4T/WfuzhDv5
         wS8Ooi10S0cxosNOHveEsyHwoPS0ELz11cmrfnSO0MzviB6wiNB2wgN4+OmlqTiTu9
         bXqLXhKQ3bFo/ycJIhfsZdLWFrl/9IGiaJOVRTDHCuNeBRKx0GRQSElmX8tO1HLrwG
         8+V3MVL7o4i7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Ritesh Raj Sarraf <rrs@debian.org>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>, linux-um@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 12/35] um: Mark all kernel symbols as local
Date:   Wed, 12 May 2021 14:01:42 -0400
Message-Id: <20210512180206.664536-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180206.664536-1-sashal@kernel.org>
References: <20210512180206.664536-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit d5027ca63e0e778b641cf23e3f5c6d6212cf412b ]

Ritesh reported a bug [1] against UML, noting that it crashed on
startup. The backtrace shows the following (heavily redacted):

(gdb) bt
...
 #26 0x0000000060015b5d in sem_init () at ipc/sem.c:268
 #27 0x00007f89906d92f7 in ?? () from /lib/x86_64-linux-gnu/libcom_err.so.2
 #28 0x00007f8990ab8fb2 in call_init (...) at dl-init.c:72
...
 #40 0x00007f89909bf3a6 in nss_load_library (...) at nsswitch.c:359
...
 #44 0x00007f8990895e35 in _nss_compat_getgrnam_r (...) at nss_compat/compat-grp.c:486
 #45 0x00007f8990968b85 in __getgrnam_r [...]
 #46 0x00007f89909d6b77 in grantpt [...]
 #47 0x00007f8990a9394e in __GI_openpty [...]
 #48 0x00000000604a1f65 in openpty_cb (...) at arch/um/os-Linux/sigio.c:407
 #49 0x00000000604a58d0 in start_idle_thread (...) at arch/um/os-Linux/skas/process.c:598
 #50 0x0000000060004a3d in start_uml () at arch/um/kernel/skas/process.c:45
 #51 0x00000000600047b2 in linux_main (...) at arch/um/kernel/um_arch.c:334
 #52 0x000000006000574f in main (...) at arch/um/os-Linux/main.c:144

indicating that the UML function openpty_cb() calls openpty(),
which internally calls __getgrnam_r(), which causes the nsswitch
machinery to get started.

This loads, through lots of indirection that I snipped, the
libcom_err.so.2 library, which (in an unknown function, "??")
calls sem_init().

Now, of course it wants to get libpthread's sem_init(), since
it's linked against libpthread. However, the dynamic linker
looks up that symbol against the binary first, and gets the
kernel's sem_init().

Hajime Tazaki noted that "objcopy -L" can localize a symbol,
so the dynamic linker wouldn't do the lookup this way. I tried,
but for some reason that didn't seem to work.

Doing the same thing in the linker script instead does seem to
work, though I cannot entirely explain - it *also* works if I
just add "VERSION { { global: *; }; }" instead, indicating that
something else is happening that I don't really understand. It
may be that explicitly doing that marks them with some kind of
empty version, and that's different from the default.

Explicitly marking them with a version breaks kallsyms, so that
doesn't seem to be possible.

Marking all the symbols as local seems correct, and does seem
to address the issue, so do that. Also do it for static link,
nsswitch libraries could still be loaded there.

[1] https://bugs.debian.org/983379

Reported-by: Ritesh Raj Sarraf <rrs@debian.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Tested-By: Ritesh Raj Sarraf <rrs@debian.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/dyn.lds.S | 6 ++++++
 arch/um/kernel/uml.lds.S | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/um/kernel/dyn.lds.S b/arch/um/kernel/dyn.lds.S
index dacbfabf66d8..2f2a8ce92f1e 100644
--- a/arch/um/kernel/dyn.lds.S
+++ b/arch/um/kernel/dyn.lds.S
@@ -6,6 +6,12 @@ OUTPUT_ARCH(ELF_ARCH)
 ENTRY(_start)
 jiffies = jiffies_64;
 
+VERSION {
+  {
+    local: *;
+  };
+}
+
 SECTIONS
 {
   PROVIDE (__executable_start = START);
diff --git a/arch/um/kernel/uml.lds.S b/arch/um/kernel/uml.lds.S
index 45d957d7004c..7a8e2b123e29 100644
--- a/arch/um/kernel/uml.lds.S
+++ b/arch/um/kernel/uml.lds.S
@@ -7,6 +7,12 @@ OUTPUT_ARCH(ELF_ARCH)
 ENTRY(_start)
 jiffies = jiffies_64;
 
+VERSION {
+  {
+    local: *;
+  };
+}
+
 SECTIONS
 {
   /* This must contain the right address - not quite the default ELF one.*/
-- 
2.30.2

