Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA7538A9F3
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239087AbhETLIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:08:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239372AbhETLGA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:06:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 471B961D20;
        Thu, 20 May 2021 10:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505121;
        bh=lhAyt4GsbjPvQXECYIeDiAIOb0EAwoMaQv3alGmugzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t3a/R9dpMJL1K1HCEO94glcw3c0dlrPypOnViEc2hCZz0LdhOs79tYBfJtCP5qsyO
         4PFM+OO9oMZ3tz7R+VIDbAyRqgt1trTALE5FnG724W4+XLO7ojfRwhGJREB6yrEpqi
         Iof07TKPmhYiiOHeyaqpwe65QO6ml+zmfc4PLO9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ritesh Raj Sarraf <rrs@debian.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 233/240] um: Mark all kernel symbols as local
Date:   Thu, 20 May 2021 11:23:45 +0200
Message-Id: <20210520092116.520816626@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 4fdbcf958cd5..558e5258dfff 100644
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
index 1840f55ed042..f544b8c13c2e 100644
--- a/arch/um/kernel/uml.lds.S
+++ b/arch/um/kernel/uml.lds.S
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
   /* This must contain the right address - not quite the default ELF one.*/
-- 
2.30.2



