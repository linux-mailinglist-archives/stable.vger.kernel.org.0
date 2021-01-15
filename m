Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB8B2F6FC7
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 02:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbhAOBAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 20:00:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:54498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728869AbhAOBAh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Jan 2021 20:00:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A67323A5E;
        Fri, 15 Jan 2021 00:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610672397;
        bh=ZYbWOliBdkqdd2/FwymKMiX/qVMLAJje/weEKDhfAK0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MpR/AFf69BFT0ZTicOZHX0z2oL3OuZoV5FhkMuPWil9hqfbWSZuFdVINMu0FbKT6a
         5NH3Edbn6aZBKrOW/XFBGvL4qzI4rYfaAp8sfmco4M4vILH1ChHiTFMR4uk36J9Tin
         8yMOa5fTyl6RWOMKiEw3gQjOYz4awnvDJDsW/p5rcf0LQyW7sNa74FIjW1Cfc2xsi1
         Ot5bwzmJB+cT/YRH+heJVELE1AVWLxjHtfJwDOPNOmFIqgYk/EJ3775ct4G25CAtTW
         tA5n3UZJ9fjS9JNE3hTZz1ogj6pFVOrPA049fci/NJ4+1eV33UkMQuIrMEGWLd9JyI
         MXjbRdhX/0J6A==
Date:   Thu, 14 Jan 2021 19:59:56 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     David Sterba <dsterba@suse.com>
Cc:     stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        =?iso-8859-1?Q?Ren=E9?= Rebe <rene@exactcode.de>
Subject: Re: [PATCH for 5.10.x] btrfs: shrink delalloc pages instead of full
 inodes
Message-ID: <20210115005956.GV4035784@sasha-vm>
References: <20210114143430.17903-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210114143430.17903-1-dsterba@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 14, 2021 at 03:34:30PM +0100, David Sterba wrote:
>From: Josef Bacik <josef@toxicpanda.com>
>
>commit e076ab2a2ca70a0270232067cd49f76cd92efe64 upstream.
>
>Commit 38d715f494f2 ("btrfs: use btrfs_start_delalloc_roots in
>shrink_delalloc") cleaned up how we do delalloc shrinking by utilizing
>some infrastructure we have in place to flush inodes that we use for
>device replace and snapshot.  However this introduced a pretty serious
>performance regression.  To reproduce the user untarred the source
>tarball of Firefox (360MiB xz compressed/1.5GiB uncompressed), and would
>see it take anywhere from 5 to 20 times as long to untar in 5.10
>compared to 5.9. This was observed on fast devices (SSD and better) and
>not on HDD.
>
>The root cause is because before we would generally use the normal
>writeback path to reclaim delalloc space, and for this we would provide
>it with the number of pages we wanted to flush.  The referenced commit
>changed this to flush that many inodes, which drastically increased the
>amount of space we were flushing in certain cases, which severely
>affected performance.
>
>We cannot revert this patch unfortunately because of 3d45f221ce62
>("btrfs: fix deadlock when cloning inline extent and low on free
>metadata space") which requires the ability to skip flushing inodes that
>are being cloned in certain scenarios, which means we need to keep using
>our flushing infrastructure or risk re-introducing the deadlock.

But we don't have 3d45f221ce62 in 5.10, which in turn makes me wonder
why, as it's tagged for stable.

Instead of the backport, I'm going to take:

e076ab2a2ca7 ("btrfs: shrink delalloc pages instead of full inodes")
3d45f221ce62 ("btrfs: fix deadlock when cloning inline extent and low on free metadata space")
f2f121ab500d ("btrfs: skip unnecessary searches for xattrs when logging an inode")

which deals with that missing stable tagged commit too.

Thanks!

-- 
Thanks,
Sasha
