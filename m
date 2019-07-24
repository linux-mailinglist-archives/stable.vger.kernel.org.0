Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1D17407F
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbfGXU5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:57:10 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39367 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfGXU5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 16:57:09 -0400
Received: by mail-ed1-f65.google.com with SMTP id m10so48265898edv.6
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 13:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FdGEJMnIQppd+uqF8NJ9JKxWkfQ7uf4+UZdUmfogHW0=;
        b=HbSYGPAdQ85XRDzwlip0t6JjUjWx2UB7d5vuAl4mxpFUCQz70CfJSZu0WlGQ94SOaY
         HV2mqgVH2jhp+AL7EJhZDx4ICqcuz41OgpvsB0DcfooJHAvlg9kSIZLNRC3YcVgm4DM9
         oMG6uLIaDEnpDZlPfnNXJJzvLN209Lj4vzol08faoDkEkRoToj0gHbllL8FJ0tyZuSvQ
         E4zpDPVDz4YgCo04uO1emOOeWWI+hiBCsQFh0cKnKS0Fp1IPZ1J/ushjjRr5RCvRrHoL
         I3PiuGQZzT6gi7fr825/cghqiNoIsnrDsbTwynXn4HW+eTCEdhUtqB1s62+5oFyt6C7f
         fu5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FdGEJMnIQppd+uqF8NJ9JKxWkfQ7uf4+UZdUmfogHW0=;
        b=TftXGaETeL4+Wtbo0cziWVWKHw7NOJXnegBvXdRe+05wlRNPv9J/edkRo+ZpJdwSkm
         zgBdZNvwH4TYZTeuPoXtmy/08m6cR/LLxV+mD7AjbLIsKLKXCSXjVqGzQvHqKPnypCFV
         v7AGm1XpVq8EEiHberG04UwPq1BuQ71f2mcMtY2aw27DbVS4zL1Um8G4NgBksMqf5tYU
         B0beQno2O+OGreUeB7VvCHgMUC+PBuGK3NzUDUlVRuNiaD+GvOajpKCas6XtLuW2gito
         fgFl3G3ihqCK0RKakdarS2is6v3ECfjdrZZK6s/e+VN8rEwWG06Si6YhagOWN0BsUKF5
         8b5A==
X-Gm-Message-State: APjAAAXRkuCu/0XzM3nPKf9+7ikwQs7IvOvdUN7QVxf+JPQHppDdW8/t
        GxlEXDjiuBXIAtFBkTqbqxNyzmSUGmt4Bg==
X-Google-Smtp-Source: APXvYqwtE0KT9PLfDZKqcs+PajU7zg0cr0qxgFct/M/0cGUwQ7+BspHNmkGhjM4VAPETLayx9NVcUw==
X-Received: by 2002:a17:906:2557:: with SMTP id j23mr64017996ejb.228.1564001827519;
        Wed, 24 Jul 2019 13:57:07 -0700 (PDT)
Received: from tsr-vdi-mbaerts.nix.tessares.net (static.23.216.130.94.clients.your-server.de. [94.130.216.23])
        by smtp.gmail.com with ESMTPSA id g18sm9358317ejo.3.2019.07.24.13.57.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 13:57:07 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     stable@vger.kernel.org
Cc:     asmadeus@codewreck.org, sashal@kernel.org,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH 2/3] compiler.h: Add read_word_at_a_time() function.
Date:   Wed, 24 Jul 2019 22:55:56 +0200
Message-Id: <20190724205557.30913-3-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190724205557.30913-1-matthieu.baerts@tessares.net>
References: <20190724205557.30913-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ryabinin <aryabinin@virtuozzo.com>

commit 7f1e541fc8d57a143dd5df1d0a1276046e08c083 upstream.

Sometimes we know that it's safe to do potentially out-of-bounds access
because we know it won't cross a page boundary.  Still, KASAN will
report this as a bug.

Add read_word_at_a_time() function which is supposed to be used in such
cases.  In read_word_at_a_time() KASAN performs relaxed check - only the
first byte of access is validated.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 include/linux/compiler.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index f490d8d93ec3..f84d332085c3 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -238,6 +238,7 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
  * required ordering.
  */
 #include <asm/barrier.h>
+#include <linux/kasan-checks.h>
 
 #define __READ_ONCE(x, check)						\
 ({									\
@@ -257,6 +258,13 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
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

