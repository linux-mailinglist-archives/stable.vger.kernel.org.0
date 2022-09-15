Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A306F5B9D23
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 16:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiIOObn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 10:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiIOObn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 10:31:43 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300B989934;
        Thu, 15 Sep 2022 07:31:42 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D1CD31F8AF;
        Thu, 15 Sep 2022 14:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1663252300; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=dzoAgu6mheUOzlynwIyePFbncbuBp9hucJwC4AGAEMg=;
        b=cBu5DlTCREcpIg2AL2xFilshrjAlZTvrjdO687YcesK9GrOmCA581P3FxwwuYLrZ+YkHpE
        Sf7gTfCFQhBDBDudEhF0MI7TmSLcA60AMgyUI28s9e2hH5T3IFxj25WBCY7sZwFQXroC3E
        yL1W20RErwozixvr7renhuJpHHkbSjI=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9DA73133B6;
        Thu, 15 Sep 2022 14:31:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id DRsmJUw3I2OVegAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 15 Sep 2022 14:31:40 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        stable@vger.kernel.org, Sander Eikelenboom <linux@eikelenboom.it>
Subject: [PATCH] xen/xenbus: fix xenbus_setup_ring()
Date:   Thu, 15 Sep 2022 16:31:37 +0200
Message-Id: <20220915143137.1763-1-jgross@suse.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 4573240f0764 ("xen/xenbus: eliminate xenbus_grant_ring()")
introduced an error for initialization of multi-page rings.

Cc: stable@vger.kernel.org
Fixes: 4573240f0764 ("xen/xenbus: eliminate xenbus_grant_ring()")
Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/xen/xenbus/xenbus_client.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index d5f3f763717e..caa5c5c32f8e 100644
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
+		addr += PAGE_SIZE;
 	}
 
 	return 0;
-- 
2.35.3

