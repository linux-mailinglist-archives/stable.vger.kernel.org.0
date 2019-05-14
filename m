Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30F991C3DA
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 09:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbfENHfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 03:35:23 -0400
Received: from mo-csw1116.securemx.jp ([210.130.202.158]:38482 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfENHfX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 03:35:23 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id x4E7Yj7B010201; Tue, 14 May 2019 16:34:45 +0900
X-Iguazu-Qid: 2wHHEpXClbsTjtms6d
X-Iguazu-QSIG: v=2; s=0; t=1557819284; q=2wHHEpXClbsTjtms6d; m=F82ggJGZLfRaicC9CZfHMd4t9YzOSScwG0DHWN4fYsg=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1110) id x4E7Yg4r035359;
        Tue, 14 May 2019 16:34:42 +0900
Received: from enc01.localdomain ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id x4E7YggH022162;
        Tue, 14 May 2019 16:34:42 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.localdomain  with ESMTP id x4E7YfD0013109;
        Tue, 14 May 2019 16:34:41 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Alistair Strachan <astrachan@google.com>,
        Florian Weimer <fweimer@redhat.com>,
        "Carlos O'Donell" <carlos@redhat.com>,
        "H. J. Lu" <hjl.tools@gmail.com>, Borislav Petkov <bp@suse.de>,
        Laura Abbott <labbott@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        kernel-team@android.com, stable <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 4.4, 4.9 and 4.14] x86/vdso: Pass --eh-frame-hdr to the linker
Date:   Tue, 14 May 2019 16:34:29 +0900
X-TSB-HOP: ON
Message-Id: <20190514073429.17537-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alistair Strachan <astrachan@google.com>

commit cd01544a268ad8ee5b1dfe42c4393f1095f86879 upstream.

Commit

  379d98ddf413 ("x86: vdso: Use $LD instead of $CC to link")

accidentally broke unwinding from userspace, because ld would strip the
.eh_frame sections when linking.

Originally, the compiler would implicitly add --eh-frame-hdr when
invoking the linker, but when this Makefile was converted from invoking
ld via the compiler, to invoking it directly (like vmlinux does),
the flag was missed. (The EH_FRAME section is important for the VDSO
shared libraries, but not for vmlinux.)

Fix the problem by explicitly specifying --eh-frame-hdr, which restores
parity with the old method.

See relevant bug reports for additional info:

  https://bugzilla.kernel.org/show_bug.cgi?id=201741
  https://bugzilla.redhat.com/show_bug.cgi?id=1659295

Fixes: 379d98ddf413 ("x86: vdso: Use $LD instead of $CC to link")
Reported-by: Florian Weimer <fweimer@redhat.com>
Reported-by: Carlos O'Donell <carlos@redhat.com>
Reported-by: "H. J. Lu" <hjl.tools@gmail.com>
Signed-off-by: Alistair Strachan <astrachan@google.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Laura Abbott <labbott@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Carlos O'Donell <carlos@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: kernel-team@android.com
Cc: Laura Abbott <labbott@redhat.com>
Cc: stable <stable@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: X86 ML <x86@kernel.org>
Link: https://lkml.kernel.org/r/20181214223637.35954-1-astrachan@google.com
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 arch/x86/entry/vdso/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index 297dda4d5947..15ed35f5097d 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -159,7 +159,8 @@ quiet_cmd_vdso = VDSO    $@
 		 sh $(srctree)/$(src)/checkundef.sh '$(NM)' '$@'
 
 VDSO_LDFLAGS = -shared $(call ld-option, --hash-style=both) \
-	$(call ld-option, --build-id) -Bsymbolic
+	$(call ld-option, --build-id) $(call ld-option, --eh-frame-hdr) \
+	-Bsymbolic
 GCOV_PROFILE := n
 
 #
-- 
2.20.1

