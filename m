Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A28C317359
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 23:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbhBJW3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 17:29:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:48078 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233150AbhBJW3L (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 17:29:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B97A2AC88;
        Wed, 10 Feb 2021 22:28:29 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 117DEDA6E9; Wed, 10 Feb 2021 23:26:36 +0100 (CET)
Date:   Wed, 10 Feb 2021 23:26:35 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix race between extent freeing/allocation when
 using bitmaps
Message-ID: <20210210222635.GZ1993@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <20210208082652.2654024-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208082652.2654024-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 10:26:54AM +0200, Nikolay Borisov wrote:
> During allocation the allocator will try to allocate an extent using
> cluster policy. Once the current cluster is exhausted it will remove the
> its entry under btrfs_free_cluster::lock and subsequently acquire
> btrfs_free_space_ctl::tree_lock to dispose of the already-deleted
> entry and adjust btrfs_free_space_ctl::total_bitmap. This poses a
> problem because there exists a race condition between removing the
> entry under one lock and doing the necessary accounting holding a
> different lock since extent freeing only uses the 2nd lock. This can
> result in the following situation:
> 
> T1:                                    T2:
> btrfs_alloc_from_cluster               insert_into_bitmap <holds tree_lock>
>  if (entry->bytes == 0)                   if (block_group && !list_empty(&block_group->cluster_list)) {
>     rb_erase(entry)
> 
>  spin_unlock(&cluster->lock);
>    (total_bitmaps is still 4)           spin_lock(&cluster->lock);
>                                          <doesn't find entry in cluster->root>
>  spin_lock(&ctl->tree_lock);             <goes to new_bitmap label, adds
> <blocked since T2 holds tree_lock>       <a new entry and calls add_new_bitmap>
> 					    recalculate_thresholds  <crashes,
>                                               due to total_bitmaps
> 					      becoming 5 and triggering
> 					      an ASSERT>
> 
> To fix this ensure that once depleted, the cluster entry is deleted when
> both cluster lock and tree locks are held in the allocator (T1), this
> ensures that even if there is a race with a concurrent
> insert_into_bitmap call it will correctly find the entry in the cluster
> and add the new space to it.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> Cc: <stable@vger.kernel.org>

Added to for-next, targeting 5.12-rc, thanks.
