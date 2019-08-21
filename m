Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9AE3979D5
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 14:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbfHUMq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 08:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728333AbfHUMq2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Aug 2019 08:46:28 -0400
Received: from localhost (unknown [12.166.174.13])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BF40233A1;
        Wed, 21 Aug 2019 12:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566391587;
        bh=15iMlD7hX4JX6hOTDW5n6x1zl5PPZltyuYhlSkTT+rg=;
        h=Subject:To:From:Date:From;
        b=vzge/bIjd575gPo+DiTQuQwwWGSszJ5L30Tml6DIDDMHCkYE0gu+azriNBzSU3aQK
         ejN6FV/yTpWriR4lhJso0uXCbpAcR7rf+XZc/jfME4HX6Pr/kFSkH20vHHlxQYIqj5
         WG2RFe1Vu2cma+HSpJnFCLS3xbPPdB3AccDk4wNg=
Subject: patch "staging: erofs: add two missing erofs_workgroup_put for corrupted" added to staging-next
To:     gaoxiang25@huawei.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, yuchao0@huawei.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 21 Aug 2019 05:46:26 -0700
Message-ID: <15663915865766@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: erofs: add two missing erofs_workgroup_put for corrupted

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 138e1a0990e80db486ab9f6c06bd5c01f9a97999 Mon Sep 17 00:00:00 2001
From: Gao Xiang <gaoxiang25@huawei.com>
Date: Mon, 19 Aug 2019 18:34:23 +0800
Subject: staging: erofs: add two missing erofs_workgroup_put for corrupted
 images

As reported by erofs-utils fuzzer, these error handling
path will be entered to handle corrupted images.

Lack of erofs_workgroup_puts will cause unmounting
unsuccessfully.

Fix these return values to EFSCORRUPTED as well.

Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Link: https://lore.kernel.org/r/20190819103426.87579-4-gaoxiang25@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/erofs/zdata.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/zdata.c b/drivers/staging/erofs/zdata.c
index 87b0c96caf8f..23283c97fd3b 100644
--- a/drivers/staging/erofs/zdata.c
+++ b/drivers/staging/erofs/zdata.c
@@ -357,14 +357,16 @@ static struct z_erofs_collection *cllookup(struct z_erofs_collector *clt,
 	cl = z_erofs_primarycollection(pcl);
 	if (unlikely(cl->pageofs != (map->m_la & ~PAGE_MASK))) {
 		DBG_BUGON(1);
-		return ERR_PTR(-EIO);
+		erofs_workgroup_put(grp);
+		return ERR_PTR(-EFSCORRUPTED);
 	}
 
 	length = READ_ONCE(pcl->length);
 	if (length & Z_EROFS_PCLUSTER_FULL_LENGTH) {
 		if ((map->m_llen << Z_EROFS_PCLUSTER_LENGTH_BIT) > length) {
 			DBG_BUGON(1);
-			return ERR_PTR(-EIO);
+			erofs_workgroup_put(grp);
+			return ERR_PTR(-EFSCORRUPTED);
 		}
 	} else {
 		unsigned int llen = map->m_llen << Z_EROFS_PCLUSTER_LENGTH_BIT;
-- 
2.23.0


