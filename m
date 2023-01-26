Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2751E67D5EA
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 21:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbjAZUHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 15:07:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjAZUHk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 15:07:40 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C262B0A4;
        Thu, 26 Jan 2023 12:07:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=JzBJfIDuJxgLM6ciBuV8d8uL0pRgiX7zCopdrnYh1tA=; b=aYC7folrZF7BT0AE63Id9B1VOq
        Yw4JMILcB6T9obNoUkplrvU80D5/ogqAhcrydQwJ7kDAhCjSIcRnolxUBjm6x4asbkR/X7k3xgbJr
        Jpaku2xxcRjq2J3ZaR6JUmSA4t/A7b2NA4w6+0kErP08/Eqb2zxIE4no73xKOY0/+cdLN0qsAH7ev
        bbpTIGbZ/edafMwk/seG2Fhow2nUmhjQJgO2K8/P3ziRBHF0I2o+BzApeiC3MMV2brjHmkME+5DYJ
        BOs6iKHNuSbp8tWtkaP6+piDDmMiTuDqyEF57n9aNxa0DezAGYPwCA1AIbnKI0VEdTxLVVXvVsJ6v
        gSP6QANw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pL8Wv-00738y-AQ; Thu, 26 Jan 2023 20:07:29 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Ira Weiny <ira.weiny@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        stable@vger.kernel.org
Subject: [PATCH] highmem: Round down the address passed to kunmap_flush_on_unmap()
Date:   Thu, 26 Jan 2023 20:07:27 +0000
Message-Id: <20230126200727.1680362-1-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We already round down the address in kunmap_local_indexed() which is
the other implementation of __kunmap_local().  The only implementation
of kunmap_flush_on_unmap() is PA-RISC which is expecting a page-aligned
address.  This may be causing PA-RISC to be flushing the wrong addresses
currently.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Fixes: 298fa1ad5571 ("highmem: Provide generic variant of kmap_atomic*")
Cc: stable@vger.kernel.org
---
 include/linux/highmem-internal.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/highmem-internal.h b/include/linux/highmem-internal.h
index 034b1106d022..e098f38422af 100644
--- a/include/linux/highmem-internal.h
+++ b/include/linux/highmem-internal.h
@@ -200,7 +200,7 @@ static inline void *kmap_local_pfn(unsigned long pfn)
 static inline void __kunmap_local(const void *addr)
 {
 #ifdef ARCH_HAS_FLUSH_ON_KUNMAP
-	kunmap_flush_on_unmap(addr);
+	kunmap_flush_on_unmap(PTR_ALIGN_DOWN(addr, PAGE_SIZE));
 #endif
 }
 
@@ -227,7 +227,7 @@ static inline void *kmap_atomic_pfn(unsigned long pfn)
 static inline void __kunmap_atomic(const void *addr)
 {
 #ifdef ARCH_HAS_FLUSH_ON_KUNMAP
-	kunmap_flush_on_unmap(addr);
+	kunmap_flush_on_unmap(PTR_ALIGN_DOWN(addr, PAGE_SIZE));
 #endif
 	pagefault_enable();
 	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-- 
2.35.1

