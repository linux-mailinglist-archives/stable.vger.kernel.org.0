Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033AF34C305
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 07:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhC2F3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 01:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbhC2F32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 01:29:28 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E41C061574;
        Sun, 28 Mar 2021 22:29:27 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id w8so5450497pjf.4;
        Sun, 28 Mar 2021 22:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nwW3wqGlwvgCl7fK73mXwZYZab2mQtuORLVwBoAbxgY=;
        b=qDos5l8euTHvWyys+1Vbt06YDZopfjoD9EcakCMdojFTtzovx7hLCAEQS4vRpkUyvJ
         x3qeS8Q/L6n4GeatU2IQfCR2Nd5/5HSoiJ8o3UdYXI0qrrN/7V7nTLFdtBe/khMr8wmH
         0ZNw72Q39445uDG9f+62zDK+4UImr0LprtNmr2Z846j90bPrwpO68riVvWqjIW4cpaV9
         6TV3P0JrRSfeQrmxC+5S+Rr1Wi+Ocn2rNO7fpLsdex50yJQvrT/wO8w9L5OBeWLTp+1g
         xUPeIR2ehpP2L77FbwuM3689Asewnp2fGIRdu2rUuzqQXAarSam9HKVByVYSDMUyCD1y
         14Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nwW3wqGlwvgCl7fK73mXwZYZab2mQtuORLVwBoAbxgY=;
        b=Fy4WFuUaEjg2Ha04vhqX1quuJtEBzkWCR3BJg3pHVdxoQjEf6XyN6mWW4fZsUW49a1
         ncnwoqmVPqzD3A4/G6PGRuMwBj4o7RNUlIXcFkZsL/9s+C0w/m7Fw9cOO9Sgp48vxS3b
         IhGr+yshqNh9PBb5y1JZ26Sx2awYsbndEY0yizVxlNABZc1yIX9I+mVrew8mxOipfhYz
         J6tdbLH6dI2ya1OxZRlXCrSCm/IzrpJsyukiUguE0ltd8fsj29Lt5TAEwjpsP7xswSRo
         pU6les0edH7NaUCnjCsHZM3AHhxVJ7vCmILz2dVvPms9QujU2oR7xEK6xj5LeTxRQl+F
         i5hw==
X-Gm-Message-State: AOAM530qGO/Q/iTxfLT4WH41ILsonUqAGvpt94yDxWdkP7Kyvrhn8LmH
        JYGGH9cayyGKeKbJKAzEfYc=
X-Google-Smtp-Source: ABdhPJxSp0W3ypZlEfQWK22Bf8igEvCO5VyssScOVHbZclh1AP0AIw0oNX+mIFRaapWFIcMO4Retdw==
X-Received: by 2002:a17:90b:94c:: with SMTP id dw12mr24734883pjb.119.1616995766893;
        Sun, 28 Mar 2021 22:29:26 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id y9sm15897460pgc.9.2021.03.28.22.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 22:29:26 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, stable@vger.kernel.org
Subject: [PATCH v2] mm: fix race by making init_zero_pfn() early_initcall
Date:   Sun, 28 Mar 2021 22:29:22 -0700
Message-Id: <20210329052922.1130493-1-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210329052426.1130040-1-ilya.lipnitskiy@gmail.com>
References: <20210329052426.1130040-1-ilya.lipnitskiy@gmail.com>
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

ML discussion: https://lore.kernel.org/lkml/CALCv0x2YqOXEAy2Q=hafjhHCtTHVodChv1qpM=niAXOpqEbt7w@mail.gmail.com/

Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: stable@vger.kernel.org
---
 mm/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 46ef306375bd..a8bbc4fc121f 100644
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

