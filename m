Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0239C3922F
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 18:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729987AbfFGQfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 12:35:17 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:53691 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728595AbfFGQfR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 12:35:17 -0400
Received: from [167.98.27.226] (helo=xylophone)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1hZHpd-0003Ry-M5; Fri, 07 Jun 2019 17:35:09 +0100
Message-ID: <1559925309.21054.9.camel@codethink.co.uk>
Subject: Re: [PATCH 4.14 00/69] 4.14.124-stable review
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Date:   Fri, 07 Jun 2019 17:35:09 +0100
In-Reply-To: <20190607162722.GA21998@roeck-us.net>
References: <20190607153848.271562617@linuxfoundation.org>
         <20190607161102.GA19615@roeck-us.net> <20190607161627.GA9920@kroah.com>
         <20190607162722.GA21998@roeck-us.net>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2019-06-07 at 09:27 -0700, Guenter Roeck wrote:
> On Fri, Jun 07, 2019 at 06:16:27PM +0200, Greg Kroah-Hartman wrote:
> > On Fri, Jun 07, 2019 at 09:11:02AM -0700, Guenter Roeck wrote:
> > > On Fri, Jun 07, 2019 at 05:38:41PM +0200, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 4.14.124 release.
> > > > There are 69 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Sun 09 Jun 2019 03:37:08 PM UTC.
> > > > Anything received after that time might be too late.
> > > > 
> > > 
> > > fs/btrfs/inode.c: In function 'btrfs_add_link':
> > > fs/btrfs/inode.c:6590:27: error: invalid initializer
> > >    struct timespec64 now = current_time(&parent_inode->vfs_inode);
> > >                            ^~~~~~~~~~~~

For 4.14 the type of "now" should be struct timespec.

> > > fs/btrfs/inode.c:6592:35: error: incompatible types when assigning to type 'struct timespec' from type 'struct timespec64'
> > >    parent_inode->vfs_inode.i_mtime = now;
> > >                                    ^
> > > fs/btrfs/inode.c:6593:35: error: incompatible types when assigning to type 'struct timespec' from type 'struct timespec64'
> > >    parent_inode->vfs_inode.i_ctime = now;
> > >                                    ^
> > 
> > What arch?  This builds for me here.  odd...
> > 
> 
> arm, i386, m68k, mips, parisc, xtensa, ppc, sh4
> 
> It was originally seen with v4.14.123-69-gcc46c1204f89 last night,
> but I confirmed that v4.14.123-70-g94c5316fb246 is still affected.

All 32-bit architectures are affected; on 64-bit architectures
timespec64 is a macro expanding to timespec.

Ben. 

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom
