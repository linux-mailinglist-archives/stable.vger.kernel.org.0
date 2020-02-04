Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B206F15186E
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 11:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgBDKFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 05:05:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:40110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbgBDKFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Feb 2020 05:05:38 -0500
Received: from localhost (unknown [212.187.182.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DDCA2192A;
        Tue,  4 Feb 2020 10:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580810738;
        bh=sVWw5io65CFud55R48cwmbeybCwucc32GqEz2clXunY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ax84ru3DK2QxnRTnncBb96xb4kYi7b9Nl02GW0bc1uYLwCNmBIZKvAejB5unuRIbP
         swUYQujkGap5VWVJB/accBIEXOfyiz0/V9EXV6CS0OpVIqIrjk8o/j6nyJfou35mT8
         Ps/R7s0IwOQNnQffVe81oqnurYtgOu/hAz+uqYaw=
Date:   Tue, 4 Feb 2020 10:02:32 +0000
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        stable@vger.kernel.org, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: Re: [PATCH 1/7] Input: pegasus_notetaker: fix endpoint sanity check
Message-ID: <20200204100232.GB1088789@kroah.com>
References: <20191210113737.4016-1-johan@kernel.org>
 <20191210113737.4016-2-johan@kernel.org>
 <20200204082441.GD26725@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204082441.GD26725@localhost>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 04, 2020 at 09:24:41AM +0100, Johan Hovold wrote:
> On Tue, Dec 10, 2019 at 12:37:31PM +0100, Johan Hovold wrote:
> > The driver was checking the number of endpoints of the first alternate
> > setting instead of the current one, something which could be used by a
> > malicious device (or USB descriptor fuzzer) to trigger a NULL-pointer
> > dereference.
> > 
> > Fixes: 1afca2b66aac ("Input: add Pegasus Notetaker tablet driver")
> > Cc: stable <stable@vger.kernel.org>     # 4.8
> > Cc: Martin Kepplinger <martink@posteo.de>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> 
> Looks like the stable tag was removed when this one was applied, and
> similar for patches 2, 4 and 7 of this series (commits 3111491fca4f,
> a8eeb74df5a6, 6b32391ed675 upstream).
> 
> While the last three are mostly an issue for the syzbot fuzzer, we have
> started backporting those as well.
> 
> This one (bcfcb7f9b480) is more clear cut as it can be used to trigger a
> NULL-deref.
> 
> I only noticed because Sasha picked up one of the other patches in the
> series which was never intended for stable.

Did I end up catching all of these properly?  I've had to expand my
search for some patches like this that do not explicitly have the cc:
stable mark on them as not all subsystems do this well (if at all.)

And there's also Sasha's work in digging up patches based on patterns of
fixes, which also is needed because of this "problem".

thanks,

greg k-h
