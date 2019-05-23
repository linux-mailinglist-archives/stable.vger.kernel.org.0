Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B77F2888C
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391524AbfEWT1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:27:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389926AbfEWT1H (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:27:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6123D21841;
        Thu, 23 May 2019 19:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639626;
        bh=qqtzSOErxlsiyQ+y/Ki7LFxgaKu2TqUXZ3UHTW02tIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D5lN31LUs39FjX+liGDtCprWQcslWuMNyGx5/QzVdaE0juCeuYBBWw+fRMSiiBza0
         vpeJ8ukhHzJSQTwLf3N9kAYfN0zgFLrQX/5PmmEhJKpOaKEMPdvHN0yyicmPguqWcW
         uK6C55eTyVozCnY46Bv1FX38rOz2CuAZv9j4+H7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.1 035/122] brd: re-enable __GFP_HIGHMEM in brd_insert_page()
Date:   Thu, 23 May 2019 21:05:57 +0200
Message-Id: <20190523181709.506827080@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

commit f6b50160a06d4a0d6a3999ab0c5aec4f52dba248 upstream.

__GFP_HIGHMEM is disabled if dax is enabled on brd, however
dax support for brd has been removed since commit (7a862fbbdec6
"brd: remove dax support"), so restore __GFP_HIGHMEM in
brd_insert_page().

Also remove the no longer applicable comments about DAX and highmem.

Cc: stable@vger.kernel.org
Fixes: 7a862fbbdec6 ("brd: remove dax support")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/brd.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -96,13 +96,8 @@ static struct page *brd_insert_page(stru
 	/*
 	 * Must use NOIO because we don't want to recurse back into the
 	 * block or filesystem layers from page reclaim.
-	 *
-	 * Cannot support DAX and highmem, because our ->direct_access
-	 * routine for DAX must return memory that is always addressable.
-	 * If DAX was reworked to use pfns and kmap throughout, this
-	 * restriction might be able to be lifted.
 	 */
-	gfp_flags = GFP_NOIO | __GFP_ZERO;
+	gfp_flags = GFP_NOIO | __GFP_ZERO | __GFP_HIGHMEM;
 	page = alloc_page(gfp_flags);
 	if (!page)
 		return NULL;


