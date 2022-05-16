Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 760FE52907F
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346419AbiEPULY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351115AbiEPUCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:02:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B66ECE0;
        Mon, 16 May 2022 12:59:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7122B81613;
        Mon, 16 May 2022 19:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C80C385AA;
        Mon, 16 May 2022 19:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652731148;
        bh=wOIDV8q4QcRZSsv7ZtGikMXYBHgsMA3h+B5yP9HDWMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OZwehqRumQwM1rAwTJ3uBu20HlAFG3AAWw3KM60adhSLGvohZdbhJyHcMAnzvxsFQ
         WAIh0Gxm3ew9DOJVzG1CAK2TzPAD889QGavwSCsjZV6V6wF8/cYZqtOcZLy/axw+Xi
         hL/jRszV1i5m8KFa2JlNUVFKM0XqOk9tAddIJklI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Marco Elver <elver@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.17 114/114] mm/kfence: reset PG_slab and memcg_data before freeing __kfence_pool
Date:   Mon, 16 May 2022 21:37:28 +0200
Message-Id: <20220516193628.745366269@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hyeonggon Yoo <42.hyeyoo@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kfence/core.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -515,6 +515,7 @@ static bool __init kfence_init_pool(void
 {
 	unsigned long addr = (unsigned long)__kfence_pool;
 	struct page *pages;
+	char *p;
 	int i;
 
 	if (!__kfence_pool)
@@ -598,6 +599,16 @@ err:
 	 * fails for the first page, and therefore expect addr==__kfence_pool in
 	 * most failure cases.
 	 */
+	for (p = (char *)addr; p < __kfence_pool + KFENCE_POOL_SIZE; p += PAGE_SIZE) {
+		struct slab *slab = virt_to_slab(p);
+
+		if (!slab)
+			continue;
+#ifdef CONFIG_MEMCG
+		slab->memcg_data = 0;
+#endif
+		__folio_clear_slab(slab_folio(slab));
+	}
 	memblock_free_late(__pa(addr), KFENCE_POOL_SIZE - (addr - (unsigned long)__kfence_pool));
 	__kfence_pool = NULL;
 	return false;


