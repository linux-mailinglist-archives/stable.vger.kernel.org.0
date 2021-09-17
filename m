Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8598440F40D
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 10:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244997AbhIQI0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 04:26:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243646AbhIQI0u (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Sep 2021 04:26:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F2AB611C3;
        Fri, 17 Sep 2021 08:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631867129;
        bh=CSIDt2jIttDSppcDogg4dSvJUyrt+SztAzo3xfKPArQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O7ftwHAObwxpx0lp/QozRdYMBej++TDJVoIX1D1qMz4HNo7FS2c7ZYZwE9LncI+aU
         Omo20XW7DDyc5VZvG5jEUtls8joZBp/Cw1YLMLOZEAaCYhN+A6XvI10ZyaYSYt1FXF
         3e15eeZ/7fHjtfAiFTRFwJVftiyL1Q5QHJ65etXc=
Date:   Fri, 17 Sep 2021 10:25:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Lukas Hannen <lukas.hannen@opensource.tttech-industrial.com>
Subject: Re: [PATCH 5.14 298/334] time: Handle negative seconds correctly in
 timespec64_to_ns()
Message-ID: <YURQ9o1rDeqmUkSL@kroah.com>
References: <20210913131113.390368911@linuxfoundation.org>
 <20210913131123.500712780@linuxfoundation.org>
 <CAK8P3a0z5jE=Z3Ps5bFTCFT7CHZR1JQ8VhdntDJAfsUxSPCcEw@mail.gmail.com>
 <874kak9moe.ffs@tglx>
 <CAK8P3a0mAOgo_7xVfHr2YfeKa8xQPH6GfafB96NPvFAnQF_LBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a0mAOgo_7xVfHr2YfeKa8xQPH6GfafB96NPvFAnQF_LBg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 17, 2021 at 09:31:33AM +0200, Arnd Bergmann wrote:
> On Fri, Sep 17, 2021 at 12:32 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Wed, Sep 15 2021 at 21:00, Arnd Bergmann wrote:
> >
> > I have done the analysis. setitimer() does not have any problem with
> > that simply because it already checks at the call site that the seconds
> > value is > 0 and so do all the other user visible interfaces. See
> > get_itimerval() ...
> 
> Right, I now came to the same conclusion after taking a closer look,
> see my reply from yesterday.
> 
> > Granted  that the kernel internal interfaces do not have those checks,
> > but they already have other safety nets in place to prevent this and I
> > could not identify any callsite which has trouble with that change.
> >
> > If I failed to spot one then what the heck is the problem? It was broken
> > before that change already!
> 
> My bad for the unfortunate timing. When only saw the patch when Greg
> posted it during the stable review and wasn't completely sure about it
> at the time, so I was hoping that he could just hold off until you had a chance
> to reply either saying that you had already checked this case or that it
> was dangerous, but now it's already reverted.
> 
> I agree we should put back the fix into all stable kernels.

Ok, I'll queue it up again after this round goes out.

thanks for the additional review.

greg k-h
