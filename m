Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B57B52B7EF
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 12:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235131AbiERKcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 06:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235098AbiERKcp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 06:32:45 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712581FCCE
        for <stable@vger.kernel.org>; Wed, 18 May 2022 03:32:44 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id n10so1584302pjh.5
        for <stable@vger.kernel.org>; Wed, 18 May 2022 03:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :in-reply-to;
        bh=O3ZONFugKJackGrk1AAH+YtoKGnYNUHWfG4bi/hMzLg=;
        b=Ym6k6UeUUiWWTMqP8ADBVtJH4v0euA53T1uFnytl2ZJYf6OertBy+RNw2PB/a9RnQ3
         jzDPKyYu8ikNGuA4uUjOV8ECqN2xMGPoQk7n6X361JKUeUp5s3y8dXfn9F+se94lN4iI
         Z9Z4FnWGUcQEFSRrEW/cqFvhVlXMeXm9NfREPMPPE2rFYyTXl6iGGj80jw76/bjaSeml
         hBuMy3b4mB2/njQkAOt/YOSKkdgPKXTwUtxmSX5xTEH1STbM5uGYyUZCCWqq69fNZiQ3
         sjfS124Avf/wqkA7ZWf9a8/KcTBdWpYPPBuiTcfPbDckbXX9K1GGYU6PXwzLrjZdywr5
         X1wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:in-reply-to;
        bh=O3ZONFugKJackGrk1AAH+YtoKGnYNUHWfG4bi/hMzLg=;
        b=x/9o2D0QULAIxz6kIurHpmtsRsdionLwhFDQkSB0NsF3Xc8+/n8U6dZj6j1PHkaJzX
         4oEdLSK6YRJ8JnmeAlLFJZCfl+RfMaCQj7uActW+xuQAhpa/26uhgAELlnZ1jWJqRziv
         tgqM5Qp2fRXEJ4lM+HIG/lQjo8yrPRj30vz/c//8mbdMRS2rx7glP8IEJ5eS7erLCLnv
         cQtHKH2AXDqkZYwdEHmOUPj3zLQ0N5yYS3xazcTdV2aeqzMlc39kvQhnDPQ9RnIkoea4
         8BRNUEUOiry728HWBhs8KLm8d771PPgtRmnez8KRw0Lsk4KWawwKfYUDqfmOx0PtpLWp
         aqAg==
X-Gm-Message-State: AOAM533YugYf/xkBsODYLdB1S9o7w914NklmYYLuIUo1cFVqPgX0oK1d
        TZsjG1ngskRUMQv7OAdr+iM=
X-Google-Smtp-Source: ABdhPJzP/GCdAWkBFCAnXrzxMdiMfk26ZYOcOwoRiSKiLEv+F3VOaNYFKgWs40w892D/YwKBJ0MIUw==
X-Received: by 2002:a17:902:e3d4:b0:161:888e:e707 with SMTP id r20-20020a170902e3d400b00161888ee707mr12819528ple.118.1652869964005;
        Wed, 18 May 2022 03:32:44 -0700 (PDT)
Received: from hyeyoo ([114.29.24.243])
        by smtp.gmail.com with ESMTPSA id d7-20020a63f247000000b003f5912ba179sm1195816pgk.58.2022.05.18.03.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 03:32:43 -0700 (PDT)
Date:   Wed, 18 May 2022 19:32:37 +0900
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     akpm@linux-foundation.org, dvyukov@google.com, elver@google.com,
        glider@google.com, songmuchun@bytedance.com, stable@vger.kernel.org
Subject: [PATCH 5.15.y] mm/kfence: reset PG_slab and memcg_data before
 freeing __kfence_pool
Message-ID: <YoTLReuLMhkLhyb8@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165270762342182@kroah.com>
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 2839b0999c20c9f6bf353849c69370e121e2fa1a upstream.

When kfence fails to initialize kfence pool, it frees the pool.  But it
does not reset memcg_data and PG_slab flag.

Below is a BUG because of this. Let's fix it by resetting memcg_data
and PG_slab flag before free.

[    0.089149] BUG: Bad page state in process swapper/0  pfn:3d8e06
[    0.089149] page:ffffea46cf638180 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x3d8e06
[    0.089150] memcg:ffffffff94a475d1
[    0.089150] flags: 0x17ffffc0000200(slab|node=0|zone=2|lastcpupid=0x1fffff)
[    0.089151] raw: 0017ffffc0000200 ffffea46cf638188 ffffea46cf638188 0000000000000000
[    0.089152] raw: 0000000000000000 0000000000000000 00000000ffffffff ffffffff94a475d1
[    0.089152] page dumped because: page still charged to cgroup
[    0.089153] Modules linked in:
[    0.089153] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G    B   W         5.18.0-rc1+ #965
[    0.089154] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
[    0.089154] Call Trace:
[    0.089155]  <TASK>
[    0.089155]  dump_stack_lvl+0x49/0x5f
[    0.089157]  dump_stack+0x10/0x12
[    0.089158]  bad_page.cold+0x63/0x94
[    0.089159]  check_free_page_bad+0x66/0x70
[    0.089160]  __free_pages_ok+0x423/0x530
[    0.089161]  __free_pages_core+0x8e/0xa0
[    0.089162]  memblock_free_pages+0x10/0x12
[    0.089164]  memblock_free_late+0x8f/0xb9
[    0.089165]  kfence_init+0x68/0x92
[    0.089166]  start_kernel+0x789/0x992
[    0.089167]  x86_64_start_reservations+0x24/0x26
[    0.089168]  x86_64_start_kernel+0xa9/0xaf
[    0.089170]  secondary_startup_64_no_verify+0xd5/0xdb
[    0.089171]  </TASK>

Link: https://lkml.kernel.org/r/YnPG3pQrqfcgOlVa@hyeyoo
Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Fixes: 8f0b36497303 ("mm: kfence: fix objcgs vector allocation")
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[42.hyeyoo@gmail.com: backport - use struct page]
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
---
 mm/kfence/core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 66076d8742b7..d25202766fbb 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -510,6 +510,7 @@ static bool __init kfence_init_pool(void)
 	unsigned long addr = (unsigned long)__kfence_pool;
 	struct page *pages;
 	int i;
+	char *p;
 
 	if (!__kfence_pool)
 		return false;
@@ -592,6 +593,16 @@ static bool __init kfence_init_pool(void)
 	 * fails for the first page, and therefore expect addr==__kfence_pool in
 	 * most failure cases.
 	 */
+	for (p = (char *)addr; p < __kfence_pool + KFENCE_POOL_SIZE; p += PAGE_SIZE) {
+		struct page *page = virt_to_page(p);
+
+		if (!PageSlab(page))
+			continue;
+#ifdef CONFIG_MEMCG
+		page->memcg_data = 0;
+#endif
+		__ClearPageSlab(page);
+	}
 	memblock_free_late(__pa(addr), KFENCE_POOL_SIZE - (addr - (unsigned long)__kfence_pool));
 	__kfence_pool = NULL;
 	return false;
-- 
2.32.0
