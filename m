Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2698F157821
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730539AbgBJNFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:05:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:38940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729184AbgBJMkE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:04 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0B712051A;
        Mon, 10 Feb 2020 12:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338404;
        bh=/glp9sSdbLe3epTTSCqFRgpTWpPljAzDuqmKyRFBIH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y6PSWcRj1D8daXsFeMyWhngvonIn6754Qc0NCAiCTe5mZQwFmE/kZYwkyYvzw/QeP
         ggdDEIrMkoaQG5ac/8BSw3VyuT8fhgpWbEe0KTOFdsJnuls+CEyuEoimyLwj32MX1k
         kEnpIt1k3/nhfU9iBb3n88u4nDXdZYeBrV7No9GM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        "zhangyi (F)" <yi.zhang@huawei.com>, Stable@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.5 105/367] ubifs: Fix deadlock in concurrent bulk-read and writepage
Date:   Mon, 10 Feb 2020 04:30:18 -0800
Message-Id: <20200210122434.083181923@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit f5de5b83303e61b1f3fb09bd77ce3ac2d7a475f2 upstream.

In ubifs, concurrent execution of writepage and bulk read on the same file
may cause ABBA deadlock, for example (Reproduce method see Link):

Process A(Bulk-read starts from page4)         Process B(write page4 back)
  vfs_read                                       wb_workfn or fsync
  ...                                            ...
  generic_file_buffered_read                     write_cache_pages
    ubifs_readpage                                 LOCK(page4)

      ubifs_bulk_read                              ubifs_writepage
        LOCK(ui->ui_mutex)                           ubifs_write_inode

	  ubifs_do_bulk_read                           LOCK(ui->ui_mutex)
	    find_or_create_page(alloc page4)                  ↑
	      LOCK(page4)                   <--     ABBA deadlock occurs!

In order to ensure the serialization execution of bulk read, we can't
remove the big lock 'ui->ui_mutex' in ubifs_bulk_read(). Instead, we
allow ubifs_do_bulk_read() to lock page failed by replacing
find_or_create_page(FGP_LOCK) with
pagecache_get_page(FGP_LOCK | FGP_NOWAIT).

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Suggested-by: zhangyi (F) <yi.zhang@huawei.com>
Cc: <Stable@vger.kernel.org>
Fixes: 4793e7c5e1c ("UBIFS: add bulk-read facility")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206153
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/file.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -786,7 +786,9 @@ static int ubifs_do_bulk_read(struct ubi
 
 		if (page_offset > end_index)
 			break;
-		page = find_or_create_page(mapping, page_offset, ra_gfp_mask);
+		page = pagecache_get_page(mapping, page_offset,
+				 FGP_LOCK|FGP_ACCESSED|FGP_CREAT|FGP_NOWAIT,
+				 ra_gfp_mask);
 		if (!page)
 			break;
 		if (!PageUptodate(page))


