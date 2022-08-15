Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD41059393E
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343912AbiHOTPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241407AbiHOTNi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:13:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF1C51A17;
        Mon, 15 Aug 2022 11:37:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9574760FC4;
        Mon, 15 Aug 2022 18:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96941C433C1;
        Mon, 15 Aug 2022 18:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588654;
        bh=0RS1MmN86UN8i8zMV6nez1c6juO8rb3/MzSELu75oQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yXCbIHLW23xNZasefVzcR2ce4671xRPR+00MMaMGxel6uzRBgD33td8wD5Xw59RII
         tbfhZ6lY+9agXCCBPx3IanFKWPrZ5z0hx0/MbVp9xFN3uSxvjqoYKfApsoIj4CVp4m
         o30XJgi+EBKcGUVezkG3pS60E8KDuVafvAXiqkoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 473/779] intel_th: msu: Fix vmalloced buffers
Date:   Mon, 15 Aug 2022 20:01:57 +0200
Message-Id: <20220815180357.503818464@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

[ Upstream commit ac12ad3ccf6d386e64a9d6a890595a2509d24edd ]

After commit f5ff79fddf0e ("dma-mapping: remove CONFIG_DMA_REMAP") there's
a chance of DMA buffer getting allocated via vmalloc(), which messes up
the mmapping code:

> RIP: msc_mmap_fault [intel_th_msu]
> Call Trace:
>  <TASK>
>  __do_fault
>  do_fault
...

Fix this by accounting for vmalloc possibility.

Fixes: ba39bd830605 ("intel_th: msu: Switch over to scatterlist")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Link: https://lore.kernel.org/r/20220705082637.59979-4-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/intel_th/msu.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/hwtracing/intel_th/msu.c b/drivers/hwtracing/intel_th/msu.c
index 432ade0842f6..d95d916b4682 100644
--- a/drivers/hwtracing/intel_th/msu.c
+++ b/drivers/hwtracing/intel_th/msu.c
@@ -1069,6 +1069,16 @@ msc_buffer_set_uc(struct msc *msc) {}
 static inline void msc_buffer_set_wb(struct msc *msc) {}
 #endif /* CONFIG_X86 */
 
+static struct page *msc_sg_page(struct scatterlist *sg)
+{
+	void *addr = sg_virt(sg);
+
+	if (is_vmalloc_addr(addr))
+		return vmalloc_to_page(addr);
+
+	return sg_page(sg);
+}
+
 /**
  * msc_buffer_win_alloc() - alloc a window for a multiblock mode
  * @msc:	MSC device
@@ -1139,7 +1149,7 @@ static void __msc_buffer_win_free(struct msc *msc, struct msc_window *win)
 	int i;
 
 	for_each_sg(win->sgt->sgl, sg, win->nr_segs, i) {
-		struct page *page = sg_page(sg);
+		struct page *page = msc_sg_page(sg);
 
 		page->mapping = NULL;
 		dma_free_coherent(msc_dev(win->msc)->parent->parent, PAGE_SIZE,
@@ -1403,7 +1413,7 @@ static struct page *msc_buffer_get_page(struct msc *msc, unsigned long pgoff)
 	pgoff -= win->pgoff;
 
 	for_each_sg(win->sgt->sgl, sg, win->nr_segs, blk) {
-		struct page *page = sg_page(sg);
+		struct page *page = msc_sg_page(sg);
 		size_t pgsz = PFN_DOWN(sg->length);
 
 		if (pgoff < pgsz)
-- 
2.35.1



