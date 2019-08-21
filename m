Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB09A96F53
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 04:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfHUCR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 22:17:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726512AbfHUCR0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 22:17:26 -0400
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A07322DA7;
        Wed, 21 Aug 2019 02:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566353845;
        bh=pAsXywDxAZdHvDkJOZ0zWWjdPKC5BySTiVxg2nMNfxk=;
        h=Subject:To:From:Date:From;
        b=hSERfp8yB7uJkjv0Dl12SrEUeRfPnAYU0vLN0o+z6tQccCwmgBgDUs1kvKUyrHT+1
         oVVFj+QZBdZ0lvzgXmQeh4+ib4gXTBzsdzamyOf2ugsA8ilEVM3XmLLbU+nnO/TtQY
         uEdViiDOMs9ymVAopw7/KAWKMjxbIhHMuXgRTn0E=
Subject: patch "staging: erofs: cannot set EROFS_V_Z_INITED_BIT if fill_inode_lazy" added to staging-testing
To:     gaoxiang25@huawei.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, yuchao0@huawei.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 20 Aug 2019 19:17:05 -0700
Message-ID: <1566353825184208@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: erofs: cannot set EROFS_V_Z_INITED_BIT if fill_inode_lazy

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 3407a4198faf01c9d7596c45b8606834b8dfc2b7 Mon Sep 17 00:00:00 2001
From: Gao Xiang <gaoxiang25@huawei.com>
Date: Mon, 19 Aug 2019 18:34:22 +0800
Subject: staging: erofs: cannot set EROFS_V_Z_INITED_BIT if fill_inode_lazy
 fails

As reported by erofs-utils fuzzer, unsupported compressed
clustersize will make fill_inode_lazy fail, for such case
we cannot set EROFS_V_Z_INITED_BIT since we need return
failure for each z_erofs_map_blocks_iter().

Fixes: 152a333a5895 ("staging: erofs: add compacted compression indexes support")
Cc: <stable@vger.kernel.org> # 5.3+
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Link: https://lore.kernel.org/r/20190819103426.87579-3-gaoxiang25@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/erofs/zmap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/zmap.c b/drivers/staging/erofs/zmap.c
index b61b9b5950ac..7408e86823a4 100644
--- a/drivers/staging/erofs/zmap.c
+++ b/drivers/staging/erofs/zmap.c
@@ -85,12 +85,11 @@ static int fill_inode_lazy(struct inode *inode)
 
 	vi->z_physical_clusterbits[1] = vi->z_logical_clusterbits +
 					((h->h_clusterbits >> 5) & 7);
+	set_bit(EROFS_V_Z_INITED_BIT, &vi->flags);
 unmap_done:
 	kunmap_atomic(kaddr);
 	unlock_page(page);
 	put_page(page);
-
-	set_bit(EROFS_V_Z_INITED_BIT, &vi->flags);
 out_unlock:
 	clear_and_wake_up_bit(EROFS_V_BL_Z_BIT, &vi->flags);
 	return err;
-- 
2.23.0


