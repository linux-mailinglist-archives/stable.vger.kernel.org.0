Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39773E1AAD
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 19:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240657AbhHERnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 13:43:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240703AbhHERnp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Aug 2021 13:43:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46553610A2;
        Thu,  5 Aug 2021 17:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628185410;
        bh=jbxeXIpT5Jcq66oh7AFrJ9FETcsZ7JN1eyFOk5hsZuA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MVNpv6KWWuyjdDYlikW21vcIhfNOc9n0jrIUDlnpf6lZYkW8HfOIvYH99zZS/P7xO
         T+TWoyWhC7hV9UchRBLhDqEANqUV8SmATxv+y3WDr1C+NVfVxb0E1iLKsnuVKCcJXl
         UVbNml1OeWv7Hq1J1fqO/eMulwR4NPEZFcrmpl6U=
Date:   Thu, 5 Aug 2021 19:43:20 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: Regressions in stable releases
Message-ID: <YQwjOK9lfbzEyK2d@kroah.com>
References: <efee3a58-a4d2-af22-0931-e81b877ab539@roeck-us.net>
 <YQwPg1VQZTyPSkXe@kroah.com>
 <20210805173922.GB3691426@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210805173922.GB3691426@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 05, 2021 at 10:39:22AM -0700, Guenter Roeck wrote:
> On Thu, Aug 05, 2021 at 06:19:15PM +0200, Greg Kroah-Hartman wrote:
> > On Thu, Aug 05, 2021 at 09:11:02AM -0700, Guenter Roeck wrote:
> > > Hi folks,
> > > 
> > > we have (at least) two severe regressions in stable releases right now.
> > > 
> > > [SHAs are from linux-5.10.y]
> > > 
> > > 2435dcfd16ac spi: mediatek: fix fifo rx mode
> > > 	Breaks SPI access on all Mediatek devices for small transactions
> > > 	(including all Mediatek based Chromebooks since they use small SPI
> > > 	 transactions for EC communication)
> > > 
> > > 60789afc02f5 Bluetooth: Shutdown controller after workqueues are flushed or cancelled
> > > 	Breaks Bluetooth on various devices (Mediatek and possibly others)
> > > 	Discussion: https://lkml.org/lkml/2021/7/28/569
> > 
> > Are either of these being tracked on the regressions list?  I have not
> > noticed them being reported there, or on the stable list :(
> > 
> 
> I wasn't aware of regressions@lists.linux.dev. Clueless me. And this is the
> report on the stable list, or at least that was the idea. Should I send separate
> emails to regressions@ with details ?

For regressions in Linus's tree, yes please do.  I have seen many stable
regressions also sent there as they mirror regressions in Linus's tree
(right now there is at least one ACPI regression that hopefully will
show up in Linus's tree soon that has hit stable as well..)

> > > Unfortunately, it appears that all our testing doesn't cover SPI and Bluetooth.
> > > 
> > > I understand that upstream is just as broken until fixes are applied there.
> > > Still, it shows that our test coverage is far from where it needs to be,
> > > and/or that we may be too aggressive with backporting patches to stable
> > > releases.
> > > 
> > > If you have an idea how to improve the situation, please let me know.
> > 
> > We need to get tests running in kernelci on real hardware, that's going
> > to be much more helpful here.
> > 
> 
> Yes, I know. Of course it didn't help that our internal testing didn't catch
> the problem until after the fact either.

There will always be issues that can only be caught on real hardware, we
are all just human.  The goal is to handle them quickly when they are
caught.

I'll go revert the above commits now, thanks.

greg k-h
