Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E507A190398
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 03:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgCXCes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 22:34:48 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:33372 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726824AbgCXCer (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Mar 2020 22:34:47 -0400
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 02O2YVaA028612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Mar 2020 22:34:32 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 3DEAA420EBA; Mon, 23 Mar 2020 22:34:31 -0400 (EDT)
Date:   Mon, 23 Mar 2020 22:34:31 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        "Suzuki K. Poulose" <suzuki.poulose@arm.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Florian Weimer <fw@deneb.enyo.de>,
        Andy Lutomirski <luto@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] ext4: Give 32bit personalities 32bit hashes
Message-ID: <20200324023431.GD53396@mit.edu>
References: <20200317113153.7945-1-linus.walleij@linaro.org>
 <CAFEAcA9mXE+gPnvM6HZ-w0+BhbpeuH=osFH-9NUzCLv=w-c7HQ@mail.gmail.com>
 <CACRpkdZtLNUwiZEMiJEoB0ojOBckyGcZeyFkR6MC69qv-ry9EA@mail.gmail.com>
 <CAFEAcA-gdwi=KSW6LqVdEJWSo9VEL5abYQs9LoHd4mKE_-h=Aw@mail.gmail.com>
 <CACRpkdYuZgZUznVxt1AHCSJa_GAXy8N0SduE5OrjDnE1s_L7Zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYuZgZUznVxt1AHCSJa_GAXy8N0SduE5OrjDnE1s_L7Zg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 19, 2020 at 11:23:33PM +0100, Linus Walleij wrote:
> OK I guess we can at least take this opportunity to add
> some kerneldoc to the include file.
> 
> > As a concrete example, should "give me 32-bit semantics
> > via PER_LINUX32" mean "mmap should always return addresses
> > within 4GB" ? That would seem like it would make sense --
> 
> Incidentally that thing in particular has its own personality
> flag (personalities are additive, it's a bit schizophrenic)
> so PER_LINUX_32BIT is defined as:
> PER_LINUX_32BIT =       0x0000 | ADDR_LIMIT_32BIT,
> and that is specifically for limiting the address space to
> 32bit.
> 
> There is also PER_LINUX32_3GB for a 3GB lowmem
> limit.
> 
> Since the personality is kind of additive, if
> we want a flag *specifically* for indicating that we want
> 32bit hashes from the file system, there are bits left so we
> can provide that.
> 
> Is this what we want to do? I just think we shouldn't
> decide on that lightly as we will be using up personality
> bug bits, but sometimes you have to use them.

I've been looking at the personality bug bits more detailed, and it
looks... messy.  Do we pick a new personality, or do we grab another
unique flag?

Another possibility, which would be messier for qemu, would be use a
flag set via fcntl.  That would require qemu from noticing when the
guest is calling open, openat, or openat2, and then inserting a fcntl
system call to set the 32-bit readdir mode.  That's cleaner from the
kernel interface complexity perspective, but it's messier for qemu.

       		 	    		     	  - Ted

       		 
