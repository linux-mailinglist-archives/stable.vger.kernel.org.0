Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81A4339C1E
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 11:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfFHJ2f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 05:28:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726478AbfFHJ2e (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 05:28:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B542212F5;
        Sat,  8 Jun 2019 09:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559986113;
        bh=IINixVEqB3EWNlhjtCsureTjEiXIWEFCsXA5XNXJok0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h5YSAZK2lfoT4KqnrgFNRwtxkK8fU8TV/BISkcdvHlK9e/TVRD8q/gbnTzII9XXUN
         BymRlTHrA7nQyBHS+i0C9x9AwS6a31HiZt5D/x53BjiLJLJlZUzyMf0Mz+sSBZXgQl
         pUlAVqxkXy7xrZ2Y/YoSeInjZrn8Nrh8OLjuEaGM=
Date:   Sat, 8 Jun 2019 11:28:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/69] 4.14.124-stable review
Message-ID: <20190608092831.GA19832@kroah.com>
References: <20190607153848.271562617@linuxfoundation.org>
 <20190607161102.GA19615@roeck-us.net>
 <20190607161627.GA9920@kroah.com>
 <20190607162722.GA21998@roeck-us.net>
 <1559925309.21054.9.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1559925309.21054.9.camel@codethink.co.uk>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 07, 2019 at 05:35:09PM +0100, Ben Hutchings wrote:
> On Fri, 2019-06-07 at 09:27 -0700, Guenter Roeck wrote:
> > On Fri, Jun 07, 2019 at 06:16:27PM +0200, Greg Kroah-Hartman wrote:
> > > On Fri, Jun 07, 2019 at 09:11:02AM -0700, Guenter Roeck wrote:
> > > > On Fri, Jun 07, 2019 at 05:38:41PM +0200, Greg Kroah-Hartman wrote:
> > > > > This is the start of the stable review cycle for the 4.14.124 release.
> > > > > There are 69 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > > 
> > > > > Responses should be made by Sun 09 Jun 2019 03:37:08 PM UTC.
> > > > > Anything received after that time might be too late.
> > > > > 
> > > > 
> > > > fs/btrfs/inode.c: In function 'btrfs_add_link':
> > > > fs/btrfs/inode.c:6590:27: error: invalid initializer
> > > >    struct timespec64 now = current_time(&parent_inode->vfs_inode);
> > > >                            ^~~~~~~~~~~~
> 
> For 4.14 the type of "now" should be struct timespec.
> 
> > > > fs/btrfs/inode.c:6592:35: error: incompatible types when assigning to type 'struct timespec' from type 'struct timespec64'
> > > >    parent_inode->vfs_inode.i_mtime = now;
> > > >                                    ^
> > > > fs/btrfs/inode.c:6593:35: error: incompatible types when assigning to type 'struct timespec' from type 'struct timespec64'
> > > >    parent_inode->vfs_inode.i_ctime = now;
> > > >                                    ^
> > > 
> > > What arch?  This builds for me here.  odd...
> > > 
> > 
> > arm, i386, m68k, mips, parisc, xtensa, ppc, sh4
> > 
> > It was originally seen with v4.14.123-69-gcc46c1204f89 last night,
> > but I confirmed that v4.14.123-70-g94c5316fb246 is still affected.
> 
> All 32-bit architectures are affected; on 64-bit architectures
> timespec64 is a macro expanding to timespec.

Thanks, I've made this fix now.  Will go push out a -rc2 with it in it.

greg k-h
