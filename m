Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37949154C36
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 20:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgBFTZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 14:25:44 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34257 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727836AbgBFTZo (ORCPT
        <rfc822;Stable@vger.kernel.org>); Thu, 6 Feb 2020 14:25:44 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id BF1AE22083;
        Thu,  6 Feb 2020 14:25:43 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 06 Feb 2020 14:25:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=pYi9Q3
        ahTtvEXS7ORVdAYnC2EuMxbwPNto5V+4yx0L4=; b=QTfehTZf6G+BFXxXMuRgm/
        2tX0D9aopsTgWyY8HtsHaRFYn7me0xE7xGpe/Kkh8diJLEoR+yaeJewqCtqp4koV
        IkRgT1WF7vavqQDminukS3TD/LGFfiSy42sK55GG9jU2b5ssvavYI1ZoIjPzXMNR
        7nOmberVdONEZoWtofDN9IF0hSTWz3GMAbyNEn4GQ9kHTsfm/Kdcz8V5DiL+Uf+q
        aWgGbHaEB/jmeTgVm2oE9ZDpQ0CRIyt61Ey2dQQA4Sl3QJbaxTxuL97VBsfxejfN
        E6DtxUVEt4+DTSB8lU3avjR8Vv2Z1Ew6v+/IEVYe6Tr5otssWSYgbzWjVIJPRNcQ
        ==
X-ME-Sender: <xms:N2g8Xr3Fd3Dmk3cmDjIYI5dhzVHgW-Mm4z8w1vIJMn2uJG_K9Lk6QQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheefgdduvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:N2g8Xi5v9gUBcte0pCQbhKAxqxE2yYiNApmTr5dUUctT-RnA4BKgPA>
    <xmx:N2g8Xi1lDVb8icufTdQQ9mbmz7ndLT2YTxoCor_I74gOdUbi1DXaAA>
    <xmx:N2g8Xqa3icLZTth7LdzcGQBri_NHxcLXHA_yy-KSJlq7AFbhdWi2-g>
    <xmx:N2g8XkUF0CL1TJlGOlqdTFqWl4QZrBQI8HgEUlG8DKhYTwreuQHJiQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0990B3280062;
        Thu,  6 Feb 2020 14:25:42 -0500 (EST)
Subject: FAILED: patch "[PATCH] ubifs: Fix deadlock in concurrent bulk-read and writepage" failed to apply to 4.9-stable tree
To:     chengzhihao1@huawei.com, Stable@vger.kernel.org, richard@nod.at,
        yi.zhang@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 06 Feb 2020 20:20:48 +0100
Message-ID: <1581016848106213@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f5de5b83303e61b1f3fb09bd77ce3ac2d7a475f2 Mon Sep 17 00:00:00 2001
From: Zhihao Cheng <chengzhihao1@huawei.com>
Date: Sat, 11 Jan 2020 17:50:36 +0800
Subject: [PATCH] ubifs: Fix deadlock in concurrent bulk-read and writepage
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index cd52585c8f4f..c649048fcc81 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -786,7 +786,9 @@ static int ubifs_do_bulk_read(struct ubifs_info *c, struct bu_info *bu,
 
 		if (page_offset > end_index)
 			break;
-		page = find_or_create_page(mapping, page_offset, ra_gfp_mask);
+		page = pagecache_get_page(mapping, page_offset,
+				 FGP_LOCK|FGP_ACCESSED|FGP_CREAT|FGP_NOWAIT,
+				 ra_gfp_mask);
 		if (!page)
 			break;
 		if (!PageUptodate(page))

