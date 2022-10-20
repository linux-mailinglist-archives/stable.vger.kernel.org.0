Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452CC606B5C
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 00:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiJTWjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 18:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiJTWjw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 18:39:52 -0400
X-Greylist: delayed 172 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 20 Oct 2022 15:39:36 PDT
Received: from p3plwbeout22-02.prod.phx3.secureserver.net (p3plsmtp22-02-2.prod.phx3.secureserver.net [68.178.252.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3867426AC5
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 15:39:29 -0700 (PDT)
Received: from mailex.mailcore.me ([94.136.40.144])
        by :WBEOUT: with ESMTP
        id le9aojCr1imR6le9bos5ab; Thu, 20 Oct 2022 15:36:43 -0700
X-CMAE-Analysis: v=2.4 cv=U/ZXscnu c=1 sm=1 tr=0 ts=6351cd7b
 a=wXHyRMViKMYRd//SnbHIqA==:117 a=84ok6UeoqCVsigPHarzEiQ==:17
 a=ggZhUymU-5wA:10 a=Qawa6l4ZSaYA:10 a=VwQbUJbxAAAA:8 a=FXvPX3liAAAA:8
 a=NzQU21p7aw8KqXuY42AA:9 a=AjGcO6oz07-iQ99wixmX:22 a=UObqyxdv-6Yh2QiB9mM_:22
X-SECURESERVER-ACCT: phillip@squashfs.org.uk  
X-SID:  le9aojCr1imR6
Received: from 82-69-79-175.dsl.in-addr.zen.co.uk ([82.69.79.175] helo=phoenix.fritz.box)
        by smtp12.mailcore.me with esmtpa (Exim 4.94.2)
        (envelope-from <phillip@squashfs.org.uk>)
        id 1ole9Z-0006zQ-Oa; Thu, 20 Oct 2022 23:36:42 +0100
From:   Phillip Lougher <phillip@squashfs.org.uk>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc:     hsinyi@chromium.org, regressions@leemhuis.info,
        regressions@lists.linux.dev, dimitri.ledkov@canonical.com,
        michael.vogt@canonical.com, phillip.lougher@gmail.com,
        ogra@ubuntu.com, olivier.tilloy@canonical.com,
        Phillip Lougher <phillip@squashfs.org.uk>,
        stable@vger.kernel.org
Subject: [PATCH 3/3] squashfs: fix buffer release race condition in readahead code
Date:   Thu, 20 Oct 2022 23:36:16 +0100
Message-Id: <20221020223616.7571-4-phillip@squashfs.org.uk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221020223616.7571-1-phillip@squashfs.org.uk>
References: <20221020223616.7571-1-phillip@squashfs.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mailcore-Auth: 439999529
X-Mailcore-Domain: 1394945
X-123-reg-Authenticated:  phillip@squashfs.org.uk  
X-Originating-IP: 82.69.79.175
X-CMAE-Envelope: MS4xfAeCv/9N9gGLkcg1ImRY2fUmkVE71wOfuWJmX1a0UkB/ryWiX3y5yIue4/Yy3QtFRpidgVVBo22XNLG+TfnbBSVH3gJLNbtv2eP7vlZRmcpl5Gej0pr+
 t7+OhBCF8T08Ib1MYoekZGQEHIEufT3c0Iya0RdaNxWE5uTEpCgSF7zgj8HfU0GeU0ICZLb2Gv+oMq0TDRZ57BXmGYbxUQ3b/FFpLNP/q/bsh7kGsn/mHo0T
 3XjQ/9k2IJxEO2w5nvW+zA==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix a buffer release race condition, where the error value was
used after release.

Fixes: b09a7a036d20 ("squashfs: support reading fragments in readahead call")
Cc: <stable@vger.kernel.org>
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
---
 fs/squashfs/file.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/squashfs/file.c b/fs/squashfs/file.c
index f0afd4d6fd30..8ba8c4c50770 100644
--- a/fs/squashfs/file.c
+++ b/fs/squashfs/file.c
@@ -506,8 +506,9 @@ static int squashfs_readahead_fragment(struct page **page,
 		squashfs_i(inode)->fragment_size);
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
 	unsigned int n, mask = (1 << (msblk->block_log - PAGE_SHIFT)) - 1;
+	int error = buffer->error;
 
-	if (buffer->error)
+	if (error)
 		goto out;
 
 	expected += squashfs_i(inode)->fragment_offset;
@@ -529,7 +530,7 @@ static int squashfs_readahead_fragment(struct page **page,
 
 out:
 	squashfs_cache_put(buffer);
-	return buffer->error;
+	return error;
 }
 
 static void squashfs_readahead(struct readahead_control *ractl)
-- 
2.35.1

