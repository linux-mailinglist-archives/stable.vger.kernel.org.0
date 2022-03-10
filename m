Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5274D4BB4
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 16:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243380AbiCJOWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244160AbiCJOS7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:18:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A671B251A;
        Thu, 10 Mar 2022 06:15:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BA2261C67;
        Thu, 10 Mar 2022 14:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFDDC340EB;
        Thu, 10 Mar 2022 14:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646921730;
        bh=0SlhBY9FVbky4lNAtCvq+QSM2Rt7IiNUXbD6lBysKLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UFdYgh6FsYyGQ7q7XfxNsSGATpZUv/rCFqabsEK7FGXO2merKw+w/O3ZXHFDFAEDZ
         aHhTa3QxPMH93gLRz/8YzcqWyEZjqjIeb7KpeZDfgl8cW4xiaDSOXt+dYfWW65lupV
         Alb7/h4JzYqaKX/+3p1XR6YxyG4H4+Ea+f+/qLbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Demi Marie Obenour <demi@invisiblethingslab.com>,
        Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 4.9 35/38] xen/gntalloc: dont use gnttab_query_foreign_access()
Date:   Thu, 10 Mar 2022 15:13:48 +0100
Message-Id: <20220310140809.157981695@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140808.136149678@linuxfoundation.org>
References: <20220310140808.136149678@linuxfoundation.org>
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
@@ -166,20 +166,14 @@ undo:
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
@@ -193,21 +187,16 @@ static void __del_gref(struct gntalloc_g
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
 


