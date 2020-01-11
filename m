Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD7C137E19
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729381AbgAKKEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:04:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:37706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729014AbgAKKEz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:04:55 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC80E20848;
        Sat, 11 Jan 2020 10:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737094;
        bh=Czplure2xZKgEkKI4XC5UMk7izwZoY4ItYjVWnKukSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CS8Rhi1ZpXvaC1bV99SD0ZceWfoHUg5tMRV4V8Wk0FOKL/2rK9CHdZMsQvxEZbwaa
         Zxup85V2ytPPwUSVhhWFE+5FF+2prFmK0ofBMKw1+szAEbVwjGiOGgGXjTxi9TEpSF
         3uCWwXTcvTkk6x7xvmHt/d8nGAgXmq03NwZbgFnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 78/91] parisc: Fix compiler warnings in debug_core.c
Date:   Sat, 11 Jan 2020 10:50:11 +0100
Message-Id: <20200111094911.999048821@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094844.748507863@linuxfoundation.org>
References: <20200111094844.748507863@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



