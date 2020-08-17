Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA038246B90
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388135AbgHQP6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:58:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388124AbgHQP6Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:58:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5E2520729;
        Mon, 17 Aug 2020 15:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679905;
        bh=WE+uSikW384/lDpstgKl9Ks5l2pEQaqvx23IxVZjKmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YwKbfz3SyHxhHreKDWuIOCw+kvqiD/Ay60Z0Xxa1vc79QXmEVqw6m1erBiMy5EH64
         7jUSMydJNNOMskePPoLzpcn2ieLHDwRIHcfRQiOhexSUBy5nHLMEVyomB+hdkwq55G
         zN0A36BzFUvq08KrZJAKAkrf1FbJ0rHpFQDuRPKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.7 374/393] parisc: Implement __smp_store_release and __smp_load_acquire barriers
Date:   Mon, 17 Aug 2020 17:17:04 +0200
Message-Id: <20200817143837.750832669@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John David Anglin <dave.anglin@bell.net>

commit e96ebd589debd9a6a793608c4ec7019c38785dea upstream.

This patch implements the __smp_store_release and __smp_load_acquire barriers
using ordered stores and loads.  This avoids the sync instruction present in
the generic implementation.

Cc: <stable@vger.kernel.org> # 4.14+
Signed-off-by: Dave Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/include/asm/barrier.h |   61 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

--- a/arch/parisc/include/asm/barrier.h
+++ b/arch/parisc/include/asm/barrier.h
@@ -26,6 +26,67 @@
 #define __smp_rmb()	mb()
 #define __smp_wmb()	mb()
 
+#define __smp_store_release(p, v)					\
+do {									\
+	typeof(p) __p = (p);						\
+        union { typeof(*p) __val; char __c[1]; } __u =			\
+                { .__val = (__force typeof(*p)) (v) };			\
+	compiletime_assert_atomic_type(*p);				\
+	switch (sizeof(*p)) {						\
+	case 1:								\
+		asm volatile("stb,ma %0,0(%1)"				\
+				: : "r"(*(__u8 *)__u.__c), "r"(__p)	\
+				: "memory");				\
+		break;							\
+	case 2:								\
+		asm volatile("sth,ma %0,0(%1)"				\
+				: : "r"(*(__u16 *)__u.__c), "r"(__p)	\
+				: "memory");				\
+		break;							\
+	case 4:								\
+		asm volatile("stw,ma %0,0(%1)"				\
+				: : "r"(*(__u32 *)__u.__c), "r"(__p)	\
+				: "memory");				\
+		break;							\
+	case 8:								\
+		if (IS_ENABLED(CONFIG_64BIT))				\
+			asm volatile("std,ma %0,0(%1)"			\
+				: : "r"(*(__u64 *)__u.__c), "r"(__p)	\
+				: "memory");				\
+		break;							\
+	}								\
+} while (0)
+
+#define __smp_load_acquire(p)						\
+({									\
+	union { typeof(*p) __val; char __c[1]; } __u;			\
+	typeof(p) __p = (p);						\
+	compiletime_assert_atomic_type(*p);				\
+	switch (sizeof(*p)) {						\
+	case 1:								\
+		asm volatile("ldb,ma 0(%1),%0"				\
+				: "=r"(*(__u8 *)__u.__c) : "r"(__p)	\
+				: "memory");				\
+		break;							\
+	case 2:								\
+		asm volatile("ldh,ma 0(%1),%0"				\
+				: "=r"(*(__u16 *)__u.__c) : "r"(__p)	\
+				: "memory");				\
+		break;							\
+	case 4:								\
+		asm volatile("ldw,ma 0(%1),%0"				\
+				: "=r"(*(__u32 *)__u.__c) : "r"(__p)	\
+				: "memory");				\
+		break;							\
+	case 8:								\
+		if (IS_ENABLED(CONFIG_64BIT))				\
+			asm volatile("ldd,ma 0(%1),%0"			\
+				: "=r"(*(__u64 *)__u.__c) : "r"(__p)	\
+				: "memory");				\
+		break;							\
+	}								\
+	__u.__val;							\
+})
 #include <asm-generic/barrier.h>
 
 #endif /* !__ASSEMBLY__ */


