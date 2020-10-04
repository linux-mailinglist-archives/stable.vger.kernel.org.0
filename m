Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD4C282C3B
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 20:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgJDSEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Oct 2020 14:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgJDSEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Oct 2020 14:04:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9291C0613CF;
        Sun,  4 Oct 2020 11:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=WbC9hgAcg/kmSfhruAEKvz/UhCG0YVX9Mb6rUn6uioQ=; b=Sas70Pi87VyEThzdZtQqppqRFa
        r7ubnYnhYzuwIusGo49ix97K0EBn/xVxSpN375sGwlJiPpu0UDwrEBZG5FL9eAPEh2veW32n8NBQA
        F3Hop8U7b6l3GoiXeTRkDa0ea/HGXW9X9ky0sI9sSzqyYzHg/4UJWf2/qPTLkd79zhI/6QFjKEhKU
        Ezb2LYypVMi1nZzY49EFZEopszt4Tq1+Q70ZnAZs1oW8la6Z3m6vCkdEy9dP0wpBUntmJrM8JIWKX
        +Ad4cY6H0AFFZGjdbAjNME7za+4lRYqA1SEsUlT5H/3PoKj8xKRgPI49ALhozsg26ra0dIn6vtVtl
        zt9HlwvA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kP8N6-0003ms-7z; Sun, 04 Oct 2020 18:04:32 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, ericvh@gmail.com,
        lucho@ionkov.net, viro@zeniv.linux.org.uk, jlayton@kernel.org,
        idryomov@gmail.com, mark@fasheh.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, linux-btrfs@vger.kernel.org,
        clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        stable@vger.kernel.org
Subject: [PATCH 6/7] btrfs: Promote to unsigned long long before shifting
Date:   Sun,  4 Oct 2020 19:04:27 +0100
Message-Id: <20201004180428.14494-7-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201004180428.14494-1-willy@infradead.org>
References: <20201004180428.14494-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 32-bit systems, this shift will overflow for files larger than 4GB.

Cc: stable@vger.kernel.org
Fixes: 53b381b3abeb ("Btrfs: RAID5 and RAID6")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/btrfs/raid56.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 255490f42b5d..5ee0a53301bd 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1089,7 +1089,7 @@ static int rbio_add_io_page(struct btrfs_raid_bio *rbio,
 	u64 disk_start;
 
 	stripe = &rbio->bbio->stripes[stripe_nr];
-	disk_start = stripe->physical + (page_index << PAGE_SHIFT);
+	disk_start = stripe->physical + ((loff_t)page_index << PAGE_SHIFT);
 
 	/* if the device is missing, just fail this stripe */
 	if (!stripe->dev->bdev)
-- 
2.28.0

