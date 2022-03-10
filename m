Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12244D49F2
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245065AbiCJOeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243742AbiCJO1b (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:27:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D038D6A9;
        Thu, 10 Mar 2022 06:22:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7361AB8254A;
        Thu, 10 Mar 2022 14:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA46FC340E8;
        Thu, 10 Mar 2022 14:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922153;
        bh=vzSF9NLTj2CC/EtyDWRBsEmCrp/t8LoHmGjSgMq5smc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yYil//FhHNQgskWVGMnyLggedC0twC8n6HLEdQKLuwd5JNd7H66Vzr4NwgDzzylGC
         sNT/iA7J1Y0nyAesDzbcuLnkBzsaoriSscdfcXCxWZLAKBvT7ZiU8YXG0i0KEexXc+
         Ybya3Zatq2ojfrJjr6mhNYzqVkvi7FR3U/Sthznw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Demi Marie Obenour <demi@invisiblethingslab.com>,
        Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 4.19 23/33] xen/xenbus: dont let xenbus_grant_ring() remove grants in error case
Date:   Thu, 10 Mar 2022 15:18:50 +0100
Message-Id: <20220310140808.426358398@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140807.749164737@linuxfoundation.org>
References: <20220310140807.749164737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

Commit 3777ea7bac3113005b7180e6b9dadf16d19a5827 upstream.

Letting xenbus_grant_ring() tear down grants in the error case is
problematic, as the other side could already have used these grants.
Calling gnttab_end_foreign_access_ref() without checking success is
resulting in an unclear situation for any caller of xenbus_grant_ring()
as in the error case the memory pages of the ring page might be
partially mapped. Freeing them would risk unwanted foreign access to
them, while not freeing them would leak memory.

In order to remove the need to undo any gnttab_grant_foreign_access()
calls, use gnttab_alloc_grant_references() to make sure no further
error can occur in the loop granting access to the ring pages.

It should be noted that this way of handling removes leaking of
grant entries in the error case, too.

This is CVE-2022-23040 / part of XSA-396.

Reported-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/xenbus/xenbus_client.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -368,7 +368,14 @@ int xenbus_grant_ring(struct xenbus_devi
 		      unsigned int nr_pages, grant_ref_t *grefs)
 {
 	int err;
-	int i, j;
+	unsigned int i;
+	grant_ref_t gref_head;
+
+	err = gnttab_alloc_grant_references(nr_pages, &gref_head);
+	if (err) {
+		xenbus_dev_fatal(dev, err, "granting access to ring page");
+		return err;
+	}
 
 	for (i = 0; i < nr_pages; i++) {
 		unsigned long gfn;
@@ -378,23 +385,14 @@ int xenbus_grant_ring(struct xenbus_devi
 		else
 			gfn = virt_to_gfn(vaddr);
 
-		err = gnttab_grant_foreign_access(dev->otherend_id, gfn, 0);
-		if (err < 0) {
-			xenbus_dev_fatal(dev, err,
-					 "granting access to ring page");
-			goto fail;
-		}
-		grefs[i] = err;
+		grefs[i] = gnttab_claim_grant_reference(&gref_head);
+		gnttab_grant_foreign_access_ref(grefs[i], dev->otherend_id,
+						gfn, 0);
 
 		vaddr = vaddr + XEN_PAGE_SIZE;
 	}
 
 	return 0;
-
-fail:
-	for (j = 0; j < i; j++)
-		gnttab_end_foreign_access_ref(grefs[j], 0);
-	return err;
 }
 EXPORT_SYMBOL_GPL(xenbus_grant_ring);
 


