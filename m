Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC30268F843
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 20:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbjBHTrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 14:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBHTrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 14:47:21 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601511C7CA
        for <stable@vger.kernel.org>; Wed,  8 Feb 2023 11:47:20 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id u9so46226plf.3
        for <stable@vger.kernel.org>; Wed, 08 Feb 2023 11:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=brC7ZYjyc3j8bB5PrUFBP0Q4YonnqNt9B3ugO0VDvOM=;
        b=XyHQIco0IOY9dG4wWkirUBexpmIEGsaN0oZPdRAAdC6TjWBES3V0aDEQ0wXmmb0eTi
         5h7e88D8Ub7LU7S6Hj6Af0YQgsgNYwEM0gnURhDjt4beSp1PWidWYvSQfBAeV9jxPgjn
         tNJxmlZIVnPudiPkJdXIIX0Q7e4fHaQI+OOyY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=brC7ZYjyc3j8bB5PrUFBP0Q4YonnqNt9B3ugO0VDvOM=;
        b=8IJQ6Q+FarMsZ5xpswmkzcvI+M1qJQZ/1ZccSd2iuKCm/9LjREo/B42BPqxNnTKxih
         iZeYMn8HAnqTnMrNOtdxuEQ0qyE1lDJwCP1g+XaHxrBbXtl3BHfF0cKR13PhO4YRIMwJ
         xh7zPRH8w5qfFvD4owjzSc8Fe2pCg011V1tlTHcM3KLesTa8yrRsmspwnQjQ/GKODACb
         nX9Qc0DowVhT2pPkXk0xScgW7rZ4mulSVOmmdOSPqiStRyWFhfMpb8SfzFdrvBFGlUAF
         Y0M1mSnIKRyTSXC3yNJjPpQyHdjhiGXaPceA6A/BnU0IaEZ6G5aRHoYi/907CStqSrqt
         a6bQ==
X-Gm-Message-State: AO0yUKURDEniMNgjuaD5+x2t5ApjwjmWMg7Q/5ZJ6VtEu49F1PWbqzOd
        fdK/YYuNp6JHXATIzc+o3BoB2A==
X-Google-Smtp-Source: AK7set/cQfxHzl5ZMC5P3I9HJYBt7B/d7dsyJhydqhY7pfA+m/nmRYDN+fINhs3jW+jfB1JGDxyefA==
X-Received: by 2002:a17:902:eccf:b0:195:e834:31de with SMTP id a15-20020a170902eccf00b00195e83431demr9689202plh.27.1675885639902;
        Wed, 08 Feb 2023 11:47:19 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id o8-20020a170902778800b00194706d3f25sm11389978pll.144.2023.02.08.11.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 11:47:19 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Kees Cook <keescook@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>, concord@gentoo.org,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Petr Mladek <pmladek@suse.com>, linux-mm@kvack.org,
        stable@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@acm.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] Revert "slub: force on no_hash_pointers when slub_debug is enabled"
Date:   Wed,  8 Feb 2023 11:47:17 -0800
Message-Id: <20230208194712.never.999-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2428; h=from:subject:message-id; bh=6D7ZqbugXds1gvfLc9iQr1w22R0H9eYp8Iez8DaC/qs=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBj4/xF3tfK5vpxA9509nOQT2yGg5T16Oo5l2e1JsUW iGsIFO+JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY+P8RQAKCRCJcvTf3G3AJk3pD/ 9pD5RZbkzjE0q5GtTBJ5pNbIAKm0Z1qM3Quhtx+IOQhfKbYyCD4Gn83VNS2W+0asUhgAKMq6J5pd+U e+tPGWlnR8pNYgG2PuGjvmlDroDWenmavyyi0a+Q1e/ulK0AUPPkTF+7Q90wykMwiJ/m7Onb3rY5l8 +j6bp1OVYg/wI+uoTSCLbhlb8wszsbWZoTH2G+GLSJ3BI0kOrm4N7yZg6j/uZph0PpzmDrDNsbHYb7 /RTI00+O9J2um4lezpgdes+LzTXUhRF8R9JyzKRbl4bUAHdeJI4fZp15y7qaZDEBrBFd5OS89+YelU 204ZGq+PF4U8Qvh+595ONipxPn+4GzXSxIlGGTncLqeDvyMK9GSOcZqtCNu8+sYqmkGN9Zqol1F9ub Y5kpNsAOiMnYEUaRoLPNpfTKJGZm+/fL/zoxc5vhIBuVc/BnmK6pohdg3qS42JwAj9kwoYNejFyAP1 tGTEm/1bml3vopP0C3nfN9oK/6P4anSO51hITjVTjx2db6NL9o7TFrN9XHaxIeiEXJ9D2rUfrOmeH7 440m6P1QFRL1StuZsoQB5WKyk2jsLma4GdXNylAFcMBi+zxDsjhi8NNembKT4rRhsp5hea9NKxZl0g XCyW205YraGQ6cq/nT3mX5hSqUGeWMyHy9tqmCJWlR6oEl/0sTZ30RFFMPuA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 792702911f581f7793962fbeb99d5c3a1b28f4c3.

Linking no_hash_pointers() to slub_debug has had a chilling effect
on using slub_debug features for security hardening, since system
builders are forced to choose between redzoning and heap address location
exposures. Instead, just require that the "no_hash_pointers" boot param
needs to be used to expose pointers during slub_debug reports.

Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: concord@gentoo.org
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: linux-mm@kvack.org
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/202109200726.2EFEDC5@keescook/
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/kernel.h | 2 --
 lib/vsprintf.c         | 2 +-
 mm/slub.c              | 4 ----
 3 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index fe6efb24d151..e3d9d3879495 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -229,8 +229,6 @@ int sscanf(const char *, const char *, ...);
 extern __scanf(2, 0)
 int vsscanf(const char *, const char *, va_list);
 
-extern int no_hash_pointers_enable(char *str);
-
 extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
 extern unsigned long long memparse(const char *ptr, char **retptr);
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index be71a03c936a..410b4a80a58a 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -2222,7 +2222,7 @@ char *fwnode_string(char *buf, char *end, struct fwnode_handle *fwnode,
 	return widen_string(buf, buf - buf_start, end, spec);
 }
 
-int __init no_hash_pointers_enable(char *str)
+static int __init no_hash_pointers_enable(char *str)
 {
 	if (no_hash_pointers)
 		return 0;
diff --git a/mm/slub.c b/mm/slub.c
index 13459c69095a..63f7337dd433 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5005,10 +5005,6 @@ void __init kmem_cache_init(void)
 	if (debug_guardpage_minorder())
 		slub_max_order = 0;
 
-	/* Print slub debugging pointers without hashing */
-	if (__slub_debug_enabled())
-		no_hash_pointers_enable(NULL);
-
 	kmem_cache_node = &boot_kmem_cache_node;
 	kmem_cache = &boot_kmem_cache;
 
-- 
2.34.1

