Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9849CA5EC
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404672AbfJCQiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:38:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391875AbfJCQiE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:38:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0812C2133F;
        Thu,  3 Oct 2019 16:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120683;
        bh=mdL0Q4Tu0YQ0/7eHxAxBpSVNI6snCFhuwkmBw7iEIB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u8APLonGcBK6V9t8xKAzf2b1s1zcWwudCFlCbS2aag2UiF1SRiegf2OQoRSWm0jvY
         1a4V7LjVXsT/OYMcImiUmnDl/XqllBynl3HEgTnK4vGktSf1YFBWu9fEufEzMFRiBs
         dZj7cqoiP/xgxk/B82bF/Ap2SPFSMFiaw8PVUfM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.2 286/313] btrfs: qgroup: Fix the wrong target io_tree when freeing reserved data space
Date:   Thu,  3 Oct 2019 17:54:24 +0200
Message-Id: <20191003154601.251693714@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit bab32fc069ce8829c416e8737c119f62a57970f9 upstream.

[BUG]
Under the following case with qgroup enabled, if some error happened
after we have reserved delalloc space, then in error handling path, we
could cause qgroup data space leakage:

>From btrfs_truncate_block() in inode.c:

	ret = btrfs_delalloc_reserve_space(inode, &data_reserved,
					   block_start, blocksize);
	if (ret)
		goto out;

 again:
	page = find_or_create_page(mapping, index, mask);
	if (!page) {
		btrfs_delalloc_release_space(inode, data_reserved,
					     block_start, blocksize, true);
		btrfs_delalloc_release_extents(BTRFS_I(inode), blocksize, true);
		ret = -ENOMEM;
		goto out;
	}

[CAUSE]
In the above case, btrfs_delalloc_reserve_space() will call
btrfs_qgroup_reserve_data() and mark the io_tree range with
EXTENT_QGROUP_RESERVED flag.

In the error handling path, we have the following call stack:
btrfs_delalloc_release_space()
|- btrfs_free_reserved_data_space()
   |- btrsf_qgroup_free_data()
      |- __btrfs_qgroup_release_data(reserved=@reserved, free=1)
         |- qgroup_free_reserved_data(reserved=@reserved)
            |- clear_record_extent_bits();
            |- freed += changeset.bytes_changed;

However due to a completion bug, qgroup_free_reserved_data() will clear
EXTENT_QGROUP_RESERVED flag in BTRFS_I(inode)->io_failure_tree, other
than the correct BTRFS_I(inode)->io_tree.
Since io_failure_tree is never marked with that flag,
btrfs_qgroup_free_data() will not free any data reserved space at all,
causing a leakage.

This type of error handling can only be triggered by errors outside of
qgroup code. So EDQUOT error from qgroup can't trigger it.

[FIX]
Fix the wrong target io_tree.

Reported-by: Josef Bacik <josef@toxicpanda.com>
Fixes: bc42bda22345 ("btrfs: qgroup: Fix qgroup reserved space underflow by only freeing reserved ranges")
CC: stable@vger.kernel.org # 4.14+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/qgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3469,7 +3469,7 @@ static int qgroup_free_reserved_data(str
 		 * EXTENT_QGROUP_RESERVED, we won't double free.
 		 * So not need to rush.
 		 */
-		ret = clear_record_extent_bits(&BTRFS_I(inode)->io_failure_tree,
+		ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree,
 				free_start, free_start + free_len - 1,
 				EXTENT_QGROUP_RESERVED, &changeset);
 		if (ret < 0)


