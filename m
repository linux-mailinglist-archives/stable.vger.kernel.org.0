Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3188D3830EC
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239412AbhEQOcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:32:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240128AbhEQOaF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:30:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D18A76191B;
        Mon, 17 May 2021 14:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260911;
        bh=Lw7QXz+KOCEH0MBTLcmFIcb8RtJ28j6AMY2VWljdY/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Shch4o56KtmuvWc6CAtRZpvLrl5HD9QEapQi22gHA2T1RZnnqIgTJQUQp5YKRnJgq
         LVh15j0QPV1bk7P9a37uBSnMzrEAqjsWTfAd4jyfnQt/l8hafrq9zIUsYyKasxrA5P
         XZlmk5rkzZhooiuC4a7AiuyxPvch9sFgUzbd7X4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.12 265/363] btrfs: zoned: fix silent data loss after failure splitting ordered extent
Date:   Mon, 17 May 2021 16:02:11 +0200
Message-Id: <20210517140311.573621862@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit adbd914dcde0b03bfc08ffe40b81f31b0457833f upstream.

On a zoned filesystem, sometimes we need to split an ordered extent into 3
different ordered extents. The original ordered extent is shortened, at
the front and at the rear, and we create two other new ordered extents to
represent the trimmed parts of the original ordered extent.

After adjusting the original ordered extent, we create an ordered extent
to represent the pre-range, and that may fail with ENOMEM for example.
After that we always try to create the ordered extent for the post-range,
and if that happens to succeed we end up returning success to the caller
as we overwrite the 'ret' variable which contained the previous error.

This means we end up with a file range for which there is no ordered
extent, which results in the range never getting a new file extent item
pointing to the new data location. And since the split operation did
not return an error, writeback does not fail and the inode's mapping is
not flagged with an error, resulting in a subsequent fsync not reporting
an error either.

It's possibly very unlikely to have the creation of the post-range ordered
extent succeed after the creation of the pre-range ordered extent failed,
but it's not impossible.

So fix this by making sure we only create the post-range ordered extent
if there was no error creating the ordered extent for the pre-range.

Fixes: d22002fd37bd97 ("btrfs: zoned: split ordered extent when bio is sent")
CC: stable@vger.kernel.org # 5.12+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ordered-data.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -995,7 +995,7 @@ int btrfs_split_ordered_extent(struct bt
 
 	if (pre)
 		ret = clone_ordered_extent(ordered, 0, pre);
-	if (post)
+	if (ret == 0 && post)
 		ret = clone_ordered_extent(ordered, pre + ordered->disk_num_bytes,
 					   post);
 


