Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67A6E5EA421
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238235AbiIZLks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238241AbiIZLkP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:40:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A2B43622;
        Mon, 26 Sep 2022 03:45:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECECCB80977;
        Mon, 26 Sep 2022 10:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C07C433D6;
        Mon, 26 Sep 2022 10:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189054;
        bh=3cnKQViAsr59QOz45cel/NeBAZU0KF9t1dv9+BKZaow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cSw+2tGhR23fKIH5Y6Qz7sltUe2K7mwFPHV98fye5IS7N6h2YVRFql4BQeWuksSoE
         4ZdLC76X0DZiOTBNQUzwXdv8ENWmmfjjJNHvic3Dg7QcqGH2ZFsGJmIahXhR0RvQC/
         2pvzRjv7uU4LepUkyADbXvdrURWH1+okLknL9tGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sander Eikelenboom <linux@eikelenboom.it>,
        Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Subject: [PATCH 5.19 058/207] xen/xenbus: fix xenbus_setup_ring()
Date:   Mon, 26 Sep 2022 12:10:47 +0200
Message-Id: <20220926100809.208451245@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit ce6b8ccdef959ba86b2711e090e84a987a000bf7 upstream.

Commit 4573240f0764 ("xen/xenbus: eliminate xenbus_grant_ring()")
introduced an error for initialization of multi-page rings.

Cc: stable@vger.kernel.org
Fixes: 4573240f0764 ("xen/xenbus: eliminate xenbus_grant_ring()")
Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/xenbus/xenbus_client.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index d5f3f763717e..d4b251925796 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -382,9 +382,10 @@ int xenbus_setup_ring(struct xenbus_device *dev, gfp_t gfp, void **vaddr,
 	unsigned long ring_size = nr_pages * XEN_PAGE_SIZE;
 	grant_ref_t gref_head;
 	unsigned int i;
+	void *addr;
 	int ret;
 
-	*vaddr = alloc_pages_exact(ring_size, gfp | __GFP_ZERO);
+	addr = *vaddr = alloc_pages_exact(ring_size, gfp | __GFP_ZERO);
 	if (!*vaddr) {
 		ret = -ENOMEM;
 		goto err;
@@ -401,13 +402,15 @@ int xenbus_setup_ring(struct xenbus_device *dev, gfp_t gfp, void **vaddr,
 		unsigned long gfn;
 
 		if (is_vmalloc_addr(*vaddr))
-			gfn = pfn_to_gfn(vmalloc_to_pfn(vaddr[i]));
+			gfn = pfn_to_gfn(vmalloc_to_pfn(addr));
 		else
-			gfn = virt_to_gfn(vaddr[i]);
+			gfn = virt_to_gfn(addr);
 
 		grefs[i] = gnttab_claim_grant_reference(&gref_head);
 		gnttab_grant_foreign_access_ref(grefs[i], dev->otherend_id,
 						gfn, 0);
+
+		addr += XEN_PAGE_SIZE;
 	}
 
 	return 0;
-- 
2.37.3



