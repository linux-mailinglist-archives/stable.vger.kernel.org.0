Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E3D48DF65
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 22:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbiAMVI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 16:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiAMVI1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 16:08:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A01C061574;
        Thu, 13 Jan 2022 13:08:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BF8F61859;
        Thu, 13 Jan 2022 21:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA983C36AE3;
        Thu, 13 Jan 2022 21:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642108106;
        bh=ehd2NgtJoJNOvE64Iz++yOj5oYy3K4FG4M2pBZpIJz4=;
        h=Date:From:To:Subject:From;
        b=UMNxirNu55IZi5XmIAnvKNxGhBOaBS33ItaifZSbGSRrScyVyvRricCyaOuDg+4I7
         4WN+GoDlGhtybPgFGdF9lziS1dfAhPxI9BfvSMpTxzSC8JidpDKGOziHif0cGEazcV
         1SxzoPzM8qePTV5+6QpFr05r7MKsl3rHAb/JXWZg=
Date:   Thu, 13 Jan 2022 13:08:25 -0800
From:   akpm@linux-foundation.org
To:     agruenba@redhat.com, catalin.marinas@arm.com, dsterba@suse.com,
        josef@toxicpanda.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk, will@kernel.org,
        willy@infradead.org
Subject:  [to-be-updated]
 =?US-ASCII?Q?btrfs-avoid-live-lock-in-search=5Fioctl-on-hardware-with-s?=
 =?US-ASCII?Q?ub-page-faults.patch?= removed from -mm tree
Message-ID: <20220113210825.h8DHZZey9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: btrfs: avoid live-lock in search_ioctl() on hardware with sub-page faults
has been removed from the -mm tree.  Its filename was
     btrfs-avoid-live-lock-in-search_ioctl-on-hardware-with-sub-page-faults.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: btrfs: avoid live-lock in search_ioctl() on hardware with sub-page faults

Commit a48b73eca4ce ("btrfs: fix potential deadlock in the search ioctl")
addressed a lockdep warning by pre-faulting the user pages and attempting
the copy_to_user_nofault() in an infinite loop.  On architectures like
arm64 with MTE, an access may fault within a page at a location different
from what fault_in_writeable() probed.  Since the sk_offset is rewound to
the previous struct btrfs_ioctl_search_header boundary, there is no
guaranteed forward progress and search_ioctl() may live-lock.

Use fault_in_exact_writeable() instead which probes the entire user
buffer for faults at sub-page granularity.

Link: https://lkml.kernel.org/r/20211124192024.2408218-4-catalin.marinas@arm.com
Fixes: a48b73eca4ce ("btrfs: fix potential deadlock in the search ioctl") 
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: David Sterba <dsterba@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/ioctl.c~btrfs-avoid-live-lock-in-search_ioctl-on-hardware-with-sub-page-faults
+++ a/fs/btrfs/ioctl.c
@@ -2225,7 +2225,8 @@ static noinline int search_ioctl(struct
 
 	while (1) {
 		ret = -EFAULT;
-		if (fault_in_writeable(ubuf + sk_offset, *buf_size - sk_offset))
+		if (fault_in_exact_writeable(ubuf + sk_offset,
+					     *buf_size - sk_offset))
 			break;
 
 		ret = btrfs_search_forward(root, &key, path, sk->min_transid);
_

Patches currently in -mm which might be from catalin.marinas@arm.com are


