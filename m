Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3838211DBD
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbfEBPcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:32:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729251AbfEBPcp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:32:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C882204FD;
        Thu,  2 May 2019 15:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811165;
        bh=BdzpmYzAWExyfYKpHVJvoGGI6FCQygD2FkuFSOg7x7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RNNoy4AbJfQ4THE8H+2/ztV4CIYP2gzBJKYDma612omkNs8drG2UEXO2pqv37MAL7
         dECkp2WEOZ/xstvY+4t0orzMAZd7XuYOEerzHm3pSQGS7z3sxdXjopCs2ZrU98UFe0
         ycRp7tp2N+mfGmoFAr9m8tol7wNzBTYKJxkcqWOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 098/101] kasan: fix variable tag set but not used warning
Date:   Thu,  2 May 2019 17:21:40 +0200
Message-Id: <20190502143346.401658504@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c412a769d2452161e97f163c4c4f31efc6626f06 ]

set_tag() compiles away when CONFIG_KASAN_SW_TAGS=n, so make
arch_kasan_set_tag() a static inline function to fix warnings below.

  mm/kasan/common.c: In function '__kasan_kmalloc':
  mm/kasan/common.c:475:5: warning: variable 'tag' set but not used [-Wunused-but-set-variable]
    u8 tag;
       ^~~

Link: http://lkml.kernel.org/r/20190307185244.54648-1-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 mm/kasan/kasan.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index ea51b2d898ec..c980ce43e3ba 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -164,7 +164,10 @@ static inline u8 random_tag(void)
 #endif
 
 #ifndef arch_kasan_set_tag
-#define arch_kasan_set_tag(addr, tag)	((void *)(addr))
+static inline const void *arch_kasan_set_tag(const void *addr, u8 tag)
+{
+	return addr;
+}
 #endif
 #ifndef arch_kasan_reset_tag
 #define arch_kasan_reset_tag(addr)	((void *)(addr))
-- 
2.19.1



