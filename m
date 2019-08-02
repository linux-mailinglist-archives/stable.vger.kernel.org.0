Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 100987F2A7
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391980AbfHBJpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:45:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391971AbfHBJpf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:45:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDED520880;
        Fri,  2 Aug 2019 09:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739134;
        bh=Lu4+E5cSdMAjT4XNg3HizGNr19L7uNOmMKkvlhBpEAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SbPyl03/nS2zb1oA4fttmwxEdMVsekfOCzZQnBThcZ7LtFvHZ7Zd1kb92uEgQs/Qw
         IO5mpmjBvfFCT/J8q+dUTgFvdUFuIZXGKFKCxz6l3/8bIeDYtC+NyvXWHc2lsZs6TN
         XklErC5CmSpmGqmQDCcNp14J0um8RihJ9dRvpe6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 126/223] compiler.h: Add read_word_at_a_time() function.
Date:   Fri,  2 Aug 2019 11:35:51 +0200
Message-Id: <20190802092247.238287886@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7f1e541fc8d57a143dd5df1d0a1276046e08c083 ]

Sometimes we know that it's safe to do potentially out-of-bounds access
because we know it won't cross a page boundary.  Still, KASAN will
report this as a bug.

Add read_word_at_a_time() function which is supposed to be used in such
cases.  In read_word_at_a_time() KASAN performs relaxed check - only the
first byte of access is validated.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index ced454c03819..3050de0dac96 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -302,6 +302,7 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
  * with an explicit memory barrier or atomic instruction that provides the
  * required ordering.
  */
+#include <linux/kasan-checks.h>
 
 #define __READ_ONCE(x, check)						\
 ({									\
@@ -320,6 +321,13 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
  */
 #define READ_ONCE_NOCHECK(x) __READ_ONCE(x, 0)
 
+static __no_kasan_or_inline
+unsigned long read_word_at_a_time(const void *addr)
+{
+	kasan_check_read(addr, 1);
+	return *(unsigned long *)addr;
+}
+
 #define WRITE_ONCE(x, val) \
 ({							\
 	union { typeof(x) __val; char __c[1]; } __u =	\
-- 
2.20.1



