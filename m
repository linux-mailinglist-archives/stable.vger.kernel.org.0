Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF5D5CB23
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbfGBIL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:11:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728654AbfGBIK1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:10:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB6792184B;
        Tue,  2 Jul 2019 08:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562055027;
        bh=FHZuVNPHrPEskjr4ytkC96O85qWn+vClIozAy1WdJBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sq23KUQZLGtbBD1etvUvfcTPmkzz6vNv4e7WpGmm0MXawGlkKDxvlIv9wUVthTERy
         tBwDrbpqYcFP8LfXGC92QuWEh7onEwIMR5jBOY3OsxfpokWOY/NiAgmUSuPCMx4KJ+
         DhCG1499HeMEc+sCkXDbm6REzQZyus+nCZOk+de0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>
Subject: [PATCH 4.14 42/43] futex: Update comments and docs about return values of arch futex code
Date:   Tue,  2 Jul 2019 10:02:22 +0200
Message-Id: <20190702080126.094515764@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080123.904399496@linuxfoundation.org>
References: <20190702080123.904399496@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit 427503519739e779c0db8afe876c1b33f3ac60ae upstream.

The architecture implementations of 'arch_futex_atomic_op_inuser()' and
'futex_atomic_cmpxchg_inatomic()' are permitted to return only -EFAULT,
-EAGAIN or -ENOSYS in the case of failure.

Update the comments in the asm-generic/ implementation and also a stray
reference in the robust futex documentation.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/robust-futexes.txt |    3 +--
 include/asm-generic/futex.h      |    8 ++++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/Documentation/robust-futexes.txt
+++ b/Documentation/robust-futexes.txt
@@ -218,5 +218,4 @@ All other architectures should build jus
 the new syscalls yet.
 
 Architectures need to implement the new futex_atomic_cmpxchg_inatomic()
-inline function before writing up the syscalls (that function returns
--ENOSYS right now).
+inline function before writing up the syscalls.
--- a/include/asm-generic/futex.h
+++ b/include/asm-generic/futex.h
@@ -23,7 +23,9 @@
  *
  * Return:
  * 0 - On success
- * <0 - On error
+ * -EFAULT - User access resulted in a page fault
+ * -EAGAIN - Atomic operation was unable to complete due to contention
+ * -ENOSYS - Operation not supported
  */
 static inline int
 arch_futex_atomic_op_inuser(int op, u32 oparg, int *oval, u32 __user *uaddr)
@@ -85,7 +87,9 @@ out_pagefault_enable:
  *
  * Return:
  * 0 - On success
- * <0 - On error
+ * -EFAULT - User access resulted in a page fault
+ * -EAGAIN - Atomic operation was unable to complete due to contention
+ * -ENOSYS - Function not implemented (only if !HAVE_FUTEX_CMPXCHG)
  */
 static inline int
 futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,


