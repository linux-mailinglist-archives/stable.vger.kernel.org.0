Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1021C195105
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 07:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgC0G0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 02:26:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725857AbgC0G0v (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Mar 2020 02:26:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91A7220705;
        Fri, 27 Mar 2020 06:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585290410;
        bh=C+c/5oL+UO0v+m4Q/VCcV4JwRE2JWyTk69oWVbv2Q6E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vhT4TRi3LgnelhiRvdEj6xnuN3X/CneXgQ7Lx9L4aa6N3wxj5y4NSLz/zM9GjRnlj
         tMQanEKBXNq5bAjFPPuM0MoCXQRFD+u6YjvK80wECzNqTNKekdFFjj9hmcXDNWoZAb
         rSgJdpLjCTVcwqq6PlD8Ln3rBazWQLU0SSwfA7Qs=
Date:   Fri, 27 Mar 2020 07:26:46 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Dmitry Vyukov <dvyukov@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.5 23/28] kconfig: Add yes2modconfig and
 mod2yesconfig targets.
Message-ID: <20200327062646.GB1601217@kroah.com>
References: <20200326232357.7516-1-sashal@kernel.org>
 <20200326232357.7516-23-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326232357.7516-23-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 26, 2020 at 07:23:52PM -0400, Sasha Levin wrote:
> From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> 
> [ Upstream commit 89b9060987d988333de59dd218c9666bd7ee95a5 ]
> 
> Since kernel configs provided by syzbot are close to "make allyesconfig",
> it takes long time to rebuild. This is especially waste of time when we
> need to rebuild for many times (e.g. doing manual printk() inspection,
> bisect operations).
> 
> We can save time if we can exclude modules which are irrelevant to each
> problem. But "make localmodconfig" cannot exclude modules which are built
> into vmlinux because /sbin/lsmod output is used as the source of modules.
> 
> Therefore, this patch adds "make yes2modconfig" which converts from =y
> to =m if possible. After confirming that the interested problem is still
> reproducible, we can try "make localmodconfig" (and/or manually tune
> based on "Modules linked in:" line) in order to exclude modules which are
> irrelevant to the interested problem. While we are at it, this patch also
> adds "make mod2yesconfig" which converts from =m to =y in case someone
> wants to convert from =m to =y after "make localmodconfig".
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  scripts/kconfig/Makefile   |  4 +++-
>  scripts/kconfig/conf.c     | 16 ++++++++++++++++
>  scripts/kconfig/confdata.c | 16 ++++++++++++++++
>  scripts/kconfig/lkc.h      |  3 +++
>  4 files changed, 38 insertions(+), 1 deletion(-)

Why did this patch get picked up by the autobot?  Because it referenced
syzbot?

It adds a new feature, that isn't really needed by any stable things, so
it should be dropped from your queues for all trees.

thanks,

greg k-h
