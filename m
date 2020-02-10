Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1CD5157930
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbgBJNNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:13:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:34714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729198AbgBJMil (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:41 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 169382051A;
        Mon, 10 Feb 2020 12:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338321;
        bh=3DEs+IjdE9C7q3aypPr9HZy8aOa2B8Kgb1VRuFBIbvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FYxV1muzjex/rlFHV1NQuf+V/OsNrSBFmXoOm4bu/QwoK0RvJLNB4RC0JP1YX2aJy
         HQQj4jVDOr6L8Jso59O/apQHzioSGcZDYoMB35/C6fBCjnL9uOZC5stMCtAP1ZKXB5
         jspwbbB8yIervt58gGRX39EU6L8dOWVB6cT97nWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yishai Hadas <yishaih@mellanox.com>,
        Artemy Kovalyov <artemyko@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH 5.4 252/309] IB/core: Fix ODP get user pages flow
Date:   Mon, 10 Feb 2020 04:33:28 -0800
Message-Id: <20200210122430.754971001@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

commit d07de8bd1709a80a282963ad7b2535148678a9e4 upstream.

The nr_pages argument of get_user_pages_remote() should always be in terms
of the system page size, not the MR page size. Use PAGE_SIZE instead of
umem_odp->page_shift.

Fixes: 403cd12e2cf7 ("IB/umem: Add contiguous ODP support")
Link: https://lore.kernel.org/r/20191222124649.52300-3-leon@kernel.org
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/umem_odp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -632,7 +632,7 @@ int ib_umem_odp_map_dma_pages(struct ib_
 
 	while (bcnt > 0) {
 		const size_t gup_num_pages = min_t(size_t,
-				(bcnt + BIT(page_shift) - 1) >> page_shift,
+				ALIGN(bcnt, PAGE_SIZE) / PAGE_SIZE,
 				PAGE_SIZE / sizeof(struct page *));
 
 		down_read(&owning_mm->mmap_sem);


