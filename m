Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0837A2FA9E7
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393862AbhARTQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:16:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:33392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390492AbhARLip (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 599D322C9D;
        Mon, 18 Jan 2021 11:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969898;
        bh=2d8XLJyeVqtVYPdC/bPae7b3PqNyeOChjaTrNNDogZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYFTqv3sjMtq6kdQ4iNizyNF2QjOdYQu8EdC3lPt0eOTHyH0cgx3RQjzIIxlDhxAZ
         wrE5y8q6yeemCjnxjgAx493dj7EROq/r6Ak5LuJRjVmUtGSVZ+De3TyHDRbE0gW8IM
         rBXh1Q/s1fUHeeLpne2AA2UQfwpHTLAa3u4lZVDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        stable@kernel.org
Subject: [PATCH 5.4 09/76] MIPS: Fix malformed NT_FILE and NT_SIGINFO in 32bit coredumps
Date:   Mon, 18 Jan 2021 12:34:09 +0100
Message-Id: <20210118113341.433027287@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
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
@@ -103,4 +103,11 @@ jiffies_to_old_timeval32(unsigned long j
 #undef ns_to_timeval
 #define ns_to_timeval ns_to_old_timeval32
 
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
@@ -106,4 +106,11 @@ jiffies_to_old_timeval32(unsigned long j
 #undef ns_to_timeval
 #define ns_to_timeval ns_to_old_timeval32
 
+/*
+ * Some data types as stored in coredump.
+ */
+#define user_long_t             compat_long_t
+#define user_siginfo_t          compat_siginfo_t
+#define copy_siginfo_to_external        copy_siginfo_to_external32
+
 #include "../../../fs/binfmt_elf.c"


