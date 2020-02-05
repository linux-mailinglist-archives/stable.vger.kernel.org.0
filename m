Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5DE153288
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 15:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgBEOLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 09:11:13 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47526 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbgBEOLN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 09:11:13 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1D36C158F2D1F
        for <stable@vger.kernel.org>; Wed,  5 Feb 2020 06:11:11 -0800 (PST)
Date:   Wed, 05 Feb 2020 15:11:10 +0100 (CET)
Message-Id: <20200205.151110.999222765422116817.davem@davemloft.net>
To:     stable@vger.kernel.org
Subject: [PATCH] Sparc
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Wed_Feb__5_15_11_10_2020_468)--"
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Feb 2020 06:11:12 -0800 (PST)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----Next_Part(Wed_Feb__5_15_11_10_2020_468)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Please queue up the attached sparc bug fix for -stable, thanks!

----Next_Part(Wed_Feb__5_15_11_10_2020_468)--
Content-Type: Text/X-Patch; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-sparc32-fix-struct-ipc64_perm-type-definition.patch"

From 34ca70ef7d3a9fa7e89151597db5e37ae1d429b4 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 14 Jan 2020 14:26:14 +0100
Subject: [PATCH] sparc32: fix struct ipc64_perm type definition

[ Upstream commit 34ca70ef7d3a9fa7e89151597db5e37ae1d429b4 ]

As discussed in the strace issue tracker, it appears that the sparc32
sysvipc support has been broken for the past 11 years. It was however
working in compat mode, which is how it must have escaped most of the
regular testing.

The problem is that a cleanup patch inadvertently changed the uid/gid
fields in struct ipc64_perm from 32-bit types to 16-bit types in uapi
headers.

Both glibc and uclibc-ng still use the original types, so they should
work fine with compat mode, but not natively.  Change the definitions
to use __kernel_uid32_t and __kernel_gid32_t again.

Fixes: 83c86984bff2 ("sparc: unify ipcbuf.h")
Link: https://github.com/strace/strace/issues/116
Cc: <stable@vger.kernel.org> # v2.6.29
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: "Dmitry V . Levin" <ldv@altlinux.org>
Cc: Rich Felker <dalias@libc.org>
Cc: libc-alpha@sourceware.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/include/uapi/asm/ipcbuf.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/sparc/include/uapi/asm/ipcbuf.h b/arch/sparc/include/uapi/asm/ipcbuf.h
index 9d0d125500e2..084b8949ddff 100644
--- a/arch/sparc/include/uapi/asm/ipcbuf.h
+++ b/arch/sparc/include/uapi/asm/ipcbuf.h
@@ -15,19 +15,19 @@
 
 struct ipc64_perm
 {
-	__kernel_key_t	key;
-	__kernel_uid_t	uid;
-	__kernel_gid_t	gid;
-	__kernel_uid_t	cuid;
-	__kernel_gid_t	cgid;
+	__kernel_key_t		key;
+	__kernel_uid32_t	uid;
+	__kernel_gid32_t	gid;
+	__kernel_uid32_t	cuid;
+	__kernel_gid32_t	cgid;
 #ifndef __arch64__
-	unsigned short	__pad0;
+	unsigned short		__pad0;
 #endif
-	__kernel_mode_t	mode;
-	unsigned short	__pad1;
-	unsigned short	seq;
-	unsigned long long __unused1;
-	unsigned long long __unused2;
+	__kernel_mode_t		mode;
+	unsigned short		__pad1;
+	unsigned short		seq;
+	unsigned long long	__unused1;
+	unsigned long long	__unused2;
 };
 
 #endif /* __SPARC_IPCBUF_H */
-- 
2.21.1


----Next_Part(Wed_Feb__5_15_11_10_2020_468)----
