Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A434D49FA
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244798AbiCJOd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:33:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343909AbiCJOb3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:31:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668C4E33B7;
        Thu, 10 Mar 2022 06:28:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E084D61D22;
        Thu, 10 Mar 2022 14:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71DBC340EB;
        Thu, 10 Mar 2022 14:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922484;
        bh=ns34xK5Ax7X9DdpK7iJHoh+YVWxk0ZHepyBDIJGlKaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jnagCjU/RQac+8JuJNjX/CVT9Oyl9egvLECcYLYBeipNTwcwgfSvmjCFueks/e2Pq
         0lg0p4RO1hOsfeGEZRvzRdKpIiRLO7SibMuR917LUarytLt5n7kPe7X2NgS4f+Fq/G
         0rzfCWqWtQNzBiLeD3MzZogOvO8rGXid4NLo7jmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Simon Gaiser <simon@invisiblethingslab.com>,
        Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 5.4 31/33] xen/gnttab: fix gnttab_end_foreign_access() without page specified
Date:   Thu, 10 Mar 2022 15:19:32 +0100
Message-Id: <20220310140809.655025121@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140808.741682643@linuxfoundation.org>
References: <20220310140808.741682643@linuxfoundation.org>
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

Commit 42baefac638f06314298087394b982ead9ec444b upstream.

gnttab_end_foreign_access() is used to free a grant reference and
optionally to free the associated page. In case the grant is still in
use by the other side processing is being deferred. This leads to a
problem in case no page to be freed is specified by the caller: the
caller doesn't know that the page is still mapped by the other side
and thus should not be used for other purposes.

The correct way to handle this situation is to take an additional
reference to the granted page in case handling is being deferred and
to drop that reference when the grant reference could be freed
finally.

This requires that there are no users of gnttab_end_foreign_access()
left directly repurposing the granted page after the call, as this
might result in clobbered data or information leaks via the not yet
freed grant reference.

This is part of CVE-2022-23041 / XSA-396.

Reported-by: Simon Gaiser <simon@invisiblethingslab.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/grant-table.c |   36 +++++++++++++++++++++++++++++-------
 include/xen/grant_table.h |    7 ++++++-
 2 files changed, 35 insertions(+), 8 deletions(-)

--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -134,6 +134,10 @@ struct gnttab_ops {
 	 * return the frame.
 	 */
 	unsigned long (*end_foreign_transfer_ref)(grant_ref_t ref);
+	/*
+	 * Read the frame number related to a given grant reference.
+	 */
+	unsigned long (*read_frame)(grant_ref_t ref);
 };
 
 struct unmap_refs_callback_data {
@@ -331,6 +335,16 @@ int gnttab_end_foreign_access_ref(grant_
 }
 EXPORT_SYMBOL_GPL(gnttab_end_foreign_access_ref);
 
+static unsigned long gnttab_read_frame_v1(grant_ref_t ref)
+{
+	return gnttab_shared.v1[ref].frame;
+}
+
+static unsigned long gnttab_read_frame_v2(grant_ref_t ref)
+{
+	return gnttab_shared.v2[ref].full_page.frame;
+}
+
 struct deferred_entry {
 	struct list_head list;
 	grant_ref_t ref;
@@ -360,12 +374,9 @@ static void gnttab_handle_deferred(struc
 		spin_unlock_irqrestore(&gnttab_list_lock, flags);
 		if (_gnttab_end_foreign_access_ref(entry->ref, entry->ro)) {
 			put_free_entry(entry->ref);
-			if (entry->page) {
-				pr_debug("freeing g.e. %#x (pfn %#lx)\n",
-					 entry->ref, page_to_pfn(entry->page));
-				put_page(entry->page);
-			} else
-				pr_info("freeing g.e. %#x\n", entry->ref);
+			pr_debug("freeing g.e. %#x (pfn %#lx)\n",
+				 entry->ref, page_to_pfn(entry->page));
+			put_page(entry->page);
 			kfree(entry);
 			entry = NULL;
 		} else {
@@ -390,9 +401,18 @@ static void gnttab_handle_deferred(struc
 static void gnttab_add_deferred(grant_ref_t ref, bool readonly,
 				struct page *page)
 {
-	struct deferred_entry *entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
+	struct deferred_entry *entry;
+	gfp_t gfp = (in_atomic() || irqs_disabled()) ? GFP_ATOMIC : GFP_KERNEL;
 	const char *what = KERN_WARNING "leaking";
 
+	entry = kmalloc(sizeof(*entry), gfp);
+	if (!page) {
+		unsigned long gfn = gnttab_interface->read_frame(ref);
+
+		page = pfn_to_page(gfn_to_pfn(gfn));
+		get_page(page);
+	}
+
 	if (entry) {
 		unsigned long flags;
 
@@ -1284,6 +1304,7 @@ static const struct gnttab_ops gnttab_v1
 	.update_entry			= gnttab_update_entry_v1,
 	.end_foreign_access_ref		= gnttab_end_foreign_access_ref_v1,
 	.end_foreign_transfer_ref	= gnttab_end_foreign_transfer_ref_v1,
+	.read_frame			= gnttab_read_frame_v1,
 };
 
 static const struct gnttab_ops gnttab_v2_ops = {
@@ -1295,6 +1316,7 @@ static const struct gnttab_ops gnttab_v2
 	.update_entry			= gnttab_update_entry_v2,
 	.end_foreign_access_ref		= gnttab_end_foreign_access_ref_v2,
 	.end_foreign_transfer_ref	= gnttab_end_foreign_transfer_ref_v2,
+	.read_frame			= gnttab_read_frame_v2,
 };
 
 static bool gnttab_need_v2(void)
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -100,7 +100,12 @@ int gnttab_end_foreign_access_ref(grant_
  * Note that the granted page might still be accessed (read or write) by the
  * other side after gnttab_end_foreign_access() returns, so even if page was
  * specified as 0 it is not allowed to just reuse the page for other
- * purposes immediately.
+ * purposes immediately. gnttab_end_foreign_access() will take an additional
+ * reference to the granted page in this case, which is dropped only after
+ * the grant is no longer in use.
+ * This requires that multi page allocations for areas subject to
+ * gnttab_end_foreign_access() are done via alloc_pages_exact() (and freeing
+ * via free_pages_exact()) in order to avoid high order pages.
  */
 void gnttab_end_foreign_access(grant_ref_t ref, int readonly,
 			       unsigned long page);


