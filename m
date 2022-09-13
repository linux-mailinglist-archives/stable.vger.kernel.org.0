Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F855B6FBA
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233100AbiIMOQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbiIMOP4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:15:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E60661D91;
        Tue, 13 Sep 2022 07:11:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2680AB80EFA;
        Tue, 13 Sep 2022 14:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743B7C433D6;
        Tue, 13 Sep 2022 14:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078264;
        bh=5ujSDjKiuhpYD2kWZ7mh/qlDxjQ4aMmV92EDRTWZ1A8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N8RZyH0EtpNx8bozKTIQgA31yGFaNPHWGQY8iORLq/kE90A0dIy92uG+SYf9217xB
         sZZH7LEx+Zkl3jZbo9FNWy/n3Jen+QCsole5FG41d+r/iYrvHSLUBQwQrMimYYVlhe
         JumxvqPiMMqMFb2zSdIfGSzc/Sj8gvsRDQ+YVnWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luboslav Pivarc <lpivarc@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5.19 047/192] vfio/type1: Unpin zero pages
Date:   Tue, 13 Sep 2022 16:02:33 +0200
Message-Id: <20220913140412.274137766@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

commit 873aefb376bbc0ed1dd2381ea1d6ec88106fdbd4 upstream.

There's currently a reference count leak on the zero page.  We increment
the reference via pin_user_pages_remote(), but the page is later handled
as an invalid/reserved page, therefore it's not accounted against the
user and not unpinned by our put_pfn().

Introducing special zero page handling in put_pfn() would resolve the
leak, but without accounting of the zero page, a single user could
still create enough mappings to generate a reference count overflow.

The zero page is always resident, so for our purposes there's no reason
to keep it pinned.  Therefore, add a loop to walk pages returned from
pin_user_pages_remote() and unpin any zero pages.

Cc: stable@vger.kernel.org
Reported-by: Luboslav Pivarc <lpivarc@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/166182871735.3518559.8884121293045337358.stgit@omen
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/vfio_iommu_type1.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -557,6 +557,18 @@ static int vaddr_get_pfns(struct mm_stru
 	ret = pin_user_pages_remote(mm, vaddr, npages, flags | FOLL_LONGTERM,
 				    pages, NULL, NULL);
 	if (ret > 0) {
+		int i;
+
+		/*
+		 * The zero page is always resident, we don't need to pin it
+		 * and it falls into our invalid/reserved test so we don't
+		 * unpin in put_pfn().  Unpin all zero pages in the batch here.
+		 */
+		for (i = 0 ; i < ret; i++) {
+			if (unlikely(is_zero_pfn(page_to_pfn(pages[i]))))
+				unpin_user_page(pages[i]);
+		}
+
 		*pfn = page_to_pfn(pages[0]);
 		goto done;
 	}


