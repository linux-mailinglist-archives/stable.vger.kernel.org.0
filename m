Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE3711CCD2
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 13:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbfLLMLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 07:11:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:39316 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729118AbfLLMLE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 07:11:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D8E85BA38;
        Thu, 12 Dec 2019 12:11:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 64035DA82A; Thu, 12 Dec 2019 13:11:03 +0100 (CET)
Date:   Thu, 12 Dec 2019 13:11:03 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 299/350] btrfs: don't prematurely free work
 in end_workqueue_fn()
Message-ID: <20191212121103.GR3929@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20191210210735.9077-1-sashal@kernel.org>
 <20191210210735.9077-260-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210210735.9077-260-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 10, 2019 at 04:06:44PM -0500, Sasha Levin wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> [ Upstream commit 9be490f1e15c34193b1aae17da58e14dd9f55a95 ]
> 
> Currently, end_workqueue_fn() frees the end_io_wq entry (which embeds
> the work item) and then calls bio_endio(). This is another potential
> instance of the bug in "btrfs: don't prematurely free work in
> run_ordered_work()".
> 
> In particular, the endio call may depend on other work items. For
> example, btrfs_end_dio_bio() can call btrfs_subio_endio_read() ->
> __btrfs_correct_data_nocsum() -> dio_read_error() ->
> submit_dio_repair_bio(), which submits a bio that is also completed
> through a end_workqueue_fn() work item. However,
> __btrfs_correct_data_nocsum() waits for the newly submitted bio to
> complete, thus it depends on another work item.
> 
> This example currently usually works because we use different workqueue
> helper functions for BTRFS_WQ_ENDIO_DATA and BTRFS_WQ_ENDIO_DIO_REPAIR.
> However, it may deadlock with stacked filesystems and is fragile
> overall. The proper fix is to free the work item at the very end of the
> work function, so let's do that.
> 
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> Reviewed-by: David Sterba <dsterba@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

The were more patches in the series, all contain "don't prematurely free
work in" and were part of a rework of async work processing. They're
fixing a very uncommon usecase, so if there's desire to backport them
the whole series needs to go in.

In the autosel list, there are only 2 and without the important fix.

c495dcd6fbe1 btrfs: don't prematurely free work in run_ordered_work()
9be490f1e15c btrfs: don't prematurely free work in end_workqueue_fn()
e732fe95e4ca btrfs: don't prematurely free work in reada_start_machine_worker()
57d4f0b86327 btrfs: don't prematurely free work in scrub_missing_raid56_worker()

a0cac0ec961f btrfs: get rid of unique workqueue helper functions
- this is only a cleanup that removes code obsoleted by the fixes above,
  probably out of scope of stable

I have intentionally not tagged the patches for stable, the usecase is
is specific to one user (FB), the known reproducer is only their
workload and the fixes are in their kernel already.

So if there's desire to add the patches to stable trees, then it has to
be the whole series, but I don't see a strong reason for it.
