Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85E3F7407E
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfGXU5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:57:08 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46665 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfGXU5H (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 16:57:07 -0400
Received: by mail-ed1-f68.google.com with SMTP id d4so48307733edr.13
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 13:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eryyJhUH5QCofh1sFxaMyWehz9K9ZS8D9QxUKSASVLU=;
        b=xJVNbKTl6Qv8aNIVkEnI/dfmbNg2k9OBSZTgRj3TbzyCenAo+XdAL1jTGj/3OXvG7z
         FJPnM75mqwrlPMM9RaoODbSTLA5/5ZpeJ+8h23x1mnn9G6rCc0bWjdWHKaPDa7R3dKcR
         OvJDSZPua8frgsh5h9wYlK6GAkkl9axvnFSDw/u+AjOsGApdYtm6xiOJSqMICQXHwmNR
         PCFBUvkDjU8SJsox7jxYM1wMuvYqh5sQsMM3qxn6BIgN+tFuHJy8aouebKbfbdRMAiq+
         Rpbf0pnOgm/I2HrjQjWtL5IC6cKlH53yAproQohhYMXplcQajZa5z+457LS2ZnsboaZP
         C8sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eryyJhUH5QCofh1sFxaMyWehz9K9ZS8D9QxUKSASVLU=;
        b=swJ8vMkujRK3Uq3lloOB4SCMjlnGurHPJQupHEaYefM8L3Ja3Sia32qSeSAc3ehhz0
         hGYhGWimmQ03xEs1MDXFLTS/2dimAiK1Hno9qcvG8dwqph6qSmhiEf3RWhmHZNkTbdEz
         HGcVyPEIAacyZrF51LHLXVz270UMUgZVp4GSTRMUz0VEkQ1LHBgyeKLDmjVRKUhtqaDO
         A3KxERakwlmZO/EzMPmBJVskliiYBa1I2iPLMK/h9dK8OrgIULJl26t0HwD/hjuyoxdI
         qOWwwdzWIGBxEGKTAYbZswAF8UqDjOl7JK1OYUlHhHJXEd9EplAwXCzvcgxeoQhwnljh
         dlOw==
X-Gm-Message-State: APjAAAWtxK1Z4sSdgPRAtN0aIceLphrNC8O8OdFb7tOxpG3vuAYG9HHg
        JrlrfsjcU2cratLwb/nlX0abNJ/gPzcqsg==
X-Google-Smtp-Source: APXvYqyFQQN0ENzHoSjpEtXamAZrP1fmqz5JjJggqcHtwupNBp6T2QQ9mSbSG9+6GOzKNsJcbwf1SQ==
X-Received: by 2002:a50:d2d3:: with SMTP id q19mr73254104edg.64.1564001826117;
        Wed, 24 Jul 2019 13:57:06 -0700 (PDT)
Received: from tsr-vdi-mbaerts.nix.tessares.net (static.23.216.130.94.clients.your-server.de. [94.130.216.23])
        by smtp.gmail.com with ESMTPSA id g18sm9358317ejo.3.2019.07.24.13.57.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 13:57:05 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     stable@vger.kernel.org
Cc:     asmadeus@codewreck.org, sashal@kernel.org,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH 1/3] compiler.h, kasan: Avoid duplicating __read_once_size_nocheck()
Date:   Wed, 24 Jul 2019 22:55:55 +0200
Message-Id: <20190724205557.30913-2-matthieu.baerts@tessares.net>
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

commit bdb5ac801af3d81d36732c2f640d6a1d3df83826 upstream.

Instead of having two identical __read_once_size_nocheck() functions
with different attributes, consolidate all the difference in new macro
__no_kasan_or_inline and use it. No functional changes.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 include/linux/compiler.h | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index a704d032713b..f490d8d93ec3 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -185,23 +185,21 @@ void __read_once_size(const volatile void *p, void *res, int size)
 
 #ifdef CONFIG_KASAN
 /*
- * This function is not 'inline' because __no_sanitize_address confilcts
+ * We can't declare function 'inline' because __no_sanitize_address confilcts
  * with inlining. Attempt to inline it may cause a build failure.
  * 	https://gcc.gnu.org/bugzilla/show_bug.cgi?id=67368
  * '__maybe_unused' allows us to avoid defined-but-not-used warnings.
  */
-static __no_sanitize_address __maybe_unused
-void __read_once_size_nocheck(const volatile void *p, void *res, int size)
-{
-	__READ_ONCE_SIZE;
-}
+# define __no_kasan_or_inline __no_sanitize_address __maybe_unused
 #else
-static __always_inline
+# define __no_kasan_or_inline __always_inline
+#endif
+
+static __no_kasan_or_inline
 void __read_once_size_nocheck(const volatile void *p, void *res, int size)
 {
 	__READ_ONCE_SIZE;
 }
-#endif
 
 static __always_inline void __write_once_size(volatile void *p, void *res, int size)
 {
-- 
2.20.1

