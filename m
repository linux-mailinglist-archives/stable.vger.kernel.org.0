Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F62840E52B
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349510AbhIPRIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:08:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349470AbhIPRFw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:05:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 989B461B24;
        Thu, 16 Sep 2021 16:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810129;
        bh=CtG2OrMLQjUzJ8VV92iK2VkFg4YZTCFGCN8MGSJVDCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IhMtfLT7oYZMqjGL+Lsynv0qxZg5/69iinI0g4hzzqTqQOw/jKrqTov+kWadolZhe
         cOm1fx3szGq3frIz/D53iULqtyLZwTlmuGtU+6rdnt+fXl5lmiuvV45ELC2RvnTLvU
         Do/mdkgz91UYXYJCMYUZv71mS5m3+UfMo5zKGQ4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.14 009/432] btrfs: wake up async_delalloc_pages waiters after submit
Date:   Thu, 16 Sep 2021 17:55:58 +0200
Message-Id: <20210916155811.128883735@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit ac98141d140444fe93e26471d3074c603b70e2ca upstream.

We use the async_delalloc_pages mechanism to make sure that we've
completed our async work before trying to continue our delalloc
flushing.  The reason for this is we need to see any ordered extents
that were created by our delalloc flushing.  However we're waking up
before we do the submit work, which is before we create the ordered
extents.  This is a pretty wide race window where we could potentially
think there are no ordered extents and thus exit shrink_delalloc
prematurely.  Fix this by waking us up after we've done the work to
create ordered extents.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1290,11 +1290,6 @@ static noinline void async_cow_submit(st
 	nr_pages = (async_chunk->end - async_chunk->start + PAGE_SIZE) >>
 		PAGE_SHIFT;
 
-	/* atomic_sub_return implies a barrier */
-	if (atomic_sub_return(nr_pages, &fs_info->async_delalloc_pages) <
-	    5 * SZ_1M)
-		cond_wake_up_nomb(&fs_info->async_submit_wait);
-
 	/*
 	 * ->inode could be NULL if async_chunk_start has failed to compress,
 	 * in which case we don't have anything to submit, yet we need to
@@ -1303,6 +1298,11 @@ static noinline void async_cow_submit(st
 	 */
 	if (async_chunk->inode)
 		submit_compressed_extents(async_chunk);
+
+	/* atomic_sub_return implies a barrier */
+	if (atomic_sub_return(nr_pages, &fs_info->async_delalloc_pages) <
+	    5 * SZ_1M)
+		cond_wake_up_nomb(&fs_info->async_submit_wait);
 }
 
 static noinline void async_cow_free(struct btrfs_work *work)


