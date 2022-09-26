Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B5B5EA1B0
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236769AbiIZKzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237094AbiIZKyc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:54:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCF64DF1F;
        Mon, 26 Sep 2022 03:28:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4450560B2F;
        Mon, 26 Sep 2022 10:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E809C433D6;
        Mon, 26 Sep 2022 10:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188072;
        bh=oPft54DHIpY5K6ExZt9M95uV+sjVX2WTHJqXQZDMOqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s2LKr2KID8M8zJqri8VBD91M42KyGdaUbfSITmk4IfBUks/Li2PVxph7O0SBb4a0J
         cy/zhQt7TBwABnw4d62EuGhcDrEml6u8DvL82Gw7dFPqGMTJ2j3+ZxwZ8GwDA484Hi
         Q7BPlfp7/1LFN7v+AYAW1E/zQOSKQBhESCjxXLmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luboslav Pivarc <lpivarc@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/141] vfio/type1: Unpin zero pages
Date:   Mon, 26 Sep 2022 12:10:58 +0200
Message-Id: <20220926100755.663717983@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit 873aefb376bbc0ed1dd2381ea1d6ec88106fdbd4 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_iommu_type1.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0c15cffd5ef1..cd5c8b49d763 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -514,6 +514,18 @@ static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
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
-- 
2.35.1



