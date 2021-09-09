Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874C04044F2
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 07:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350699AbhIIFYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 01:24:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350690AbhIIFYk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 01:24:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6AED61139;
        Thu,  9 Sep 2021 05:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631165011;
        bh=2030Fa3YA+ALwsrAEP90On+6Fw88IVjxq61IUtIdhV0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ofdOSHCjC2bZdTClUyhHpLOrIhzmwzJWcdL0oE6HlAgJkAUoggNeenB+naTovUkiK
         TFp7K/PQM/zgJJVmiFlc9bkZ1cQwTugQs9ROWBSbj2Qa+pvNoGtOHjXLqCdlVuKBOa
         EP7GkbgykF/eq1z3Hvm1pw1OcmrxvDjyqe30BW7M=
Date:   Thu, 9 Sep 2021 07:23:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jaegeuk Kim <jaegeuk@google.com>
Cc:     stable@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>
Subject: Re: [PATCH] f2fs: guarantee to write dirty data when enabling
 checkpoint back
Message-ID: <YTmaPCd3/cpMyNEe@kroah.com>
References: <20210908220020.599899-1-jaegeuk@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210908220020.599899-1-jaegeuk@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 08, 2021 at 03:00:20PM -0700, Jaegeuk Kim wrote:
> From: Jaegeuk Kim <jaegeuk@kernel.org>
> 
> commit dddd3d65293a52c2c3850c19b1e5115712e534d8 upstream.
> 
> We must flush all the dirty data when enabling checkpoint back. Let's guarantee
> that first by adding a retry logic on sync_inodes_sb(). In addition to that,
> this patch adds to flush data in fsync when checkpoint is disabled, which can
> mitigate the sync_inodes_sb() failures in advance.
> 
> Reviewed-by: Chao Yu <chao@kernel.org>
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/file.c  |  5 ++---
>  fs/f2fs/super.c | 11 ++++++++++-
>  2 files changed, 12 insertions(+), 4 deletions(-)

What stable kernel(s) are you wanting to have this backported to?

thanks,

greg k-h
