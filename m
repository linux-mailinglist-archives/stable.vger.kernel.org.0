Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D417F3C75A3
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 19:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhGMRXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 13:23:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229454AbhGMRXp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Jul 2021 13:23:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E778661183;
        Tue, 13 Jul 2021 17:20:53 +0000 (UTC)
Date:   Tue, 13 Jul 2021 18:20:46 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chen Huang <chenhuang5@huawei.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] arm64: Avoid premature usercopy failure
Message-ID: <20210713172045.GD13181@arm.com>
References: <dc03d5c675731a1f24a62417dba5429ad744234e.1626098433.git.robin.murphy@arm.com>
 <20210713165957.GA30304@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210713165957.GA30304@willie-the-truck>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 13, 2021 at 05:59:58PM +0100, Will Deacon wrote:
> On Mon, Jul 12, 2021 at 03:27:46PM +0100, Robin Murphy wrote:
> > Al reminds us that the usercopy API must only return complete failure
> > if absolutely nothing could be copied. Currently, if userspace does
> > something silly like giving us an unaligned pointer to Device memory,
> > or a size which overruns MTE tag bounds, we may fail to honour that
> > requirement when faulting on a multi-byte access even though a smaller
> > access could have succeeded.
> > 
> > Add a mitigation to the fixup routines to fall back to a single-byte
> > copy if we faulted on a larger access before anything has been written
> > to the destination, to guarantee making *some* forward progress. We
> > needn't be too concerned about the overall performance since this should
> > only occur when callers are doing something a bit dodgy in the first
> > place. Particularly broken userspace might still be able to trick
> > generic_perform_write() into an infinite loop by targeting write() at
> > an mmap() of some read-only device register where the fault-in load
> > succeeds but any store synchronously aborts such that copy_to_user() is
> > genuinely unable to make progress, but, well, don't do that...
> > 
> > CC: stable@vger.kernel.org
> > Reported-by: Chen Huang <chenhuang5@huawei.com>
> > Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
> > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> > ---
> > 
> > I've started trying the "replay" approach for figuring out more precise
> > remainders in general, but that quickly got more complicated with
> > rebasing the fault address passing stuff, so I'm resending this now as
> > a point fix and will continue to explore that as an improvement on top.
> 
> Is it possible to add/extend a selftest for this, please? I think Catalin
> mentioned that before, but not sure if he got anywhere with it.

It's on my to-do list but going on holiday soon. If Robin is keen on
this, I don't really mind ;).

-- 
Catalin
