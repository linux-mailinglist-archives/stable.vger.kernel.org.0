Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0004521FB76
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbgGNS7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:59:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731085AbgGNS7F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:59:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C4F222AAF;
        Tue, 14 Jul 2020 18:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753144;
        bh=St2pw05xyaaVWoBdM5zmWV914ertFmW8ms8PzxGR/e4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4JOabC4H/QdLcfOhKRWdlCDhnFL0ZBJE0RvWq1jHxo4XRvgnW5mBZvMFdp4IB5Md
         OspwaRc29b0w2AkMjTborENyECLgIedxgxQCV7oNjE+rlAWjmgrGTVar5v0OqEtzVu
         eiiklu9IMRckTqUOCrEboujGIqqNEiGZPHpv7ofI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.7 137/166] btrfs: fix double put of block group with nocow
Date:   Tue, 14 Jul 2020 20:45:02 +0200
Message-Id: <20200714184122.393557082@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 230ed397435e85b54f055c524fcb267ae2ce3bc4 upstream.

While debugging a patch that I wrote I was hitting use-after-free panics
when accessing block groups on unmount.  This turned out to be because
in the nocow case if we bail out of doing the nocow for whatever reason
we need to call btrfs_dec_nocow_writers() if we called the inc.  This
puts our block group, but a few error cases does

if (nocow) {
    btrfs_dec_nocow_writers();
    goto error;
}

unfortunately, error is

error:
	if (nocow)
		btrfs_dec_nocow_writers();

so we get a double put on our block group.  Fix this by dropping the
error cases calling of btrfs_dec_nocow_writers(), as it's handled at the
error label now.

Fixes: 762bf09893b4 ("btrfs: improve error handling in run_delalloc_nocow")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1690,12 +1690,8 @@ out_check:
 			ret = fallback_to_cow(inode, locked_page, cow_start,
 					      found_key.offset - 1,
 					      page_started, nr_written);
-			if (ret) {
-				if (nocow)
-					btrfs_dec_nocow_writers(fs_info,
-								disk_bytenr);
+			if (ret)
 				goto error;
-			}
 			cow_start = (u64)-1;
 		}
 
@@ -1711,9 +1707,6 @@ out_check:
 					  ram_bytes, BTRFS_COMPRESS_NONE,
 					  BTRFS_ORDERED_PREALLOC);
 			if (IS_ERR(em)) {
-				if (nocow)
-					btrfs_dec_nocow_writers(fs_info,
-								disk_bytenr);
 				ret = PTR_ERR(em);
 				goto error;
 			}


