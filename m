Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5834639226
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 18:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730729AbfFGQcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 12:32:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730727AbfFGQcG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 12:32:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEC1E2064A;
        Fri,  7 Jun 2019 16:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559925126;
        bh=x6NdTGK0hYCIN8oIEzNYU7W2dzDVrjuCU/waZSAP1Vk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vf8Jdw7EUoztUdVZsMMAR2d8ZQp6qsgQL4pIXjcRLEr2NiY5a4o/wMSGOIzRYHEtx
         Vii8bfSatYN58xw5iQKZY1MH6GpoR6kb2LLkeCu6ZA39p7TXOjIlSmgB13qYfRraxK
         DkQMkS47UAjkno146rmKADiU76eYpp4Pc4OSR/xg=
Date:   Fri, 7 Jun 2019 18:32:03 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/69] 4.14.124-stable review
Message-ID: <20190607163203.GA14514@kroah.com>
References: <20190607153848.271562617@linuxfoundation.org>
 <20190607161102.GA19615@roeck-us.net>
 <20190607161627.GA9920@kroah.com>
 <20190607162722.GA21998@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607162722.GA21998@roeck-us.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 07, 2019 at 09:27:22AM -0700, Guenter Roeck wrote:
> On Fri, Jun 07, 2019 at 06:16:27PM +0200, Greg Kroah-Hartman wrote:
> > On Fri, Jun 07, 2019 at 09:11:02AM -0700, Guenter Roeck wrote:
> > > On Fri, Jun 07, 2019 at 05:38:41PM +0200, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 4.14.124 release.
> > > > There are 69 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Sun 09 Jun 2019 03:37:08 PM UTC.
> > > > Anything received after that time might be too late.
> > > >
> > > 
> > > fs/btrfs/inode.c: In function 'btrfs_add_link':
> > > fs/btrfs/inode.c:6590:27: error: invalid initializer
> > >    struct timespec64 now = current_time(&parent_inode->vfs_inode);
> > >                            ^~~~~~~~~~~~
> > > fs/btrfs/inode.c:6592:35: error: incompatible types when assigning to type 'struct timespec' from type 'struct timespec64'
> > >    parent_inode->vfs_inode.i_mtime = now;
> > >                                    ^
> > > fs/btrfs/inode.c:6593:35: error: incompatible types when assigning to type 'struct timespec' from type 'struct timespec64'
> > >    parent_inode->vfs_inode.i_ctime = now;
> > >                                    ^
> > 
> > What arch?  This builds for me here.  odd...
> > 
> 
> arm, i386, m68k, mips, parisc, xtensa, ppc, sh4
> 
> It was originally seen with v4.14.123-69-gcc46c1204f89 last night,
> but I confirmed that v4.14.123-70-g94c5316fb246 is still affected.

Ok, let me dig into this after dinner, I think it's due to the
timespec64 change that happened before 4.19 (where this error is not
showing up...)

thanks,

greg k-h
