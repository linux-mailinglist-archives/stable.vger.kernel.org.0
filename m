Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35072DB1E7
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 17:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731135AbgLOQwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 11:52:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:58476 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgLOQwB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Dec 2020 11:52:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 947FAAC7F;
        Tue, 15 Dec 2020 16:51:19 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6FB70DA7C3; Tue, 15 Dec 2020 17:49:40 +0100 (CET)
Date:   Tue, 15 Dec 2020 17:49:40 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: fix possible free space tree corruption with
 online conversion
Message-ID: <20201215164940.GW6430@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
References: <e5f7fe3ad3a612efeda53f016904aff332db6f8a.1607610739.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5f7fe3ad3a612efeda53f016904aff332db6f8a.1607610739.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 09:32:31AM -0500, Josef Bacik wrote:
> While running btrfs/011 in a loop I would often ASSERT() while trying to
> add a new free space entry that already existed, or get an -EEXIST while
> adding a new block to the extent tree, which is another indication of
> double allocation.

Do you have the stack traces? I'll update the changelog if you send it.

> This occurs because when we do the free space tree population, we create
> the new root and then populate the tree and commit the transaction.
> The problem is when you create a new root, the root node and commit root
> node are the same.  This means that caching a block group before the
> transaction is committed can race with other operations modifying the
> free space tree, and thus you can get double adds and other sort of
> shenanigans.  This is only a problem for the first transaction, once
> we've committed the transaction we created the free space tree in we're
> OK to use the free space tree to cache block groups.
> 
> Fix this by marking the fs_info as unsafe to load the free space tree,
> and fall back on the old slow method.  We could be smarter than this,
> for example caching the block group while we're populating the free
> space tree, but since this is a serious problem I've opted for the
> simplest solution.

Makes sense, this is a one-time thing during setup.

> cc: stable@vger.kernel.org

CC: stable@vger.kernel.org

If you send patch with the tag it's good to also note the minimal
version where it's relevant as you can easily reuse the knowledge from
developing the fix. The patch may not apply due to other changes, but
trivial context fixups are done by people interested in the backports.

> Fixes: a5ed91828518 ("Btrfs: implement the free space B-tree")

So if you know the offending commit, run

  $ git describe --contains a5ed91828518
  v4.5-rc1~21^2~22^2^2~3

which is 4.9.
