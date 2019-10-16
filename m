Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5046BD9C60
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 23:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfJPVTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:19:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726402AbfJPVTu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:19:50 -0400
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40E5D218DE;
        Wed, 16 Oct 2019 21:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571260788;
        bh=kxpZ4NEap8M1vdSe2cZZiHuUNUT660ZZnycJscME2II=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C+BrehFiJ9yZhY6n0se3JuH6N0NMyVe4nGDucb1CdC52CJskcelUStOfU0XePHWM+
         tZ6+9huDFavePTuVQZVu3bg1jMxwemwFRZEC6FIeWubXJ4GgUqJ7mRrQTPoNwzJAOq
         aTK50GkLatPY06mXFtxAkvuIDekFsR0BNmYVeWaE=
Date:   Wed, 16 Oct 2019 14:19:43 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Doug Anderson <dianders@chromium.org>
Cc:     Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        jolsa@redhat.com, namhyung@kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alix Wu <alix.wu@mediatek.com>,
        YJ Chiang <yj.chiang@mediatek.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] perf/hw_breakpoint: Fix arch_hw_breakpoint
 use-before-initialization
Message-ID: <20191016211943.GD856391@kroah.com>
References: <20190906060115.9460-1-mark-pk.tsai@mediatek.com>
 <CAD=FV=Vxdnecw2SnUeFpa8Rqq0DSTTeoD_bE1GXk4q37usZ9-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=Vxdnecw2SnUeFpa8Rqq0DSTTeoD_bE1GXk4q37usZ9-w@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 10, 2019 at 10:44:13AM -0700, Doug Anderson wrote:
> Hi,
> 
> On Thu, Sep 5, 2019 at 11:01 PM Mark-PK Tsai <mark-pk.tsai@mediatek.com> wrote:
> >
> > If we disable the compiler's auto-initialization feature
> > (-fplugin-arg-structleak_plugin-byref or -ftrivial-auto-var-init=pattern)
> > is disabled, arch_hw_breakpoint may be used before initialization after
> > the change 9a4903dde2c86.
> > (perf/hw_breakpoint: Split attribute parse and commit)
> >
> > On our arm platform, the struct step_ctrl in arch_hw_breakpoint, which
> > used to be zero-initialized by kzalloc, may be used in
> > arch_install_hw_breakpoint without initialization.
> >
> > Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
> > Cc: YJ Chiang <yj.chiang@mediatek.com>
> > Cc: Alix Wu <alix.wu@mediatek.com>
> > ---
> >  kernel/events/hw_breakpoint.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Stable should pick this up, please.  It landed in mainline as commit
> 310aa0a25b33 ("perf/hw_breakpoint: Fix arch_hw_breakpoint
> use-before-initialization").
> 
> * I have confirmed that it cleanly applies to and fixes a kernel based
> on v4.19.75, so picking it back to kernels 4.19+ is the easiest.
> 
> * I have confirmed that my test shows that hardware breakpoints fail
> on my arm32 test machine on v4.18.20 and on v4.17.0.  They last worked
> on 4.16.  Picking this patch alone is not sufficient to make 4.17 and
> 4.18 work again.  Bisecting shows that the first breakage was the
> merge resolution that happened in commit 2d074918fb15 ("Merge branch
> 'perf/urgent' into perf/core").  Specifically both parents of that
> merge passed my test but the result of the merge didn't pass my test.
> If anyone cares about 4.17 and 4.18 at this point, I will leave it as
> an exercise to them to try to get them working again.

Now queued up to 4.19.y, thanks.

greg k-h
