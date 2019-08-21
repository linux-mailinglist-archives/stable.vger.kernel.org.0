Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC9896F52
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 04:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfHUCRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 22:17:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726512AbfHUCRU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 22:17:20 -0400
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 110B222DA7;
        Wed, 21 Aug 2019 02:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566353840;
        bh=JTAhsDrhWMyK/tgeg2VKnEx2U8tlGbaPK+0HLrYoIvg=;
        h=Subject:To:From:Date:From;
        b=l/RNcgpxgfjmAjKorme0BlwCI9T3UPlQk8rW7UDcLF+4hnLzszmdLAwvbYsgZYN4T
         V+pq9LzxNG1R9MbLOfbvrZL/Sv6QAY1IseYrdl3mKPxZD4HS3dHprFy5w92CL5nX48
         NyUFf27pGvPGg2OMxLCLadhRK5dSGK5TTFrH8r3U=
Subject: patch "staging: erofs: some compressed cluster should be submitted for" added to staging-testing
To:     gaoxiang25@huawei.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, yuchao0@huawei.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 20 Aug 2019 19:17:04 -0700
Message-ID: <156635382453226@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: erofs: some compressed cluster should be submitted for

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From ee45197c807895e156b2be0abcaebdfc116487c8 Mon Sep 17 00:00:00 2001
From: Gao Xiang <gaoxiang25@huawei.com>
Date: Mon, 19 Aug 2019 18:34:21 +0800
Subject: staging: erofs: some compressed cluster should be submitted for
 corrupted images

As reported by erofs_utils fuzzer, a logical page can belong
to at most 2 compressed clusters, if one compressed cluster
is corrupted, but the other has been ready in submitting chain.

The chain needs to submit anyway in order to keep the page
working properly (page unlocked with PG_error set, PG_uptodate
not set).

Let's fix it now.

Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Link: https://lore.kernel.org/r/20190819103426.87579-2-gaoxiang25@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/erofs/zdata.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/erofs/zdata.c b/drivers/staging/erofs/zdata.c
index 2d7aaf98f7de..87b0c96caf8f 100644
--- a/drivers/staging/erofs/zdata.c
+++ b/drivers/staging/erofs/zdata.c
@@ -1307,19 +1307,18 @@ static int z_erofs_vle_normalaccess_readpage(struct file *file,
 	err = z_erofs_do_read_page(&f, page, &pagepool);
 	(void)z_erofs_collector_end(&f.clt);
 
-	if (err) {
+	/* if some compressed cluster ready, need submit them anyway */
+	z_erofs_submit_and_unzip(inode->i_sb, &f.clt, &pagepool, true);
+
+	if (err)
 		errln("%s, failed to read, err [%d]", __func__, err);
-		goto out;
-	}
 
-	z_erofs_submit_and_unzip(inode->i_sb, &f.clt, &pagepool, true);
-out:
 	if (f.map.mpage)
 		put_page(f.map.mpage);
 
 	/* clean up the remaining free pages */
 	put_pages_list(&pagepool);
-	return 0;
+	return err;
 }
 
 static bool should_decompress_synchronously(struct erofs_sb_info *sbi,
-- 
2.23.0


