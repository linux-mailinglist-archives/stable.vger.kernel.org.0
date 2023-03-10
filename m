Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2260D6B51A9
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 21:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbjCJURn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 15:17:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbjCJURc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 15:17:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9975F12EAFE;
        Fri, 10 Mar 2023 12:17:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B3E4B823B0;
        Fri, 10 Mar 2023 20:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F438C433D2;
        Fri, 10 Mar 2023 20:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678479418;
        bh=D4DGMOutQIagUSkQSfayXkAW83Yt6sHT11ClPGwvv3g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SfLZqwiqB+4qdjVAnpc7fysl5QdvXXucG1ABItriZUuvRvbN5a9SzXtfj5VTTRB3w
         BduuUA/pAlevJ7qpQj9Le0yTGkal3f0M7BO6c9HoVVzOMWGlc5lwYb15azC2nYU9y0
         jk9K/rKDgjnyVv8vahvgwJhSJi3nJNIya0iAS/DrDL3nz7QvybmnYr4gA8GSkb/IJa
         mDVCrDdg9bgMfwa183GzMe6Or8PPZoMgM+WmvIdnbFJtkGXx/FpU2RjEpF2mcLD+Q1
         HXiDEPAwqOwT8Kpf3NdbdthtGURBqTHol1h2zyQA1S74jHluh49RVZ/LcmxHqokW/B
         aPA5TTmm/bbzg==
Date:   Fri, 10 Mar 2023 12:16:56 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mike Cloaked <mike.cloaked@gmail.com>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Possible kernel fs block code regression in 6.2.3 umounting usb
 drives
Message-ID: <ZAuQOHnfa7xGvzKI@sol.localdomain>
References: <CAOCAAm7AEY9tkZpu2j+Of91fCE4UuE_PqR0UqNv2p2mZM9kqKw@mail.gmail.com>
 <CAOCAAm4reGhz400DSVrh0BetYD3Ljr2CZen7_3D4gXYYdB4SKQ@mail.gmail.com>
 <ZAuPkCn49urWBN5P@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAuPkCn49urWBN5P@sol.localdomain>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 10, 2023 at 12:14:10PM -0800, Eric Biggers wrote:
> On Fri, Mar 10, 2023 at 07:33:37PM +0000, Mike Cloaked wrote:
> > With kerne. 6.2.3 if I simply plug in a usb external drive, mount it
> > and umount it, then the journal has a kernel Oops and I have submitted
> > a bug report, that includes the journal output, at
> > https://bugzilla.kernel.org/show_bug.cgi?id=217174
> > 
> > As soon as the usb drive is unmounted, the kernel Oops occurs, and the
> > machine hangs on shutdown and needs a hard reboot.
> > 
> > I have reproduced the same issue on three different machines, and in
> > each case downgrading back to kernel 6.2.2 resolves the issue and it
> > no longer occurs.
> > 
> > This would seem to be a regression in kernel 6.2.3
> > 
> > Mike C
> 
> Thanks for reporting this!  If this is reliably reproducible and is known to be
> a regression between v6.2.2 and v6.2.3, any chance you could bisect it to find
> out the exact commit that introduced the bug?
> 
> For reference I'm also copying the stack trace from bugzilla below:
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000028
>  #PF: supervisor read access in kernel mode
>  #PF: error_code(0x0000) - not-present page
>  PGD 0 P4D 0
>  Oops: 0000 [#1] PREEMPT SMP PTI
>  CPU: 9 PID: 1118 Comm: lvcreate Tainted: G                T  6.2.3-1>
>  Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z370 Ex>
>  RIP: 0010:blk_throtl_update_limit_valid+0x1f/0x110

BTW, the block/ commits between v6.2.2 and v6.2.3 were:

	blk-mq: avoid sleep in blk_mq_alloc_request_hctx
	blk-mq: remove stale comment for blk_mq_sched_mark_restart_hctx
	blk-mq: wait on correct sbitmap_queue in blk_mq_mark_tag_wait
	blk-mq: Fix potential io hung for shared sbitmap per tagset
	blk-mq: correct stale comment of .get_budget
	block: sync mixed merged request's failfast with 1st bio's
	block: Fix io statistics for cgroup in throttle path
	block: bio-integrity: Copy flags when bio_integrity_payload is cloned
	block: use proper return value from bio_failfast()
	blk-iocost: fix divide by 0 error in calc_lcoefs()
	blk-cgroup: dropping parent refcount after pd_free_fn() is done
	blk-cgroup: synchronize pd_free_fn() from blkg_free_workfn() and blkcg_deactivate_policy()
	block: don't allow multiple bios for IOCB_NOWAIT issue
	block: clear bio->bi_bdev when putting a bio back in the cache
	block: be a bit more careful in checking for NULL bdev while polling

Without having any in-depth knowledge here, I think "blk-cgroup: synchronize
pd_free_fn() from blkg_free_workfn() and blkcg_deactivate_policy()" looks the
most suspicious here...  I see that AUTOSEL selected it from a 3-patch series
without backporting patch 2, maybe that could be it?  Anyway, just a hunch.

- Eric
