Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE3F15C177
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbgBMPXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:23:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:34696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727604AbgBMPX3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:23:29 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2693F24689;
        Thu, 13 Feb 2020 15:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607408;
        bh=8m95RymEldAFxdMNFNOh5ebIIqj+Gyn1fmABkibbhcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qqp4Ds2eSKaMe01ZDQHWVv++O4+QxUMhOuGoAjjinxWlLGaGa9wq0HKW/GwNW/Xfh
         wqtb+hAFnnFFfE4C6h9/kCMuQscioChobqAgMBxKMUQR1LuY/WnWu+T+o2WSaCZyqG
         1gvN6e3UtMzDbHXnrf5FQMEhJV0v57xiy9mqV0sQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyunchul Lee <cheol.lee@lge.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 028/116] ubifs: Change gfp flags in page allocation for bulk read
Date:   Thu, 13 Feb 2020 07:19:32 -0800
Message-Id: <20200213151853.797208951@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151842.259660170@linuxfoundation.org>
References: <20200213151842.259660170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hyunchul Lee <cheol.lee@lge.com>

[ Upstream commit 480a1a6a3ef6fb6be4cd2f37b34314fbf64867dd ]

In low memory situations, page allocations for bulk read
can kill applications for reclaiming memory, and print an
failure message when allocations are failed.
Because bulk read is just an optimization, we don't have
to do these and can stop page allocations.

Though this siutation happens rarely, add __GFP_NORETRY
to prevent from excessive memory reclaim and killing
applications, and __GFP_WARN to suppress this failure
message.

For this, Use readahead_gfp_mask for gfp flags when
allocating pages.

Signed-off-by: Hyunchul Lee <cheol.lee@lge.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index b4fbeefba246a..f2e6162f8e656 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -721,6 +721,7 @@ static int ubifs_do_bulk_read(struct ubifs_info *c, struct bu_info *bu,
 	int err, page_idx, page_cnt, ret = 0, n = 0;
 	int allocate = bu->buf ? 0 : 1;
 	loff_t isize;
+	gfp_t ra_gfp_mask = readahead_gfp_mask(mapping) & ~__GFP_FS;
 
 	err = ubifs_tnc_get_bu_keys(c, bu);
 	if (err)
@@ -782,8 +783,7 @@ static int ubifs_do_bulk_read(struct ubifs_info *c, struct bu_info *bu,
 
 		if (page_offset > end_index)
 			break;
-		page = find_or_create_page(mapping, page_offset,
-					   GFP_NOFS | __GFP_COLD);
+		page = find_or_create_page(mapping, page_offset, ra_gfp_mask);
 		if (!page)
 			break;
 		if (!PageUptodate(page))
-- 
2.20.1



