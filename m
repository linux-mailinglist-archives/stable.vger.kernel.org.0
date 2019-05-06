Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D12E14CC4
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfEFOnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:43:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727165AbfEFOnt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:43:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F017921479;
        Mon,  6 May 2019 14:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153828;
        bh=eWrxKa5mruWpD72si73uMiQaXjLDj/Ihgq8FAilg64g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ayp0yk7PkP7ShVWzh8BmbrBmqeP3iisEHiT7Q6zv/badwGUNLw3QCySqdC3A6WVf7
         VvzCXAwyWB5h/+9WCSrmAqUxwGLGHLIaFZ85cTdt7RxaBBKzTKIF02dm9g4/dUHOVx
         UqSj1jFftoW6nHgeoVNeQQ4XfLKY2rp+kjsZuGkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrey Konovalov <andreyknvl@google.com>
Subject: [PATCH 4.14 12/75] kasan: remove redundant initialization of variable real_size
Date:   Mon,  6 May 2019 16:32:20 +0200
Message-Id: <20190506143054.307788749@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.287515952@linuxfoundation.org>
References: <20190506143053.287515952@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 48c232395431c23d35cf3b4c5a090bd793316578 upstream.

Variable real_size is initialized with a value that is never read, it is
re-assigned a new value later on, hence the initialization is redundant
and can be removed.

Cleans up clang warning:

  lib/test_kasan.c:422:21: warning: Value stored to 'real_size' during its initialization is never read

Link: http://lkml.kernel.org/r/20180206144950.32457-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/test_kasan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_kasan.c
+++ b/lib/test_kasan.c
@@ -389,7 +389,7 @@ static noinline void __init kasan_stack_
 static noinline void __init ksize_unpoisons_memory(void)
 {
 	char *ptr;
-	size_t size = 123, real_size = size;
+	size_t size = 123, real_size;
 
 	pr_info("ksize() unpoisons the whole allocated chunk\n");
 	ptr = kmalloc(size, GFP_KERNEL);


