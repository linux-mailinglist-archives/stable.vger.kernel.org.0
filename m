Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B558F658138
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbiL1Q0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234706AbiL1QZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:25:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5070D1C104
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:22:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F14E3B816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D71C433D2;
        Wed, 28 Dec 2022 16:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244555;
        bh=kTAUy8Qzi8QrrkKuCj6OjCd6nTzlyaATe0MpzQjGmzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mF9j8h9epZmBKc0xoJgp71RR1m7uUjC/SOrI1fLjYfUgfOymeizX5+sgy+8Q705sG
         k6zK4F/fBM1U8v66uH/wBEJEqFCcV1H3gXUxGJScPO+/3u8vCrLi8UZ+oM//5U6pDA
         cC5UoQVBzlKg38todLSZVTkUg/WF3KksO33wSsRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Avihai Horon <avihaih@nvidia.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0693/1146] vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps
Date:   Wed, 28 Dec 2022 15:37:12 +0100
Message-Id: <20221228144348.965734810@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>

[ Upstream commit f38044e5ef58ad0346fdabd7027ea5c1e1a3b624 ]

iova_bitmap_set() doesn't consider the end of the page boundary when the
first bitmap page offset isn't zero, and wrongly changes the consecutive
page right after. Consequently this leads to missing dirty pages from
reported by the device as seen from the VMM.

The current logic iterates over a given number of base pages and clamps it
to the remaining indexes to iterate in the last page.  Instead of having to
consider extra pages to pin (e.g. first and extra pages), just handle the
first page as its own range and let the rest of the bitmap be handled as if
it was base page aligned.

This is done by changing iova_bitmap_mapped_remaining() to return PAGE_SIZE
- pgoff (on the first bitmap page), and leads to pgoff being set to 0 on
following iterations.

Fixes: 58ccf0190d19 ("vfio: Add an IOVA bitmap support")
Reported-by: Avihai Horon <avihaih@nvidia.com>
Tested-by: Avihai Horon <avihaih@nvidia.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Link: https://lore.kernel.org/r/20221025193114.58695-3-joao.m.martins@oracle.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/iova_bitmap.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/iova_bitmap.c b/drivers/vfio/iova_bitmap.c
index 6631e8befe1b..2dd65f040127 100644
--- a/drivers/vfio/iova_bitmap.c
+++ b/drivers/vfio/iova_bitmap.c
@@ -295,11 +295,15 @@ void iova_bitmap_free(struct iova_bitmap *bitmap)
  */
 static unsigned long iova_bitmap_mapped_remaining(struct iova_bitmap *bitmap)
 {
-	unsigned long remaining;
+	unsigned long remaining, bytes;
+
+	/* Cap to one page in the first iteration, if PAGE_SIZE unaligned. */
+	bytes = !bitmap->mapped.pgoff ? bitmap->mapped.npages << PAGE_SHIFT :
+					PAGE_SIZE - bitmap->mapped.pgoff;
 
 	remaining = bitmap->mapped_total_index - bitmap->mapped_base_index;
 	remaining = min_t(unsigned long, remaining,
-	      (bitmap->mapped.npages << PAGE_SHIFT) / sizeof(*bitmap->bitmap));
+			  bytes / sizeof(*bitmap->bitmap));
 
 	return remaining;
 }
-- 
2.35.1



