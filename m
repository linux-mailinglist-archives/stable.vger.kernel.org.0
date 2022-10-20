Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A4F606B5B
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 00:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiJTWjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 18:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiJTWjh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 18:39:37 -0400
Received: from p3plwbeout18-05.prod.phx3.secureserver.net (p3plsmtp18-05-2.prod.phx3.secureserver.net [173.201.193.190])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B1B12767
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 15:39:25 -0700 (PDT)
Received: from mailex.mailcore.me ([94.136.40.145])
        by :WBEOUT: with ESMTP
        id le9XojAFew7vale9YoyLo6; Thu, 20 Oct 2022 15:36:40 -0700
X-CMAE-Analysis: v=2.4 cv=f5eNuM+M c=1 sm=1 tr=0 ts=6351cd78
 a=7e6w4QD8YWtpVJ/7+iiidw==:117 a=84ok6UeoqCVsigPHarzEiQ==:17
 a=ggZhUymU-5wA:10 a=Qawa6l4ZSaYA:10 a=FXvPX3liAAAA:8 a=VwQbUJbxAAAA:8
 a=z1XB94rXoAV2oHx9HPIA:9 a=UObqyxdv-6Yh2QiB9mM_:22 a=AjGcO6oz07-iQ99wixmX:22
X-SECURESERVER-ACCT: phillip@squashfs.org.uk  
X-SID:  le9XojAFew7va
Received: from 82-69-79-175.dsl.in-addr.zen.co.uk ([82.69.79.175] helo=phoenix.fritz.box)
        by smtp12.mailcore.me with esmtpa (Exim 4.94.2)
        (envelope-from <phillip@squashfs.org.uk>)
        id 1ole9W-0006zQ-Jd; Thu, 20 Oct 2022 23:36:38 +0100
From:   Phillip Lougher <phillip@squashfs.org.uk>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc:     hsinyi@chromium.org, regressions@leemhuis.info,
        regressions@lists.linux.dev, dimitri.ledkov@canonical.com,
        michael.vogt@canonical.com, phillip.lougher@gmail.com,
        ogra@ubuntu.com, olivier.tilloy@canonical.com,
        Phillip Lougher <phillip@squashfs.org.uk>,
        stable@vger.kernel.org
Subject: [PATCH 2/3] squashfs: fix extending readahead beyond end of file
Date:   Thu, 20 Oct 2022 23:36:15 +0100
Message-Id: <20221020223616.7571-3-phillip@squashfs.org.uk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221020223616.7571-1-phillip@squashfs.org.uk>
References: <20221020223616.7571-1-phillip@squashfs.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mailcore-Auth: 439999529
X-Mailcore-Domain: 1394945
X-123-reg-Authenticated:  phillip@squashfs.org.uk  
X-Originating-IP: 82.69.79.175
X-CMAE-Envelope: MS4xfLVqZTEL6y7WsBl/SilQq+U1I+1q4XI20YGsxlSG6b6FvIDoNoiBLvr05x4IIAc/kR2HNK4sLo6vrmVcrjy5dV+7dIO+qm/RXszzjmVbMt2lTGdGRXkt
 +S4wdVtVa/HvyQDkUxjhOraK7i8NuQbTctmdMwT7yl5whWtsElFhZ85ctsMi7jMtpt5DLuWxEhqqNakxtLBqZdx1X6f50IyoalsrllYkslRC3u3gzuOKpBsh
 I9ugfyuiK3q9ok9o873C6A==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The readahead code will try to extend readahead to the entire
size of the Squashfs data block.

But, it didn't take into account that the last block at the end of
the file may not be a whole block.  In this case, the code would
extend readahead to beyond the end of the file, leaving trailing
pages.

Fix this by only requesting the expected number of pages.

Fixes: 8fc78b6fe24c ("squashfs: implement readahead")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: <stable@vger.kernel.org>
---
 fs/squashfs/file.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/squashfs/file.c b/fs/squashfs/file.c
index e526eb7a1658..f0afd4d6fd30 100644
--- a/fs/squashfs/file.c
+++ b/fs/squashfs/file.c
@@ -559,6 +559,12 @@ static void squashfs_readahead(struct readahead_control *ractl)
 		unsigned int expected;
 		struct page *last_page;
 
+		expected = start >> msblk->block_log == file_end ?
+			   (i_size_read(inode) & (msblk->block_size - 1)) :
+			    msblk->block_size;
+
+		max_pages = (expected + PAGE_SIZE - 1) >> PAGE_SHIFT;
+
 		nr_pages = __readahead_batch(ractl, pages, max_pages);
 		if (!nr_pages)
 			break;
@@ -567,13 +573,10 @@ static void squashfs_readahead(struct readahead_control *ractl)
 			goto skip_pages;
 
 		index = pages[0]->index >> shift;
+
 		if ((pages[nr_pages - 1]->index >> shift) != index)
 			goto skip_pages;
 
-		expected = index == file_end ?
-			   (i_size_read(inode) & (msblk->block_size - 1)) :
-			    msblk->block_size;
-
 		if (index == file_end && squashfs_i(inode)->fragment_block !=
 						SQUASHFS_INVALID_BLK) {
 			res = squashfs_readahead_fragment(pages, nr_pages,
-- 
2.35.1

