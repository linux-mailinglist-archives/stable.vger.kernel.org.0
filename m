Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB5348E8C1
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 12:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234464AbiANLAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 06:00:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53218 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbiANLAG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 06:00:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 236D4B82595;
        Fri, 14 Jan 2022 11:00:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A5BC36AEA;
        Fri, 14 Jan 2022 11:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642158004;
        bh=g8GfDmbZOSBMNBxcz5maGzA55wGu69eVfbZjs4FrWM0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=si2NFGFTuRwOv6Z3sKaucEUFv3ySdvbU8l/87RdFbHGduJsNfeeLpWCMyRV3L834B
         2w6jw427qNZ1kAqd2aHNADTd9em51F1M3kgamHZJMV19i/Dy+KYoKKXT0yNwQuRJgO
         +JaC6244Shpnr4JXxMjJPqe8A/irXERHTHcInkEw=
Date:   Fri, 14 Jan 2022 12:00:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4.y] Revert "ia64: kprobes: Use generic kretprobe
 trampoline handler"
Message-ID: <YeFXsJVt1I7yWtDj@kroah.com>
References: <YeEhuGXr2B9r7mer@kroah.com>
 <164215559880.1662358.1475310445318313122.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164215559880.1662358.1475310445318313122.stgit@devnote2>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 14, 2022 at 07:19:59PM +0900, Masami Hiramatsu wrote:
> This reverts commit 77fa5e15c933a1ec812de61ad709c00aa51e96ae.
> 
> Since the upstream commit e792ff804f49720ce003b3e4c618b5d996256a18
> depends on the generic kretprobe trampoline handler, which was
> introduced by commit 66ada2ccae4e ("kprobes: Add generic kretprobe
> trampoline handler") but that is not ported to the stable kernel
> because it is not a bugfix series.
> So revert this commit to fix a build error.
> 
> NOTE: I keep commit a7fe2378454c ("ia64: kprobes: Fix to pass
> correct trampoline address to the handler") on the tree, that seems
> just a cleanup without the original reverted commit, but it would
> be better to use dereference_function_descriptor() macro instead
> of accessing descriptor's field directly.
> 
> 
> Fixes: 77fa5e15c933 ("ia64: kprobes: Use generic kretprobe trampoline handler")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> ---
>  arch/ia64/kernel/kprobes.c |   78 ++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 75 insertions(+), 3 deletions(-)

Thanks for this, I'll queue it up after this round of stable releases
are out.

greg k-h
