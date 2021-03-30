Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81A534E042
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 06:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbhC3Emk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 00:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhC3EmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Mar 2021 00:42:19 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B49C061762;
        Mon, 29 Mar 2021 21:42:19 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id c17so11306390pfn.6;
        Mon, 29 Mar 2021 21:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7XBGBCLGcd6jdeufkWyLn6OBYh592BOUVPsq+lu71i0=;
        b=Vygq34wPb7+UzByt2369faApEohqd60E3RSFIUb1Z1QbIwiphEgUnWeAQ0BoPid3BT
         VaxMEVqGwpsQ7lL5n5GtF5lGiigNnp/56e6TcIWEW3QDVAaU72z+OG/Vw9QFYn9MddPA
         FfnyY3fbBg31/Ars6kL5kyWTi7D1HCi1VwlexHkLb7Zt9GqohfAPVGwIG8NZXFyR7/3K
         mXWNABEekT6GN36In5EN5jyEl6PUIGgwpkeUNzTyM3HAwpjpVXJDIRb0l8b8W3r/6KcN
         B2XORMzTy7L7pGIgoIbMZMHRHaRfNyv76T0K5m70QiOJGIa0c3vEbXTdLuB8RQhquIuO
         mSYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7XBGBCLGcd6jdeufkWyLn6OBYh592BOUVPsq+lu71i0=;
        b=tYDzOm387s/V+8xBLTOq1gQAHjiUMGWBSwhH6HBS73YhIX6XxX95ZCawzqKZZZRCXB
         hGlcuLA5P+aMdoNj8ApVOcb5vmKeuH+AlKrpcczzkuScAM61GG9BNxtP6OGq2si9j+9e
         +E0UGLK/1xPomIn8+VGY/5ra1RW++4fmtjJZKuLJHzha19a2AvEIKbQWts5ql/dQJ2bV
         UlDA9QmK8RPNMb4BtCtD/jT+mAkQufUULBmm7mqrjNEdQJYUO0RsSII3zX6wML+1kWoO
         yswPSGyb8TFsm8e3ahIGTboXHKyZpoTPGH7YdYK+1Y2lQuBVxn+Sd46Z+K/NmB+EMTLk
         M1vw==
X-Gm-Message-State: AOAM530b2zzX+nhwhu6I3jDFoL0JzIQTjUTiSSLt8bvgRhsOuzkhNoQs
        YuCpPP9zaUjR/EZ6pGBjqCg=
X-Google-Smtp-Source: ABdhPJxthKmowRyhe+SE73pWx+30k04VTBD0GqTw/G/pn/0+WVOHdTz0QV5DPzRHemxlRMII+089ZA==
X-Received: by 2002:a63:5c07:: with SMTP id q7mr26924245pgb.52.1617079338546;
        Mon, 29 Mar 2021 21:42:18 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id i4sm19627979pfo.14.2021.03.29.21.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 21:42:18 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Hugh Dickins <hughd@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, stable@vger.kernel.org
Subject: [PATCH v3] mm: fix race by making init_zero_pfn() early_initcall
Date:   Mon, 29 Mar 2021 21:42:08 -0700
Message-Id: <20210330044208.8305-1-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210329052922.1130493-1-ilya.lipnitskiy@gmail.com>
References: <20210329052922.1130493-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There are code paths that rely on zero_pfn to be fully initialized
before core_initcall. For example, wq_sysfs_init() is a core_initcall
function that eventually results in a call to kernel_execve, which
causes a page fault with a subsequent mmput. If zero_pfn is not
initialized by then it may not get cleaned up properly and result in an
error:
  BUG: Bad rss-counter state mm:(ptrval) type:MM_ANONPAGES val:1

Here is an analysis of the race as seen on a MIPS device. On this
particular MT7621 device (Ubiquiti ER-X), zero_pfn is PFN 0 until
initialized, at which point it becomes PFN 5120:
  1. wq_sysfs_init calls into kobject_uevent_env at core_initcall:
       [<80340dc8>] kobject_uevent_env+0x7e4/0x7ec
       [<8033f8b8>] kset_register+0x68/0x88
       [<803cf824>] bus_register+0xdc/0x34c
       [<803cfac8>] subsys_virtual_register+0x34/0x78
       [<8086afb0>] wq_sysfs_init+0x1c/0x4c
       [<80001648>] do_one_initcall+0x50/0x1a8
       [<8086503c>] kernel_init_freeable+0x230/0x2c8
       [<8066bca0>] kernel_init+0x10/0x100
       [<80003038>] ret_from_kernel_thread+0x14/0x1c

  2. kobject_uevent_env() calls call_usermodehelper_exec() which executes
     kernel_execve asynchronously.

  3. Memory allocations in kernel_execve cause a page fault, bumping the
     MM reference counter:
       [<8015adb4>] add_mm_counter_fast+0xb4/0xc0
       [<80160d58>] handle_mm_fault+0x6e4/0xea0
       [<80158aa4>] __get_user_pages.part.78+0x190/0x37c
       [<8015992c>] __get_user_pages_remote+0x128/0x360
       [<801a6d9c>] get_arg_page+0x34/0xa0
       [<801a7394>] copy_string_kernel+0x194/0x2a4
       [<801a880c>] kernel_execve+0x11c/0x298
       [<800420f4>] call_usermodehelper_exec_async+0x114/0x194

  4. In case zero_pfn has not been initialized yet, zap_pte_range does
     not decrement the MM_ANONPAGES RSS counter and the BUG message is
     triggered shortly afterwards when __mmdrop checks the ref counters:
       [<800285e8>] __mmdrop+0x98/0x1d0
       [<801a6de8>] free_bprm+0x44/0x118
       [<801a86a8>] kernel_execve+0x160/0x1d8
       [<800420f4>] call_usermodehelper_exec_async+0x114/0x194
       [<80003198>] ret_from_kernel_thread+0x14/0x1c

To avoid races such as described above, initialize init_zero_pfn at
early_initcall level. Depending on the architecture, ZERO_PAGE is either
constant or gets initialized even earlier, at paging_init, so there is
no issue with initializing zero_pfn earlier.

Discussion: https://lkml.kernel.org/r/CALCv0x2YqOXEAy2Q=hafjhHCtTHVodChv1qpM=niAXOpqEbt7w@mail.gmail.com

Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: stable@vger.kernel.org
---
 mm/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 5c3b29d3af66..e66b11ac1659 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -166,7 +166,7 @@ static int __init init_zero_pfn(void)
 	zero_pfn = page_to_pfn(ZERO_PAGE(0));
 	return 0;
 }
-core_initcall(init_zero_pfn);
+early_initcall(init_zero_pfn);
 
 void mm_trace_rss_stat(struct mm_struct *mm, int member, long count)
 {
-- 
2.31.0

