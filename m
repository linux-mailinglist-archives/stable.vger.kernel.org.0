Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAE21F2AC
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbfEOLJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:09:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729205AbfEOLJL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:09:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00F0820644;
        Wed, 15 May 2019 11:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918550;
        bh=fDb8Pd2ekjLHk9Ji1vb+hzOw5NNcIKC2Kac4G6EHDN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PO/1Ldm0CrVFTvGUuKOqdwG/IX7F2NKEvKVVP/q5gtMnZLIHaowqcV14YMUfTB1Zi
         6mr356aeyX/elWJKqy/dcSsBxMSYVLDRFBCzHLjcsjOYxNYx/FSggl+2VrtmsMZdIa
         HWhS3fofJDi47YrZ3q+jselBziM/fbfOjv4VCrBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Weimer <fweimer@redhat.com>,
        Carlos ODonell <carlos@redhat.com>,
        "H. J. Lu" <hjl.tools@gmail.com>,
        Alistair Strachan <astrachan@google.com>,
        Borislav Petkov <bp@suse.de>,
        Laura Abbott <labbott@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        kernel-team@android.com, Thomas Gleixner <tglx@linutronix.de>,
        X86 ML <x86@kernel.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.4 176/266] x86/vdso: Pass --eh-frame-hdr to the linker
Date:   Wed, 15 May 2019 12:54:43 +0200
Message-Id: <20190515090728.876646676@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/vdso/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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


