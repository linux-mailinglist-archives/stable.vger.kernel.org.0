Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B20093CBB7D
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 19:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhGPSCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 14:02:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhGPSCR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 14:02:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D607613DF;
        Fri, 16 Jul 2021 17:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626458361;
        bh=UZwZLRE3vfqLx94fgQJAse31HPlOeSvrngcUsGW4CVQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dKGmgvRCxKHFAXAzx5ueANsDOFL2M8S1jl+NQwhN3USmvRp0PkKh97I5osJyB3yhn
         piZjCl3jtt8VnRXK+rtyQbkqwQev4hh5wFO8sb6HnKNLQpwM2JgE2PuAVC98Vn6fbn
         rNaCrBjaoh1+DqdvVCXEUFgNmUQ7H5b9e3PoaDbg=
Date:   Fri, 16 Jul 2021 19:59:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+faf11bbadc5a372564da@syzkaller.appspotmail.com,
        Antti Palosaari <crope@iki.fi>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: Re: [PATCH 5.13 252/266] media: rtl28xxu: fix zero-length control
 request
Message-ID: <YPHI9iIUnBFchvmq@kroah.com>
References: <20210715182613.933608881@linuxfoundation.org>
 <20210715182652.248759867@linuxfoundation.org>
 <YPE7Se31LQnaikuy@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPE7Se31LQnaikuy@hovoldconsulting.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 16, 2021 at 09:54:49AM +0200, Johan Hovold wrote:
> On Thu, Jul 15, 2021 at 08:40:07PM +0200, Greg Kroah-Hartman wrote:
> > From: Johan Hovold <johan@kernel.org>
> > 
> > commit 25d5ce3a606a1eb23a9265d615a92a876ff9cb5f upstream.
> > 
> > The direction of the pipe argument must match the request-type direction
> > bit or control requests may fail depending on the host-controller-driver
> > implementation.
> > 
> > Control transfers without a data stage are treated as OUT requests by
> > the USB stack and should be using usb_sndctrlpipe(). Failing to do so
> > will now trigger a warning.
> > 
> > Fix the zero-length i2c-read request used for type detection by
> > attempting to read a single byte instead.
> > 
> > Reported-by: syzbot+faf11bbadc5a372564da@syzkaller.appspotmail.com
> > Fixes: d0f232e823af ("[media] rtl28xxu: add heuristic to detect chip type")
> > Cc: stable@vger.kernel.org      # 4.0
> > Cc: Antti Palosaari <crope@iki.fi>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Please drop this patch from all stable trees. 
> 
> This patch causes a regression and a second version was sent almost two
> months ago, but I'm not getting any response whatsoever from the media
> maintainers. 
> 
> I resent the correct fix and a revert of this one almost a month ago and
> the cover letter includes some further details:
> 
> 	https://lore.kernel.org/r/20210623084521.7105-1-johan@kernel.org
> 
> But this still hasn't been fixed in linux-next.

Now dropped from all stable queues, thanks.

greg k-h
