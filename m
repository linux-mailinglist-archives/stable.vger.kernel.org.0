Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1D44D4BD6
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 16:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243353AbiCJOXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243637AbiCJOXI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:23:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F91154735;
        Thu, 10 Mar 2022 06:21:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6BB1B82678;
        Thu, 10 Mar 2022 14:20:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C76C36AF7;
        Thu, 10 Mar 2022 14:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922058;
        bh=4sRvDsU0YzxJTpWFP0plNUR7N8iCGw3geGeUgJ8shXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=boqfHfUIWlKEI+wj+pPx22k07efwQZQiwuCMyQFGjGCPrlJ5/IQVbqATuL5gU3XDG
         A/EBJSANxkapwLdF42kRolDHggWQrnedKCXLHButKbN//ZfqJBUoyQ26U67+2veT22
         99xtW8TQK4aNPzel6Dr1MlGbGGyDO4HREcKqWn4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Demi Marie Obenour <demi@invisiblethingslab.com>,
        Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 4.14 23/31] xen/grant-table: add gnttab_try_end_foreign_access()
Date:   Thu, 10 Mar 2022 15:18:36 +0100
Message-Id: <20220310140808.215242873@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140807.524313448@linuxfoundation.org>
References: <20220310140807.524313448@linuxfoundation.org>
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

Commit 6b1775f26a2da2b05a6dc8ec2b5d14e9a4701a1a upstream.

Add a new grant table function gnttab_try_end_foreign_access(), which
will remove and free a grant if it is not in use.

Its main use case is to either free a grant if it is no longer in use,
or to take some other action if it is still in use. This other action
can be an error exit, or (e.g. in the case of blkfront persistent grant
feature) some special handling.

This is CVE-2022-23036, CVE-2022-23038 / part of XSA-396.

Reported-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/grant-table.c |   14 ++++++++++++--
 include/xen/grant_table.h |   12 ++++++++++++
 2 files changed, 24 insertions(+), 2 deletions(-)

--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -378,11 +378,21 @@ static void gnttab_add_deferred(grant_re
 	       what, ref, page ? page_to_pfn(page) : -1);
 }
 
+int gnttab_try_end_foreign_access(grant_ref_t ref)
+{
+	int ret = _gnttab_end_foreign_access_ref(ref, 0);
+
+	if (ret)
+		put_free_entry(ref);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(gnttab_try_end_foreign_access);
+
 void gnttab_end_foreign_access(grant_ref_t ref, int readonly,
 			       unsigned long page)
 {
-	if (gnttab_end_foreign_access_ref(ref, readonly)) {
-		put_free_entry(ref);
+	if (gnttab_try_end_foreign_access(ref)) {
 		if (page != 0)
 			put_page(virt_to_page(page));
 	} else
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -97,10 +97,22 @@ int gnttab_end_foreign_access_ref(grant_
  * access has been ended, free the given page too.  Access will be ended
  * immediately iff the grant entry is not in use, otherwise it will happen
  * some time later.  page may be 0, in which case no freeing will occur.
+ * Note that the granted page might still be accessed (read or write) by the
+ * other side after gnttab_end_foreign_access() returns, so even if page was
+ * specified as 0 it is not allowed to just reuse the page for other
+ * purposes immediately.
  */
 void gnttab_end_foreign_access(grant_ref_t ref, int readonly,
 			       unsigned long page);
 
+/*
+ * End access through the given grant reference, iff the grant entry is
+ * no longer in use.  In case of success ending foreign access, the
+ * grant reference is deallocated.
+ * Return 1 if the grant entry was freed, 0 if it is still in use.
+ */
+int gnttab_try_end_foreign_access(grant_ref_t ref);
+
 int gnttab_grant_foreign_transfer(domid_t domid, unsigned long pfn);
 
 unsigned long gnttab_end_foreign_transfer_ref(grant_ref_t ref);


