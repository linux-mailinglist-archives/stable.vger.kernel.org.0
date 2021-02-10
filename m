Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3103173B3
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 23:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbhBJWwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 17:52:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:40542 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233454AbhBJWwu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 17:52:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8BD7FACB7;
        Wed, 10 Feb 2021 22:52:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DCC4FDA6E9; Wed, 10 Feb 2021 23:50:14 +0100 (CET)
Date:   Wed, 10 Feb 2021 23:50:14 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: avoid double put of block group when emptying
 cluster
Message-ID: <20210210225014.GA1993@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, stable@vger.kernel.org
References: <5ca694ff4f8cff4c0ef6896593a1f1d01fbe956d.1611610947.git.josef@toxicpanda.com>
 <bf8cd92d-12a0-3bb3-34c0-dd9c938bf349@suse.com>
 <ad0ea42a-5e41-f9b9-986d-8c70e9f2eed3@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ad0ea42a-5e41-f9b9-986d-8c70e9f2eed3@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 26, 2021 at 09:30:45AM -0500, Josef Bacik wrote:
> On 1/26/21 4:02 AM, Nikolay Borisov wrote:
> > On 25.01.21 г. 23:42 ч., Josef Bacik wrote:
> >> In __btrfs_return_cluster_to_free_space we will bail doing the cleanup
> >> of the cluster if the block group we passed in doesn't match the block
> >> group on the cluster.  However we drop a reference to block_group, as
> >> the cluster holds a reference to the block group while it's attached to
> >> the cluster.  If cluster->block_group != block_group however then this
> >> is an extra put, which means we'll go negative and free this block group
> >> down the line, leading to a UAF.
> > 
> > Was this found by code inspection or did you hit in production. Also why
> > in btrfs_remove_free_space_cache just before
> > __btrfs_return_cluster_to_free_space there is:
> > 
> 
> It was found in production sort of halfway.  I was doing something for WhatsApp 
> and had to convert our block group reference counting to the refcount stuff so I 
> could find where I made a mistake.  Turns out this was where the problem was, my 
> stuff had just made it way more likely to happen.  I don't have the stack trace 
> because this was like 6 months ago, I'm going through all my WhatsApp magic and 
> getting them actually usable for upstream.
> 
> > WARN_ON(cluster->block_group != block_group);
> > 
> > IMO this patch should also remove the WARN_ON if it's a valid condition
> > to have the passed bg be different than the one in the cluster. Also
> > that WARN_ON is likely racy since it's done outside of cluster->lock.
> > 
> 
> Yup that's in a follow up thing, I wanted to get the actual fix out before I got 
> distracted by my mountain of meetings this week.  Thanks,

Removing the WARN_ON in a separate patch sounds ok to me, this patch
clearly fixes the refcounting bug, the warning condition is the same but
would need a different reasoning.

Nikolay, if you're ok with current patch version let me know if you want
a rev-by added.
