Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD6C481A62
	for <lists+stable@lfdr.de>; Thu, 30 Dec 2021 08:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234956AbhL3HcO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Dec 2021 02:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbhL3HcN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Dec 2021 02:32:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFF2C061574;
        Wed, 29 Dec 2021 23:32:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BE5C615AD;
        Thu, 30 Dec 2021 07:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD66C36AEA;
        Thu, 30 Dec 2021 07:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640849532;
        bh=fTlbX69b1TE5ecNQTd63Ir4AKz2MQa5eiX/0zAWznJ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W4rtyz+L7eeAEXzWSFK5E5xBMsDJU/tNBJQohIe6ClCwpfUJZQpyKdNA6t2s6C4Wi
         U5DrM/YxezxbLErPfgulmM4Q9swsaeWEvUTULit+1JotcmWVrsdY5MHYi+O2UaJjM5
         +exctEyJTR1uLqrvBpOEzzJwGfHKL/nCNPlovick=
Date:   Thu, 30 Dec 2021 08:32:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: Should write-time tree-checker backported to v5.10?
Message-ID: <Yc1geWndI9h6rXJI@kroah.com>
References: <8b9f45d8-768a-d76d-3de1-f3998dd77e41@gmx.com>
 <Yc1X/HqU8zK85xFd@kroah.com>
 <6766e94a-37ba-6635-1e4d-1e256739e195@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6766e94a-37ba-6635-1e4d-1e256739e195@gmx.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 30, 2021 at 03:10:13PM +0800, Qu Wenruo wrote:
> 
> 
> On 2021/12/30 14:55, Greg KH wrote:
> > On Thu, Dec 30, 2021 at 08:06:49AM +0800, Qu Wenruo wrote:
> > > Hi,
> > > 
> > > Since v5.10 is an LTS release, I'm wondering should we backport write
> > > time tree-checker feature to v5.10?
> > > 
> > > There are already some reports of runtime memory bitflip get written to
> > > disk and causing problems.
> > > 
> > > Unfortunately write-time tree-checker is only introduced in v5.11, one
> > > version late.
> > > 
> > > Considering how many bitflips write-time tree-checker has caught (and
> > > prevented corrupted data reaching disk), I think it's definitely worthy
> > > to backport it to an LTS kernel.
> > > 
> > > Or is there any special requirement for LTS kernel to reject certain
> > > features?
> > 
> > Stable/LTS kernels do not get new features, sorry.
> 
> OK, sorry to hear that.
> 
> >  If someone wants this feature, why not just use 5.15?
> 
> One thing is, this is not really a feature, but more like an extra
> safenet to catch hardware problems.
> 
> In fact, just according to the reports in btrfs mail list, memory
> bitflip is not that rare in the real world.
> 
> And any undetected bitflip reached disk will be later rejected by the
> read time sanity check, causing a possibly unmountable fs.
> (even we output exactly the reason why we reject the metadata, and with
> those error messages, one can easily know it's a bitflip, it's still way
> worse than rejecting the corrupted data at write time).
> 
> So I guess the only way to get full runtime sanity check is waiting for
> the next LTS.

What exactly does the patches look like to backport this?

And what prevents people from using the 5.15 LTS kernel instead of 5.10
if they wish to have this additional protection?

thanks,

greg k-h
