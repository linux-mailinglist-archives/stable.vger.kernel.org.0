Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1DAFE849F
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 10:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfJ2JnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 05:43:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726689AbfJ2JnZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Oct 2019 05:43:25 -0400
Received: from localhost (unknown [91.217.168.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBAB32087E;
        Tue, 29 Oct 2019 09:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572342204;
        bh=wfH6HpOMrQ8JJk8YTc5ZX31N64KCBGtRjp8Rl5bdk6I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N6PYH1H7UaLzWmvmxEWgivHothCUvMDoCzLVUxBgJJzQcnq9REoG/81uZa0IEJ3ON
         A/xdIqe0+c5pGvU6Aluh9PzjwoLuqfiqOUg6B//pZn9Ovn8PEy+bSgQGqAjzGkpcok
         Zk3vHCiX+9rOoI5ualgUjzkh+5r2dxIMm1BbPo9Y=
Date:   Tue, 29 Oct 2019 10:43:21 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 095/100] USB: usb-skeleton: fix
 use-after-free after driver unbind
Message-ID: <20191029094321.GA582711@kroah.com>
References: <20191018220525.9042-1-sashal@kernel.org>
 <20191018220525.9042-95-sashal@kernel.org>
 <20191018222205.GA6978@kroah.com>
 <20191029090435.GJ1554@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029090435.GJ1554@sasha-vm>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 29, 2019 at 05:04:35AM -0400, Sasha Levin wrote:
> On Fri, Oct 18, 2019 at 06:22:05PM -0400, Greg Kroah-Hartman wrote:
> > On Fri, Oct 18, 2019 at 06:05:20PM -0400, Sasha Levin wrote:
> > > From: Johan Hovold <johan@kernel.org>
> > > 
> > > [ Upstream commit 6353001852776e7eeaab4da78922d4c6f2b076af ]
> > > 
> > > The driver failed to stop its read URB on disconnect, something which
> > > could lead to a use-after-free in the completion handler after driver
> > > unbind in case the character device has been closed.
> > > 
> > > Fixes: e7389cc9a7ff ("USB: skel_read really sucks royally")
> > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > Link: https://lore.kernel.org/r/20191009170944.30057-3-johan@kernel.org
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  drivers/usb/usb-skeleton.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > 
> > This file does not even get built in the kernel tree, no need to
> > backport anything for it :)
> 
> I'll drop it, but you're taking patches for this driver:
> https://lore.kernel.org/patchwork/patch/1140673/ .

Ah yeah, I probably shouldn't have taken stable backports for that, my
fault.

greg k-h
