Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F035E1092FA
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 18:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbfKYRlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 12:41:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:46486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbfKYRlF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 12:41:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EABD220835;
        Mon, 25 Nov 2019 17:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574703665;
        bh=B705o2O9nueunH95SS6+Tbmc79pENOFph/Yp7UTp9y4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TWTF+Rc+1QNj+TF6e/5EYlY7s0rlyPDkdx4+xTwy4rSH5Gosc9wnFMPC4uB2GFsoF
         sa/xH7rmhOqe4W08IGtv2kPul9qzxZ8+fHGCYwuDzU2QxYhfU3dPwa2sy6BwS6kzfh
         DjkHt5SNlI7l5ebsHd2pA7udDQPhx3QeBBoIIZVY=
Date:   Mon, 25 Nov 2019 18:41:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 3/8] arm64: fix for bad_mode() handler to always
 result in panic
Message-ID: <20191125174103.GA2872072@kroah.com>
References: <20191122105253.11375-1-lee.jones@linaro.org>
 <20191122105253.11375-3-lee.jones@linaro.org>
 <20191125134700.GA5861@sasha-vm>
 <20191125144429.GF3296@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191125144429.GF3296@dell>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 25, 2019 at 02:44:29PM +0000, Lee Jones wrote:
> On Mon, 25 Nov 2019, Sasha Levin wrote:
> 
> > On Fri, Nov 22, 2019 at 10:52:48AM +0000, Lee Jones wrote:
> > > From: Hari Vyas <hari.vyas@broadcom.com>
> > > 
> > > [ Upstream commit e4ba15debcfd27f60d43da940a58108783bff2a6 ]
> > > 
> > > The bad_mode() handler is called if we encounter an uunknown exception,
> > > with the expectation that the subsequent call to panic() will halt the
> > > system. Unfortunately, if the exception calling bad_mode() is taken from
> > > EL0, then the call to die() can end up killing the current user task and
> > > calling schedule() instead of falling through to panic().
> > > 
> > > Remove the die() call altogether, since we really want to bring down the
> > > machine in this "impossible" case.
> > 
> > Should this be in newer LTS kernels too? I don't see it in 4.14. We
> > can't take anything into older kernels if it's not in newer ones - we
> > don't want to break users who update their kernels.
> 
> Only; 3.18, 4.4, 4.9 and 5.3 were studied.
> 
> I can look at others if it helps.

You have to look at others, we can't have regressions if people move
from one LTS to a newer one.

thanks,

greg k-h
