Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68BD814D09
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbfEFOrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:47:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729279AbfEFOrQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:47:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BEB6214AE;
        Mon,  6 May 2019 14:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557154035;
        bh=FbLKEUl3KRNnMUhZoYAxYnUWvRn/WoNTy/4xfKgqgTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iUsUXaFajtpqNF0q1lCxj9XIrxofqh2XCdO6WpTr4XHRDWF/HI4uOUGGhXqvhr8NE
         MfhqSQRfMMievXaY+F1BpGX+pRcZw4U6enDqD2TymUJ1sgh7BhcCfMlpYpWOLEjIx3
         Ln85VIyPHfE0k+lc30UIlamnsD8VU+5Cnvu4rn5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexander Potapenko <glider@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrey Konovalov <andreyknvl@google.com>
Subject: [PATCH 4.9 14/62] kasan: add a prototype of task_struct to avoid warning
Date:   Mon,  6 May 2019 16:32:45 +0200
Message-Id: <20190506143052.314322038@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143051.102535767@linuxfoundation.org>
References: <20190506143051.102535767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 5be9b730b09c45c358bbfe7f51d254e306cccc07 upstream.

Add a prototype of task_struct to fix below warning on arm64.

  In file included from arch/arm64/kernel/probes/kprobes.c:19:0:
  include/linux/kasan.h:81:132: error: 'struct task_struct' declared inside parameter list will not be visible outside of this definition or declaration [-Werror]
   static inline void kasan_unpoison_task_stack(struct task_struct *task) {}

As same as other types (kmem_cache, page, and vm_struct) this adds a
prototype of task_struct data structure on top of kasan.h.

[arnd] A related warning was fixed before, but now appears in a
different line in the same file in v4.11-rc2.  The patch from Masami
Hiramatsu still seems appropriate, so let's take his version.

Fixes: 71af2ed5eeea ("kasan, sched/headers: Remove <linux/sched.h> from <linux/kasan.h>")
Link: https://patchwork.kernel.org/patch/9569839/
Link: http://lkml.kernel.org/r/20170313141517.3397802-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Acked-by: Alexander Potapenko <glider@google.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/kasan.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -7,6 +7,7 @@
 struct kmem_cache;
 struct page;
 struct vm_struct;
+struct task_struct;
 
 #ifdef CONFIG_KASAN
 


