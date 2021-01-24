Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2BF4301C17
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 14:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbhAXNQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 08:16:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:43246 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbhAXNQc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Jan 2021 08:16:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2081FACE1;
        Sun, 24 Jan 2021 13:15:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 39ABEDA7D7; Sun, 24 Jan 2021 14:14:04 +0100 (CET)
Date:   Sun, 24 Jan 2021 14:14:04 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: fix possible free space tree corruption with
 online conversion
Message-ID: <20210124131404.GH1993@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
References: <c3b7d56951de1a9163b96a8ce90ef71b3532ec71.1610745887.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3b7d56951de1a9163b96a8ce90ef71b3532ec71.1610745887.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 15, 2021 at 04:26:17PM -0500, Josef Bacik wrote:
> While running btrfs/011 in a loop I would often ASSERT() while trying to
> add a new free space entry that already existed, or get an -EEXIST while
> adding a new block to the extent tree, which is another indication of
> double allocation.
> 
> This occurs because when we do the free space tree population, we create
> the new root and then populate the tree and commit the transaction.
> The problem is when you create a new root, the root node and commit root
> node are the same.  During this initial transaction commit we will run
> all of the delayed refs that were paused during the free space tree
> generation, and thus begin to cache block groups.  While caching block
> groups the caching thread will be reading from the main root for the
> free space tree, so as we make allocations we'll be changing the free
> space tree, which can cause us to add the same range twice which results
> in either the ASSERT(ret != -EEXIST); in __btrfs_add_free_space, or in a

Still no stacktraces but at least this gives some pointer to the code
which assert is hit.

> variety of different errors when running delayed refs because of a
> double allocation.
> 
> Fix this by marking the fs_info as unsafe to load the free space tree,
> and fall back on the old slow method.  We could be smarter than this,
> for example caching the block group while we're populating the free
> space tree, but since this is a serious problem I've opted for the
> simplest solution.
> 
> CC: stable@vger.kernel.org # 4.5+
> Fixes: a5ed91828518 ("Btrfs: implement the free space B-tree")
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Added to misc-next with Filipe's review from v2, thanks.
