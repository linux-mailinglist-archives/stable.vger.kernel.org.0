Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5322C6AEC2F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbjCGRxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbjCGRwn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:52:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC1DA5938
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:47:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1421E6150E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1DDC4339E;
        Tue,  7 Mar 2023 17:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211225;
        bh=ZONAirZ6zfNf1iTb0FxKJx91w3mgVP51sUbKEawi4b4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nBC09UOkPpVYixQ478qZTsLdUDr/bCUDJTZ9aU3aXh8V42qipbTXvzOVjryeq5Js6
         41LZXDvnPg+j3FK0ZCDg7o2XRQ+yqiiXL26ssJJIBs55MZLKWpXdd/i+skZJ9voiMV
         G6qmMQVQIZ+TX9IN1nSkTmAe/yUCps9ROozdryNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.2 0763/1001] s390/extmem: return correct segment type in __segment_load()
Date:   Tue,  7 Mar 2023 17:58:55 +0100
Message-Id: <20230307170054.872194038@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

commit 8c42dd78df148c90e48efff204cce38743906a79 upstream.

Commit f05f62d04271f ("s390/vmem: get rid of memory segment list")
reshuffled the call to vmem_add_mapping() in __segment_load(), which now
overwrites rc after it was set to contain the segment type code.

As result, __segment_load() will now always return 0 on success, which
corresponds to the segment type code SEG_TYPE_SW, i.e. a writeable
segment. This results in a kernel crash when loading a read-only segment
as dcssblk block device, and trying to write to it.

Instead of reshuffling code again, make sure to return the segment type
on success, and also describe this rather delicate and unexpected logic
in the function comment. Also initialize new segtype variable with
invalid value, to prevent possible future confusion.

Fixes: f05f62d04271 ("s390/vmem: get rid of memory segment list")
Cc: <stable@vger.kernel.org> # 5.9+
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/extmem.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/arch/s390/mm/extmem.c
+++ b/arch/s390/mm/extmem.c
@@ -289,15 +289,17 @@ segment_overlaps_others (struct dcss_seg
 
 /*
  * real segment loading function, called from segment_load
+ * Must return either an error code < 0, or the segment type code >= 0
  */
 static int
 __segment_load (char *name, int do_nonshared, unsigned long *addr, unsigned long *end)
 {
 	unsigned long start_addr, end_addr, dummy;
 	struct dcss_segment *seg;
-	int rc, diag_cc;
+	int rc, diag_cc, segtype;
 
 	start_addr = end_addr = 0;
+	segtype = -1;
 	seg = kmalloc(sizeof(*seg), GFP_KERNEL | GFP_DMA);
 	if (seg == NULL) {
 		rc = -ENOMEM;
@@ -326,9 +328,9 @@ __segment_load (char *name, int do_nonsh
 	seg->res_name[8] = '\0';
 	strlcat(seg->res_name, " (DCSS)", sizeof(seg->res_name));
 	seg->res->name = seg->res_name;
-	rc = seg->vm_segtype;
-	if (rc == SEG_TYPE_SC ||
-	    ((rc == SEG_TYPE_SR || rc == SEG_TYPE_ER) && !do_nonshared))
+	segtype = seg->vm_segtype;
+	if (segtype == SEG_TYPE_SC ||
+	    ((segtype == SEG_TYPE_SR || segtype == SEG_TYPE_ER) && !do_nonshared))
 		seg->res->flags |= IORESOURCE_READONLY;
 
 	/* Check for overlapping resources before adding the mapping. */
@@ -386,7 +388,7 @@ __segment_load (char *name, int do_nonsh
  out_free:
 	kfree(seg);
  out:
-	return rc;
+	return rc < 0 ? rc : segtype;
 }
 
 /*


