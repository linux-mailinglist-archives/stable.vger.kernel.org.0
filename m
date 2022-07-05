Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D845D566AD8
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbiGEMCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbiGEMB3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:01:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF74D1582A;
        Tue,  5 Jul 2022 05:01:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C8C1B817CC;
        Tue,  5 Jul 2022 12:01:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848E6C341C7;
        Tue,  5 Jul 2022 12:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022485;
        bh=16qWtBAtgeBJRudyGfkIKclqH02YQfiB4Ii4vSjWRng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QL/fHu42HQQFw+kWLZ/6ObX7lK0YjVBFIwWX4AGPMFPx1N02bhwHeZiT/NsD3XcU5
         W3I9dP2BKvmDf8zzY68ZowKFHjxWBQYGSLHZ4U1F3ZjwrJttmWA/NkWrsn/rZrKzR5
         jZ2Y5Cln6ocXM8VMgjsY2xtVEk5zxrqrnIsI2szQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.14 23/29] xen/blkfront: fix leaking data in shared pages
Date:   Tue,  5 Jul 2022 13:58:11 +0200
Message-Id: <20220705115607.027328709@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115606.333669144@linuxfoundation.org>
References: <20220705115606.333669144@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Pau Monne <roger.pau@citrix.com>

commit 2f446ffe9d737e9a844b97887919c4fda18246e7 upstream.

When allocating pages to be used for shared communication with the
backend always zero them, this avoids leaking unintended data present
on the pages.

This is CVE-2022-26365, part of XSA-403.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/xen-blkfront.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -302,7 +302,7 @@ static int fill_grant_buffer(struct blkf
 			goto out_of_memory;
 
 		if (info->feature_persistent) {
-			granted_page = alloc_page(GFP_NOIO);
+			granted_page = alloc_page(GFP_NOIO | __GFP_ZERO);
 			if (!granted_page) {
 				kfree(gnt_list_entry);
 				goto out_of_memory;
@@ -1744,7 +1744,7 @@ static int setup_blkring(struct xenbus_d
 	for (i = 0; i < info->nr_ring_pages; i++)
 		rinfo->ring_ref[i] = GRANT_INVALID_REF;
 
-	sring = alloc_pages_exact(ring_size, GFP_NOIO);
+	sring = alloc_pages_exact(ring_size, GFP_NOIO | __GFP_ZERO);
 	if (!sring) {
 		xenbus_dev_fatal(dev, -ENOMEM, "allocating shared ring");
 		return -ENOMEM;
@@ -2266,7 +2266,8 @@ static int blkfront_setup_indirect(struc
 
 		BUG_ON(!list_empty(&rinfo->indirect_pages));
 		for (i = 0; i < num; i++) {
-			struct page *indirect_page = alloc_page(GFP_NOIO);
+			struct page *indirect_page = alloc_page(GFP_NOIO |
+			                                        __GFP_ZERO);
 			if (!indirect_page)
 				goto out_of_memory;
 			list_add(&indirect_page->lru, &rinfo->indirect_pages);


