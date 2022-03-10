Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5864D49A0
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbiCJOVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244322AbiCJOTJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:19:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0C6172888;
        Thu, 10 Mar 2022 06:16:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0C5661C39;
        Thu, 10 Mar 2022 14:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7CCC340E8;
        Thu, 10 Mar 2022 14:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646921760;
        bh=tIRJjRTSlbPh8kjeK5uRXo4H5ulTD8w7NIMSEQd1/4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rM5eZslWnLbHGCR2nRmXY1rxKTdTenjL2H6uZ5aG3tsSwJFX1e9vsbfIYWp11wosN
         85y7VtgOz2/sDkNTkjxTBOVlx6qjiDVy/e8fMMaT8XO7H3yt95kBw7LHw+W/s0QB4Y
         kOlJsyKVv7vmwuzQeo11RkbheZXopsV9xq4rsQDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Demi Marie Obenour <demi@invisiblethingslab.com>,
        Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 4.9 31/38] xen/grant-table: add gnttab_try_end_foreign_access()
Date:   Thu, 10 Mar 2022 15:13:44 +0100
Message-Id: <20220310140809.044695427@linuxfoundation.org>
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
@@ -377,11 +377,21 @@ static void gnttab_add_deferred(grant_re
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


