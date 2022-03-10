Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDA574D49C9
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244963AbiCJOeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:34:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343923AbiCJOb3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:31:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474DAD95EF;
        Thu, 10 Mar 2022 06:28:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D686661C0A;
        Thu, 10 Mar 2022 14:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91F6C340E8;
        Thu, 10 Mar 2022 14:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922508;
        bh=5IG58LdHT4xAvpo1TWps4IujYggSLXE7CJz3LAeiwxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a2Hx9S+1ftr7A4s6TptcEyLMAxpf5Yh0UmBqGSjCT8oyi78yLqAk6OIKosv+UviYy
         CSKI3/0e5CnTcJYyIk8ifIg5bnQYQUHkNcE1GNuHuVw+wdDKbpWEhhmd5Wg0Vy6Z0H
         6lewHzM3Y1FA0EbhgJFzQKe1FedbqSKxnBwB6zTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Demi Marie Obenour <demi@invisiblethingslab.com>,
        Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 5.4 22/33] xen/xenbus: dont let xenbus_grant_ring() remove grants in error case
Date:   Thu, 10 Mar 2022 15:19:23 +0100
Message-Id: <20220310140809.393007441@linuxfoundation.org>
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
@@ -366,7 +366,14 @@ int xenbus_grant_ring(struct xenbus_devi
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
@@ -376,23 +383,14 @@ int xenbus_grant_ring(struct xenbus_devi
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
 


