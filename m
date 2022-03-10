Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87C9C4D4ADF
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243583AbiCJOet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:34:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244978AbiCJOeI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:34:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9651812221E;
        Thu, 10 Mar 2022 06:31:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DBF961D3B;
        Thu, 10 Mar 2022 14:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BF8C340F4;
        Thu, 10 Mar 2022 14:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922688;
        bh=T/mHRVpyB/klvNBKNmoZm1usKzPz4/NT8r60/gXuNsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7o8GwaK5p5l7M60YDR2n4foJGL+yO99RfErkaT5Tv0W5bDKuY2iTmf0uDEfR6N2I
         kLlq8tbRp4FeS5TOUtI8I6Q8GGba/xwMohJVO7LKavc/hsCl538yOCCAWFCjgS8owh
         PAUruURAMwFJaDUm/fWC0eq30e6ke6tT9bwR7faM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Demi Marie Obenour <demi@invisiblethingslab.com>,
        Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 5.15 52/58] xen/gntalloc: dont use gnttab_query_foreign_access()
Date:   Thu, 10 Mar 2022 15:19:41 +0100
Message-Id: <20220310140814.461312296@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140812.983088611@linuxfoundation.org>
References: <20220310140812.983088611@linuxfoundation.org>
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

Commit d3b6372c5881cb54925212abb62c521df8ba4809 upstream.

Using gnttab_query_foreign_access() is unsafe, as it is racy by design.

The use case in the gntalloc driver is not needed at all. While at it
replace the call of gnttab_end_foreign_access_ref() with a call of
gnttab_end_foreign_access(), which is what is really wanted there. In
case the grant wasn't used due to an allocation failure, just free the
grant via gnttab_free_grant_reference().

This is CVE-2022-23039 / part of XSA-396.

Reported-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/gntalloc.c |   25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

--- a/drivers/xen/gntalloc.c
+++ b/drivers/xen/gntalloc.c
@@ -169,20 +169,14 @@ undo:
 		__del_gref(gref);
 	}
 
-	/* It's possible for the target domain to map the just-allocated grant
-	 * references by blindly guessing their IDs; if this is done, then
-	 * __del_gref will leave them in the queue_gref list. They need to be
-	 * added to the global list so that we can free them when they are no
-	 * longer referenced.
-	 */
-	if (unlikely(!list_empty(&queue_gref)))
-		list_splice_tail(&queue_gref, &gref_list);
 	mutex_unlock(&gref_mutex);
 	return rc;
 }
 
 static void __del_gref(struct gntalloc_gref *gref)
 {
+	unsigned long addr;
+
 	if (gref->notify.flags & UNMAP_NOTIFY_CLEAR_BYTE) {
 		uint8_t *tmp = kmap(gref->page);
 		tmp[gref->notify.pgoff] = 0;
@@ -196,21 +190,16 @@ static void __del_gref(struct gntalloc_g
 	gref->notify.flags = 0;
 
 	if (gref->gref_id) {
-		if (gnttab_query_foreign_access(gref->gref_id))
-			return;
-
-		if (!gnttab_end_foreign_access_ref(gref->gref_id, 0))
-			return;
-
-		gnttab_free_grant_reference(gref->gref_id);
+		if (gref->page) {
+			addr = (unsigned long)page_to_virt(gref->page);
+			gnttab_end_foreign_access(gref->gref_id, 0, addr);
+		} else
+			gnttab_free_grant_reference(gref->gref_id);
 	}
 
 	gref_size--;
 	list_del(&gref->next_gref);
 
-	if (gref->page)
-		__free_page(gref->page);
-
 	kfree(gref);
 }
 


