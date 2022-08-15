Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCDD559423F
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349318AbiHOVr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349290AbiHOVpJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:45:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FCE8C9E91;
        Mon, 15 Aug 2022 12:30:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7ED1B81062;
        Mon, 15 Aug 2022 19:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FC2C433C1;
        Mon, 15 Aug 2022 19:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591799;
        bh=kQSvD+paUr+cZU1TDKWmkofASbgYNIP6QBT9xrztMWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QmunClIVxO2c+TZJ7bv9Aim/mwwqUoXZEMD9wIFki4qqoLXxiXHqb6y/2nSRX4VK8
         0IUxH/peA1Ye93K5s02AUXiw1UbTjWL6EaA7yWOEbuj+lMuCq1AfPLxUlG23Vbdx+r
         GdTHDj0tkfzll2evXvGQfH8k1zwUpavf30V4KLrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0683/1095] mm/memremap: fix memunmap_pages() race with get_dev_pagemap()
Date:   Mon, 15 Aug 2022 20:01:22 +0200
Message-Id: <20220815180457.629161015@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit 1e57ffb6e3fd9583268c6462c4e3853575b21701 ]

Think about the below scene:

 CPU1			CPU2
 memunmap_pages
   percpu_ref_exit
     __percpu_ref_exit
       free_percpu(percpu_count);
         /* percpu_count is freed here! */
			 get_dev_pagemap
			   xa_load(&pgmap_array, PHYS_PFN(phys))
			     /* pgmap still in the pgmap_array */
			   percpu_ref_tryget_live(&pgmap->ref)
			     if __ref_is_percpu
			       /* __PERCPU_REF_ATOMIC_DEAD not set yet */
			       this_cpu_inc(*percpu_count)
			         /* access freed percpu_count here! */
      ref->percpu_count_ptr = __PERCPU_REF_ATOMIC_DEAD;
        /* too late... */
   pageunmap_range

To fix the issue, do percpu_ref_exit() after pgmap_array is emptied. So
we won't do percpu_ref_tryget_live() against a being freed percpu_ref.

Link: https://lkml.kernel.org/r/20220609121305.2508-1-linmiaohe@huawei.com
Fixes: b7b3c01b1915 ("mm/memremap_pages: support multiple ranges per invocation")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memremap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memremap.c b/mm/memremap.c
index e11653fd348c..2c1130486d28 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -141,10 +141,10 @@ void memunmap_pages(struct dev_pagemap *pgmap)
 	for (i = 0; i < pgmap->nr_range; i++)
 		percpu_ref_put_many(&pgmap->ref, pfn_len(pgmap, i));
 	wait_for_completion(&pgmap->done);
-	percpu_ref_exit(&pgmap->ref);
 
 	for (i = 0; i < pgmap->nr_range; i++)
 		pageunmap_range(pgmap, i);
+	percpu_ref_exit(&pgmap->ref);
 
 	WARN_ONCE(pgmap->altmap.alloc, "failed to free all reserved pages\n");
 	devmap_managed_enable_put(pgmap);
-- 
2.35.1



