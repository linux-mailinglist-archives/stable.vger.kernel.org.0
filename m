Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE554300D1D
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 21:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730770AbhAVT6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 14:58:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:34630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728281AbhAVOOF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:14:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA0CD23AFC;
        Fri, 22 Jan 2021 14:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324675;
        bh=fV0iDRVrMGtQYDtd/ql9LA/wBJZHRY4wKgd9k3vp0dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bh20kNRUT8bo220S9zjALPo1BpIkRuKwuVASRZLYw8ogkLIZjvOLbPIdfTGUhfRMx
         gp4UCap+EFP7Qxs5WPtvp+fbRdD7nkDv9lHoanAzmaRsrrNfByzVGrOTDdcq3CZ1At
         rvSGNdYvYPtQwmtq0O+M3fpDeKoVmfSstn2BLg7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        stable@kernel.org
Subject: [PATCH 4.9 03/35] MIPS: Fix malformed NT_FILE and NT_SIGINFO in 32bit coredumps
Date:   Fri, 22 Jan 2021 15:10:05 +0100
Message-Id: <20210122135732.489413612@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135732.357969201@linuxfoundation.org>
References: <20210122135732.357969201@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 698222457465ce343443be81c5512edda86e5914 upstream.

Patches that introduced NT_FILE and NT_SIGINFO notes back in 2012
had taken care of native (fs/binfmt_elf.c) and compat (fs/compat_binfmt_elf.c)
coredumps; unfortunately, compat on mips (which does not go through the
usual compat_binfmt_elf.c) had not been noticed.

As the result, both N32 and O32 coredumps on 64bit mips kernels
have those sections malformed enough to confuse the living hell out of
all gdb and readelf versions (up to and including the tip of binutils-gdb.git).

Longer term solution is to make both O32 and N32 compat use the
regular compat_binfmt_elf.c, but that's too much for backports.  The minimal
solution is to do in arch/mips/kernel/binfmt_elf[on]32.c the same thing
those patches have done in fs/compat_binfmt_elf.c

Cc: stable@kernel.org # v3.7+
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/binfmt_elfn32.c |    7 +++++++
 arch/mips/kernel/binfmt_elfo32.c |    7 +++++++
 2 files changed, 14 insertions(+)

--- a/arch/mips/kernel/binfmt_elfn32.c
+++ b/arch/mips/kernel/binfmt_elfn32.c
@@ -110,4 +110,11 @@ cputime_to_compat_timeval(const cputime_
 	value->tv_sec = jiffies / HZ;
 }
 
+/*
+ * Some data types as stored in coredump.
+ */
+#define user_long_t             compat_long_t
+#define user_siginfo_t          compat_siginfo_t
+#define copy_siginfo_to_external        copy_siginfo_to_external32
+
 #include "../../../fs/binfmt_elf.c"
--- a/arch/mips/kernel/binfmt_elfo32.c
+++ b/arch/mips/kernel/binfmt_elfo32.c
@@ -113,4 +113,11 @@ cputime_to_compat_timeval(const cputime_
 	value->tv_sec = jiffies / HZ;
 }
 
+/*
+ * Some data types as stored in coredump.
+ */
+#define user_long_t             compat_long_t
+#define user_siginfo_t          compat_siginfo_t
+#define copy_siginfo_to_external        copy_siginfo_to_external32
+
 #include "../../../fs/binfmt_elf.c"


