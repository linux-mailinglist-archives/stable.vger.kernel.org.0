Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9563DC404
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 08:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbhGaGds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 02:33:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232090AbhGaGdr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Jul 2021 02:33:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 931AC60D07;
        Sat, 31 Jul 2021 06:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627713222;
        bh=IQvGwPf8vObFblEaV3KaqW7P6YI2J9DvkKS7ZL+8spU=;
        h=Subject:To:Cc:From:Date:From;
        b=gtujDlkl9xCOslpVqEZzs0OqDY8PcUzjbIKS92ES+IgbYU3iu6JMzZpXiWAULRh4U
         SH7vT3WHxmxRndpucgIh0mmeVp3Fhv2h1xfPS4mf0je3Da0Yjyz6IxaOuKzr6nrXD/
         zMKHb++UJu6DRmHh9wALhSzUbKSttHvF3bmTZfzo=
Subject: FAILED: patch "[PATCH] btrfs: mark compressed range uptodate only if all bio succeed" failed to apply to 4.14-stable tree
To:     rgoldwyn@suse.de, dsterba@suse.com, rgoldwyn@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 31 Jul 2021 08:33:28 +0200
Message-ID: <16277132082290@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 240246f6b913b0c23733cfd2def1d283f8cc9bbe Mon Sep 17 00:00:00 2001
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Fri, 9 Jul 2021 11:29:22 -0500
Subject: [PATCH] btrfs: mark compressed range uptodate only if all bio succeed

In compression write endio sequence, the range which the compressed_bio
writes is marked as uptodate if the last bio of the compressed (sub)bios
is completed successfully. There could be previous bio which may
have failed which is recorded in cb->errors.

Set the writeback range as uptodate only if cb->errors is zero, as opposed
to checking only the last bio's status.

Backporting notes: in all versions up to 4.4 the last argument is always
replaced by "!cb->errors".

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 9a023ae0f98b..30d82cdf128c 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -352,7 +352,7 @@ static void end_compressed_bio_write(struct bio *bio)
 	btrfs_record_physical_zoned(inode, cb->start, bio);
 	btrfs_writepage_endio_finish_ordered(BTRFS_I(inode), NULL,
 			cb->start, cb->start + cb->len - 1,
-			bio->bi_status == BLK_STS_OK);
+			!cb->errors);
 
 	end_compressed_writeback(inode, cb);
 	/* note, our inode could be gone now */

