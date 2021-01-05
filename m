Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0DC22EA23A
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 02:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbhAEBBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 20:01:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:39316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728262AbhAEBBA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 20:01:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5072C22AB9;
        Tue,  5 Jan 2021 01:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609808409;
        bh=4USy8ooPm1V1emN2j6/rR2tjWTh74NSXa5QlOQO0+Dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T7AKCNxCYsASjzE8TrxhSpEuMILKNWsfm6PT0/5E/jsI75VVPYxG8At7wI2tnYQjR
         P6POnk9IudS0CS5Z4y8UhY384WElJjkQD1zDQUNiWkfzBenpE5D7nG2aV5N/FNyZjl
         4lFjZhH3pex/vK9LmFRzzStfi8BhUXFqQ1n7TXdXgL5gNMQF9W63dQdW0CpHanOAOt
         WyJz2ea0F25+aCOIhYt6wZ+0SqEQTMFhT4Kjn6Wxj9bNYdwY9goDOvrx7CM6T3Pfnl
         6QRam/YMilW/HGnXz8AP5ulEBLH/+uxPUfN/0M27o5rYwnPcHCrXNvimyiLvLQfFjA
         p4CBvwRUZkX6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 6/8] kdev_t: always inline major/minor helper functions
Date:   Mon,  4 Jan 2021 19:59:57 -0500
Message-Id: <20210105005959.3954510-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210105005959.3954510-1-sashal@kernel.org>
References: <20210105005959.3954510-1-sashal@kernel.org>
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

