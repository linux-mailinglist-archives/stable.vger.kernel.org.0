Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E72E32EA2AD
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 02:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbhAEBFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 20:05:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:39240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728254AbhAEBA5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 20:00:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26A3622AAD;
        Tue,  5 Jan 2021 00:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609808396;
        bh=4USy8ooPm1V1emN2j6/rR2tjWTh74NSXa5QlOQO0+Dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OLYjzEslzDYCW7bDiuEKd1HZkeIz7dZfIoLdbylFNlPGFO69H6CJ+vxuxXUkxqv3y
         qcsZDEkzz6IZqBJhZMRqvNZY2/oqaZuvCmPHkjDypsnfeJ1J7gc19K1wT4OqvW3jPs
         PG7YdPW4qdAACSALIxsOroHxPrRVsox87yL+52l9JfoSjjtEnB4fznlmd782Pjrygf
         hGAB3F39GxdQ2KjFEI9r86Hfdur98uKgxgxnKMBqV2QX8DJ5bQ4aVMNFX0+Y7wWVcp
         dbBR+SnKE8RXyG+wIP4yh1KmSPHb4RC2ipj8ktr4flb8134MroLFu00XhKE0BeK/xZ
         OfG7uwiTZbPVA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 6/8] kdev_t: always inline major/minor helper functions
Date:   Mon,  4 Jan 2021 19:59:43 -0500
Message-Id: <20210105005946.3954395-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210105005946.3954395-1-sashal@kernel.org>
References: <20210105005946.3954395-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit aa8c7db494d0a83ecae583aa193f1134ef25d506 ]

Silly GCC doesn't always inline these trivial functions.

Fixes the following warning:

  arch/x86/kernel/sys_ia32.o: warning: objtool: cp_stat64()+0xd8: call to new_encode_dev() with UACCESS enabled

Link: https://lkml.kernel.org/r/984353b44a4484d86ba9f73884b7306232e25e30.1608737428.git.jpoimboe@redhat.com
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>	[build-tested]
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kdev_t.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/kdev_t.h b/include/linux/kdev_t.h
index 85b5151911cfd..4856706fbfeb4 100644
--- a/include/linux/kdev_t.h
+++ b/include/linux/kdev_t.h
@@ -21,61 +21,61 @@
 	})
 
 /* acceptable for old filesystems */
-static inline bool old_valid_dev(dev_t dev)
+static __always_inline bool old_valid_dev(dev_t dev)
 {
 	return MAJOR(dev) < 256 && MINOR(dev) < 256;
 }
 
-static inline u16 old_encode_dev(dev_t dev)
+static __always_inline u16 old_encode_dev(dev_t dev)
 {
 	return (MAJOR(dev) << 8) | MINOR(dev);
 }
 
-static inline dev_t old_decode_dev(u16 val)
+static __always_inline dev_t old_decode_dev(u16 val)
 {
 	return MKDEV((val >> 8) & 255, val & 255);
 }
 
-static inline u32 new_encode_dev(dev_t dev)
+static __always_inline u32 new_encode_dev(dev_t dev)
 {
 	unsigned major = MAJOR(dev);
 	unsigned minor = MINOR(dev);
 	return (minor & 0xff) | (major << 8) | ((minor & ~0xff) << 12);
 }
 
-static inline dev_t new_decode_dev(u32 dev)
+static __always_inline dev_t new_decode_dev(u32 dev)
 {
 	unsigned major = (dev & 0xfff00) >> 8;
 	unsigned minor = (dev & 0xff) | ((dev >> 12) & 0xfff00);
 	return MKDEV(major, minor);
 }
 
-static inline u64 huge_encode_dev(dev_t dev)
+static __always_inline u64 huge_encode_dev(dev_t dev)
 {
 	return new_encode_dev(dev);
 }
 
-static inline dev_t huge_decode_dev(u64 dev)
+static __always_inline dev_t huge_decode_dev(u64 dev)
 {
 	return new_decode_dev(dev);
 }
 
-static inline int sysv_valid_dev(dev_t dev)
+static __always_inline int sysv_valid_dev(dev_t dev)
 {
 	return MAJOR(dev) < (1<<14) && MINOR(dev) < (1<<18);
 }
 
-static inline u32 sysv_encode_dev(dev_t dev)
+static __always_inline u32 sysv_encode_dev(dev_t dev)
 {
 	return MINOR(dev) | (MAJOR(dev) << 18);
 }
 
-static inline unsigned sysv_major(u32 dev)
+static __always_inline unsigned sysv_major(u32 dev)
 {
 	return (dev >> 18) & 0x3fff;
 }
 
-static inline unsigned sysv_minor(u32 dev)
+static __always_inline unsigned sysv_minor(u32 dev)
 {
 	return dev & 0x3ffff;
 }
-- 
2.27.0

