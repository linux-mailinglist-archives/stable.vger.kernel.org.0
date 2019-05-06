Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60EA914D9C
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbfEFOr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:47:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbfEFOrT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:47:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC8FC20449;
        Mon,  6 May 2019 14:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557154038;
        bh=vbPwdDLTa7OrWI0SflkBBJ7iLeQtCJf62w+l948vi5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a9qkcwulZLKR6zNcFJBYvGoS9Xa56qiqjXrNsesEpaB3rmDEXXbl8KAXRluVy8hle
         rO44TB43iCc3+OmsN3u+kvcHY1rn2isUbsVvM6ZP3QfOkBLl18dP5f9YeWvCG1LWx1
         xf421H83RbfifHERmKsKj3kgKGX4nLlWCgRHL36s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Alexander Potapenko <glider@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrey Konovalov <andreyknvl@google.com>
Subject: [PATCH 4.9 15/62] kasan: avoid -Wmaybe-uninitialized warning
Date:   Mon,  6 May 2019 16:32:46 +0200
Message-Id: <20190506143052.384495640@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

commit e7701557bfdd81ff44cab13a80439319a735d8e2 upstream.

gcc-7 produces this warning:

  mm/kasan/report.c: In function 'kasan_report':
  mm/kasan/report.c:351:3: error: 'info.first_bad_addr' may be used uninitialized in this function [-Werror=maybe-uninitialized]
     print_shadow_for_address(info->first_bad_addr);
     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  mm/kasan/report.c:360:27: note: 'info.first_bad_addr' was declared here

The code seems fine as we only print info.first_bad_addr when there is a
shadow, and we always initialize it in that case, but this is relatively
hard for gcc to figure out after the latest rework.

Adding an intialization to the most likely value together with the other
struct members shuts up that warning.

Fixes: b235b9808664 ("kasan: unify report headers")
Link: https://patchwork.kernel.org/patch/9641417/
Link: http://lkml.kernel.org/r/20170725152739.4176967-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Alexander Potapenko <glider@google.com>
Suggested-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/kasan/report.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -302,6 +302,7 @@ void kasan_report(unsigned long addr, si
 	disable_trace_on_warning();
 
 	info.access_addr = (void *)addr;
+	info.first_bad_addr = (void *)addr;
 	info.access_size = size;
 	info.is_write = is_write;
 	info.ip = ip;


