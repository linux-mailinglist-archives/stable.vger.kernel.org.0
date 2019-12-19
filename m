Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81731127140
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 00:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfLSXGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 18:06:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:55602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbfLSXGv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 18:06:51 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19523206EC;
        Thu, 19 Dec 2019 23:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576796810;
        bh=imXzRId1FfdZp3azJNBG+sfBPqv4ACjNC0Dv6iLe+38=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=0GFwryPKVyZuEI5v3GPvQaVSQhp51JLdZMxUwaEdCh3+TGIN7GXXygBvV0F0FOMaf
         xUiHXrlAlUMJyui26/5fYqMmcYlxS+3Eu3m97B+XoyWMBd8wiqiTiE7XdLt6KdTEgO
         RSerz+eFlcmA+c7oZxAt505giRxZdw31gLg8fyeo=
Date:   Thu, 19 Dec 2019 18:06:49 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     dsterba@suse.cz, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Omar Sandoval <osandov@fb.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 299/350] btrfs: don't prematurely free work
 in end_workqueue_fn()
Message-ID: <20191219230649.GT17708@sasha-vm>
References: <20191210210735.9077-1-sashal@kernel.org>
 <20191210210735.9077-260-sashal@kernel.org>
 <20191212121103.GR3929@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191212121103.GR3929@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 12, 2019 at 01:11:03PM +0100, David Sterba wrote:
>On Tue, Dec 10, 2019 at 04:06:44PM -0500, Sasha Levin wrote:
>> From: Omar Sandoval <osandov@fb.com>
>>
>> [ Upstream commit 9be490f1e15c34193b1aae17da58e14dd9f55a95 ]
>>
>> Currently, end_workqueue_fn() frees the end_io_wq entry (which embeds
>> the work item) and then calls bio_endio(). This is another potential
>> instance of the bug in "btrfs: don't prematurely free work in
>> run_ordered_work()".
>>
>> In particular, the endio call may depend on other work items. For
>> example, btrfs_end_dio_bio() can call btrfs_subio_endio_read() ->
>> __btrfs_correct_data_nocsum() -> dio_read_error() ->
>> submit_dio_repair_bio(), which submits a bio that is also completed
>> through a end_workqueue_fn() work item. However,
>> __btrfs_correct_data_nocsum() waits for the newly submitted bio to
>> complete, thus it depends on another work item.
>>
>> This example currently usually works because we use different workqueue
>> helper functions for BTRFS_WQ_ENDIO_DATA and BTRFS_WQ_ENDIO_DIO_REPAIR.
>> However, it may deadlock with stacked filesystems and is fragile
>> overall. The proper fix is to free the work item at the very end of the
>> work function, so let's do that.
>>
>> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
>> Signed-off-by: Omar Sandoval <osandov@fb.com>
>> Reviewed-by: David Sterba <dsterba@suse.com>
>> Signed-off-by: David Sterba <dsterba@suse.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>The were more patches in the series, all contain "don't prematurely free
>work in" and were part of a rework of async work processing. They're
>fixing a very uncommon usecase, so if there's desire to backport them
>the whole series needs to go in.
>
>In the autosel list, there are only 2 and without the important fix.
>
>c495dcd6fbe1 btrfs: don't prematurely free work in run_ordered_work()
>9be490f1e15c btrfs: don't prematurely free work in end_workqueue_fn()
>e732fe95e4ca btrfs: don't prematurely free work in reada_start_machine_worker()
>57d4f0b86327 btrfs: don't prematurely free work in scrub_missing_raid56_worker()

I've queued all 4, thanks!

>a0cac0ec961f btrfs: get rid of unique workqueue helper functions
>- this is only a cleanup that removes code obsoleted by the fixes above,
>  probably out of scope of stable
>
>I have intentionally not tagged the patches for stable, the usecase is
>is specific to one user (FB), the known reproducer is only their
>workload and the fixes are in their kernel already.
>
>So if there's desire to add the patches to stable trees, then it has to
>be the whole series, but I don't see a strong reason for it.

If it's upstream and broken then it's relevant, it doesn't matter if its
one user or a million users.

-- 
Thanks,
Sasha
