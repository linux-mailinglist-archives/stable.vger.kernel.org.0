Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033AB4193EF
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 14:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234266AbhI0MRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 08:17:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234271AbhI0MRk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 08:17:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD77960F94;
        Mon, 27 Sep 2021 12:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632744962;
        bh=ScWr0KJ5dXV0Oy+XMLm1gK9FFaZskQeWFagbStBDCrA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nezlJiXAF9EJ32CvusjWox+b20y+/CH4ZiZ/CkMCCqFVCyU48+B7FvpdVVHT8yRTF
         1KAqINq4Ib227dQ1A8gmx8nHNe0+YNZipqmtHe5foyzQ6nULwiLoeh3lBpZSBb2lgp
         XBR39PpmkoZ5F1PBgjbiG1/kegfndGym3fBSYYwE=
Date:   Mon, 27 Sep 2021 14:15:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     stable@vger.kernel.org, Peter Collingbourne <pcc@google.com>
Subject: Re: [PATCH stable-5.14.y] arm64: add MTE supported check to thread
 switching and syscall entry/exit
Message-ID: <YVG1/z7l4FB0Gz0B@kroah.com>
References: <20210927113124.439854-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210927113124.439854-1-catalin.marinas@arm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 27, 2021 at 12:31:24PM +0100, Catalin Marinas wrote:
> From: Peter Collingbourne <pcc@google.com>
> 
> commit 8c8a3b5bd960cd88f7655b5251dc28741e11f139 upstream.
> 
> This lets us avoid doing unnecessary work on hardware that does not
> support MTE, and will allow us to freely use MTE instructions in the
> code called by mte_thread_switch().
> 
> Since this would mean that we do a redundant check in
> mte_check_tfsr_el1(), remove it and add two checks now required in its
> callers. This also avoids an unnecessary DSB+ISB sequence on the syscall
> exit path for hardware not supporting MTE.
> 
> Fixes: 65812c6921cc ("arm64: mte: Enable async tag check fault")
> Cc: <stable@vger.kernel.org> # 5.13.x
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Link: https://linux-review.googlesource.com/id/I02fd000d1ef2c86c7d2952a7f099b254ec227a5d
> Link: https://lore.kernel.org/r/20210915190336.398390-1-pcc@google.com
> [catalin.marinas@arm.com: adjust the commit log slightly]
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm64/include/asm/mte.h |  6 ++++++
>  arch/arm64/kernel/mte.c      | 10 ++++------
>  2 files changed, 10 insertions(+), 6 deletions(-)

Now queued up, thanks.

greg k-h
