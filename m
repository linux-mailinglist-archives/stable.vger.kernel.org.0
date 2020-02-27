Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0C3171BC7
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387801AbgB0OFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:05:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:42436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387798AbgB0OFk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:05:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B02720578;
        Thu, 27 Feb 2020 14:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812339;
        bh=qpo+XMyyKLIxMT/BdGw0TqsKggEost62VlexUf7Rc0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=is+E26KGS639ffM51QOXe238W/R7++lwi2G2r7zdsc9YLUM12LW3oANjBhF1RwEcR
         xWI8ammLYjGx9a9yigkpaFrWu315Qgu4sGtTYqbqfE5pdd+oxbWaeL6zHaghhIxX+x
         SgsSrIO2EeYifMuWH+zuXijxUTLBWeOGX0USET38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 78/97] Btrfs: fix btrfs_wait_ordered_range() so that it waits for all ordered extents
Date:   Thu, 27 Feb 2020 14:37:26 +0100
Message-Id: <20200227132227.200104132@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132214.553656188@linuxfoundation.org>
References: <20200227132214.553656188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit e75fd33b3f744f644061a4f9662bd63f5434f806 upstream.

In btrfs_wait_ordered_range() once we find an ordered extent that has
finished with an error we exit the loop and don't wait for any other
ordered extents that might be still in progress.

All the users of btrfs_wait_ordered_range() expect that there are no more
ordered extents in progress after that function returns. So past fixes
such like the ones from the two following commits:

  ff612ba7849964 ("btrfs: fix panic during relocation after ENOSPC before
                   writeback happens")

  28aeeac1dd3080 ("Btrfs: fix panic when starting bg cache writeout after
                   IO error")

don't work when there are multiple ordered extents in the range.

Fix that by making btrfs_wait_ordered_range() wait for all ordered extents
even after it finds one that had an error.

Link: https://github.com/kdave/btrfs-progs/issues/228#issuecomment-569777554
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ordered-data.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -712,10 +712,15 @@ int btrfs_wait_ordered_range(struct inod
 		}
 		btrfs_start_ordered_extent(inode, ordered, 1);
 		end = ordered->file_offset;
+		/*
+		 * If the ordered extent had an error save the error but don't
+		 * exit without waiting first for all other ordered extents in
+		 * the range to complete.
+		 */
 		if (test_bit(BTRFS_ORDERED_IOERR, &ordered->flags))
 			ret = -EIO;
 		btrfs_put_ordered_extent(ordered);
-		if (ret || end == 0 || end == start)
+		if (end == 0 || end == start)
 			break;
 		end--;
 	}


