Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06EF912B9FA
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 19:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbfL0SPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 13:15:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:40112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727910AbfL0SPS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 13:15:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6D06208C4;
        Fri, 27 Dec 2019 18:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577470518;
        bh=Czplure2xZKgEkKI4XC5UMk7izwZoY4ItYjVWnKukSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mtL9+c7ppH2soJS2OhwFLMqgYzdtWqxFuQhJwjPszi+hn+JgI7hbHAH/QRQ/2ixnf
         RUYg51iuaqZziL7i/x6GOZCf6CBBuAdYdnXlrtuNLw57x3GOCvlXZTxmkBqNXRFQjj
         wy2r37cIvmWEuwkd/GEaSqeHYZaoMSpTw3MIxqzY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 35/38] parisc: Fix compiler warnings in debug_core.c
Date:   Fri, 27 Dec 2019 13:14:32 -0500
Message-Id: <20191227181435.7644-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227181435.7644-1-sashal@kernel.org>
References: <20191227181435.7644-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

[ Upstream commit 75cf9797006a3a9f29a3a25c1febd6842a4a9eb2 ]

Fix this compiler warning:
kernel/debug/debug_core.c: In function ‘kgdb_cpu_enter’:
arch/parisc/include/asm/cmpxchg.h:48:3: warning: value computed is not used [-Wunused-value]
   48 |  ((__typeof__(*(ptr)))__xchg((unsigned long)(x), (ptr), sizeof(*(ptr))))
arch/parisc/include/asm/atomic.h:78:30: note: in expansion of macro ‘xchg’
   78 | #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
      |                              ^~~~
kernel/debug/debug_core.c:596:4: note: in expansion of macro ‘atomic_xchg’
  596 |    atomic_xchg(&kgdb_active, cpu);
      |    ^~~~~~~~~~~

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/include/asm/cmpxchg.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/include/asm/cmpxchg.h b/arch/parisc/include/asm/cmpxchg.h
index 7ada30900807..90253bdc2ee5 100644
--- a/arch/parisc/include/asm/cmpxchg.h
+++ b/arch/parisc/include/asm/cmpxchg.h
@@ -43,8 +43,14 @@ __xchg(unsigned long x, __volatile__ void *ptr, int size)
 **		if (((unsigned long)p & 0xf) == 0)
 **			return __ldcw(p);
 */
-#define xchg(ptr, x) \
-	((__typeof__(*(ptr)))__xchg((unsigned long)(x), (ptr), sizeof(*(ptr))))
+#define xchg(ptr, x)							\
+({									\
+	__typeof__(*(ptr)) __ret;					\
+	__typeof__(*(ptr)) _x_ = (x);					\
+	__ret = (__typeof__(*(ptr)))					\
+		__xchg((unsigned long)_x_, (ptr), sizeof(*(ptr)));	\
+	__ret;								\
+})
 
 /* bug catcher for when unsupported size is used - won't link */
 extern void __cmpxchg_called_with_bad_pointer(void);
-- 
2.20.1

