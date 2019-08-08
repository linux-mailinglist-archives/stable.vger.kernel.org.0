Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB9385D9F
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 11:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731038AbfHHJA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 05:00:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731031AbfHHJA3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 05:00:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D63AB217F4;
        Thu,  8 Aug 2019 09:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565254828;
        bh=SRqtwHkeZ7xZQv9nJbXGMQt5Wm1SZ4F/TAG6xDWQXKI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kuH9kJKeSM8oFMqyAyrDwvFTEciUq7x1sfRT5G5JfNnNWY9QeDPYNNWpJEsebVjnM
         ouc8NK6xc5o9gPKPiWriQgXTwyJMQ16v68Fqgv3iA/zcNPkiJIpoyv1YaIGyVpzUAo
         o01qt5Pju6n/EOIATncfRTrUwkv3VmlYsHqs7Mks=
Date:   Thu, 8 Aug 2019 11:00:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, xiao jin <jin.xiao@intel.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v4.4.y, v4.9.y] block: blk_init_allocated_queue() set
 q->fq as NULL in the fail case
Message-ID: <20190808090025.GB1265@kroah.com>
References: <1565032365-7089-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565032365-7089-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 12:12:45PM -0700, Guenter Roeck wrote:
> From: xiao jin <jin.xiao@intel.com>
> 
> commit 54648cf1ec2d7f4b6a71767799c45676a138ca24 upstream
> 
> We find the memory use-after-free issue in __blk_drain_queue()
> on the kernel 4.14. After read the latest kernel 4.18-rc6 we
> think it has the same problem.
> 
> Memory is allocated for q->fq in the blk_init_allocated_queue().
> If the elevator init function called with error return, it will
> run into the fail case to free the q->fq.
> 
> Then the __blk_drain_queue() uses the same memory after the free
> of the q->fq, it will lead to the unpredictable event.
> 
> The patch is to set q->fq as NULL in the fail case of
> blk_init_allocated_queue().
> 
> Fixes: commit 7c94e1c157a2 ("block: introduce blk_flush_queue to drive flush machinery")
> Cc: <stable@vger.kernel.org>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
> Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
> Signed-off-by: xiao jin <jin.xiao@intel.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> [groeck: backport to v4.4.y/v4.9.y (context change)]
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> This patch was not applied to v4.4.y and v4.9.y due to a context conflict.
> See https://lore.kernel.org/stable/1536310209129100@kroah.com/ and
> https://lore.kernel.org/stable/153631018011582@kroah.com/ for details.
> It was applied to v4.14.y and to v4.18.y.
> 
> Please consider applying this backport. It is relevant because it fixes
> CVE-2018-20856.

Now queued up, thanks.

greg k-h
