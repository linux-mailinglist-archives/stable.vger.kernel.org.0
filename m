Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E90B3D42CC
	for <lists+stable@lfdr.de>; Sat, 24 Jul 2021 00:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbhGWVjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 17:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232841AbhGWVjJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 17:39:09 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FFEC061796
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 15:19:39 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id m2-20020a17090a71c2b0290175cf22899cso5636010pjs.2
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 15:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T8DwI8fnRArZqHUblKXlj4bT7xhIFIuBs/B+X1cQdyw=;
        b=MdmgAbLiBnkHjIj7AibPaMgyMFymg5wpuW8KVCy/+kzlmK8sCgYDC2iH4eJ0VkIi3s
         dlh/1LgW7nLtl0+mJi0iordvLi01Htcko3rr/K6upyjicHk9sYtzf179gK8ZRoc3aKT9
         UQKSXjAYu0HycKS14V4j8ug0dqKxe+J4Th73o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T8DwI8fnRArZqHUblKXlj4bT7xhIFIuBs/B+X1cQdyw=;
        b=YUG50VsRXv4jFVJKb1BWOCd1D6hW3wxtJP9XqKGVG4ok4gB7Q/vBDXi/SEzJad1xwJ
         KoDHn0LKCB9UfEmjk7IssOy7MixyXMMZ803hksOExKqdcNs+P81Q7yMj2WDDRZ2HCHay
         oJPRQVsSRLFDecWPKT0bSzJZx12dBWfql81eoZuem80fixf8kXuv99SniJ9fDW2oMw+o
         Ep98iQRzbL3BwLGX/mluOsJnr83945pLO15ENIKRqtqdDOYc6sCvtRGcPVeFmbDwt6q2
         aj3eztyWUJti62errh3xYjisi4ALOBjI9IHPhNP7Uzn2ooLmRuY1vJWTN/VA5ln0YBQ2
         aa/w==
X-Gm-Message-State: AOAM531qF7eWqZ8ZkAeBSytXl3mYfFhDk06sPbuWkM+P53fpuaWZjW3u
        Y4n2o77L7HsOBQiNbNTPGScNUQ==
X-Google-Smtp-Source: ABdhPJybkHO8b0aJDqpNP0wVQL+iQIMjRsONEsFrhkpm172q7s1kn56Z7Bus0oVCPWl3Ui5IFDF8Jg==
X-Received: by 2002:a63:ef44:: with SMTP id c4mr6675167pgk.162.1627078779266;
        Fri, 23 Jul 2021 15:19:39 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id l65sm27825208pgl.32.2021.07.23.15.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 15:19:37 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Kees Cook <keescook@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH 1/3] lib/test_stackinit: Fix static initializer test
Date:   Fri, 23 Jul 2021 15:19:31 -0700
Message-Id: <20210723221933.3431999-2-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723221933.3431999-1-keescook@chromium.org>
References: <20210723221933.3431999-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2019; h=from:subject; bh=aRRyyNpJICHvBcmxWEK59jlinDlwFKz/j7t+tY2LYcM=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBg+0B0tjjRQRC2yzCBaDP86WMV114a/Nqov1cxgJHH oJBUUZ2JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYPtAdAAKCRCJcvTf3G3AJo2nEA CNcTtttQLSsbw4XgcOL4h+v/fRWOTBERUnZcZiXN/yjwqlEUmuhjdvEaRvCP8jNzHu8Dej65BvsJOV 7p9glRjTnOjCElxjXiVR876xW6U+7EcuEk1LOcIztZlKomjPiATMfRya0hXY4oXtXNuPxMk04t28W4 bB/kQBArrUlerB+dt5CHdhizLzPKegfXIHxRO1392dX8zwsnmNtieShoTaCky25OMkeRu5hkeiw6Sg MtM2VO2eNPj68LlYsOHnC+qtKYvV0h8h0MQF1HZ6dyb32VYdCnIO6optbIeIEfuIXStlIXjjEJNgff FHTZUn/ZnvoKvT237o5uABnl79Ipd+8AICohXJh2r6aSEC5nwFucd7WFxeC+j8SuXxI5d+9Uw3euGB csDlS6DJdWJyWZEXhFMnM0O+DpySmqx67T6xg0UuDdsK531gJf2YYaG+s8+qSkYHddcI6CEotCqumA d2Pw4pNhfLaIQKTJ+e/Xm9rM51O8p4FbFYgy9En3I+oZvzoc9HnUdoCMWO3hMZLDoQvRMvEOqOZBeq Ehs+JZFx7w+pwQFxgiQ8lGR/rSMBdLaRiNn+Tt/dInRyPXnt18jivIPexPjqsgnlwnO5+dgn2dgHwD +J4XZUMrXFxf6Zo9lfhC2B6L+AKPfy7VqKzrKFOPeA+qUjYvY8uN3MVs+FRQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The static initializer test got accidentally converted to a dynamic
initializer. Fix this and retain the giant padding hole without using
an aligned struct member.

Fixes: 50ceaa95ea09 ("lib: Introduce test_stackinit module")
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/test_stackinit.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/lib/test_stackinit.c b/lib/test_stackinit.c
index f93b1e145ada..16b1d3a3a497 100644
--- a/lib/test_stackinit.c
+++ b/lib/test_stackinit.c
@@ -67,10 +67,10 @@ static bool range_contains(char *haystack_start, size_t haystack_size,
 #define INIT_STRUCT_none		/**/
 #define INIT_STRUCT_zero		= { }
 #define INIT_STRUCT_static_partial	= { .two = 0, }
-#define INIT_STRUCT_static_all		= { .one = arg->one,		\
-					    .two = arg->two,		\
-					    .three = arg->three,	\
-					    .four = arg->four,		\
+#define INIT_STRUCT_static_all		= { .one = 0,			\
+					    .two = 0,			\
+					    .three = 0,			\
+					    .four = 0,			\
 					}
 #define INIT_STRUCT_dynamic_partial	= { .two = arg->two, }
 #define INIT_STRUCT_dynamic_all		= { .one = arg->one,		\
@@ -84,8 +84,7 @@ static bool range_contains(char *haystack_start, size_t haystack_size,
 					var.one = 0;			\
 					var.two = 0;			\
 					var.three = 0;			\
-					memset(&var.four, 0,		\
-					       sizeof(var.four))
+					var.four = 0
 
 /*
  * @name: unique string name for the test
@@ -210,18 +209,13 @@ struct test_small_hole {
 	unsigned long four;
 };
 
-/* Try to trigger unhandled padding in a structure. */
-struct test_aligned {
-	u32 internal1;
-	u64 internal2;
-} __aligned(64);
-
+/* Trigger unhandled padding in a structure. */
 struct test_big_hole {
 	u8 one;
 	u8 two;
 	u8 three;
 	/* 61 byte padding hole here. */
-	struct test_aligned four;
+	u8 four __aligned(64);
 } __aligned(64);
 
 struct test_trailing_hole {
-- 
2.30.2

