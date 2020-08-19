Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1FB24A75F
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 22:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725275AbgHSUCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 16:02:14 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:35520 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgHSUCN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 16:02:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1597867334; x=1629403334;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=/WuUsWWRaL1RoCuSGDbDXqbB2zUmPQ8qHvxQ39aJ2XE=;
  b=AhYV0PVHNkVCU2qoecWSYTMUsd1bOP4FOe564k2GFdd+zH7cB68HOAUh
   VSx3kd1BdJm8pC4eJaHJHh/KNdf8NU+j8R9Opj3ENZq1IGQ8Uv/8Zpsbn
   HhlfjEwdjDwkbBkSSDIwCt1hmfe2vmqQ03CB7Q7TCuf38pLjoKq9e4ijR
   qWCtqDC7xXYVDR1RE8Tij22nwzoqV03Inx4f/oDjjqaFkqFh042j1Bs5U
   TvQjHK60IFpEpPTOVRuXZ1/zccS2cSYZP8VNWm6JQQhVzKe/YLsQVvyBj
   UHFcgVC8KQj/KG8paltEXySZhvmctxyDihJASjRy4CWXiQ0XnBbUG/k0A
   w==;
IronPort-SDR: vhsi6WmrJ7uoCStof2WRmBXZL1Axfa4kjHuO/aAWJdg8iBTEuQyHgYI8ylCESQ9OabQAHQIfyK
 WKeIDvbkWfASy6mz179hx7GyQby1kPDdRjNac3DgtTHwNbHjqXsElh24C6Upyjx00xmHthy6hy
 kvSFtnnn51fUClwJaTKD3qpa9cEPaJqneJCrxAeAcHMPO/iPVRGd27nutf0mC+2z4p5YUGzGoQ
 G8VBelJBTsb9DCVSWLxiedIRfQTMxnh267gLVHI+DldxwQeOuasOGKFx6KP6Pkwf19EJXgvPYX
 z3U=
X-IronPort-AV: E=Sophos;i="5.76,332,1592841600"; 
   d="scan'208";a="149675228"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Aug 2020 04:02:14 +0800
IronPort-SDR: 85AtiEJc3UwCZU8SCbF1XXG2j55Vh5hd6N/Rz8WnN4tZGIA4jSZAO6iCqNNli2QjI75MSfmvHF
 JsPIIXEokGVA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 12:49:09 -0700
IronPort-SDR: lgC0qzfmt+LZzgs6kv/HBx4AvEFDNKPlHG7WS3l2eueThUpIpnLKMnCur05odAaPlQfkGCiGdB
 +xazf3+SHAFw==
WDCIronportException: Internal
Received: from unknown (HELO redsun52) ([10.149.66.28])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 13:02:12 -0700
Date:   Wed, 19 Aug 2020 21:00:46 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>
cc:     viro@zeniv.linux.org.uk, linux-riscv@lists.infradead.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] riscv: ptrace: Use the correct API for `fcsr'
 access
In-Reply-To: <mhng-6e42b0e6-1f3b-41a3-a023-4145fb4d8980@palmerdabbelt-glaptop1>
Message-ID: <alpine.LFD.2.21.2008190019480.24175@redsun52.ssa.fujisawa.hgst.com>
References: <mhng-6e42b0e6-1f3b-41a3-a023-4145fb4d8980@palmerdabbelt-glaptop1>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 5 Aug 2020, Palmer Dabbelt wrote:

> >  I can push linux-next through regression-testing with RISC-V gdbserver
> > and/or native GDB if that would help.  This is also used with core dumps,
> > but honestly I don't know what state RISC-V support is in in the BFD/GDB's
> > core dump interpreter, as people tend to forget about the core dump
> > feature nowadays.
> 
> IIRC Andrew does GDB test suite runs sometimes natively on Linux as part of
> general GDB maintiance and we don't see major issues, but I'm pretty checked
> out of GDB development these days so he would know better than I do.  It's
> always great to have someone test stuff, though -- and I doubt he's testing
> linux-next.  It's been on my TODO list for a long time now to put together
> tip-of-tree testing for the various projects but I've never gotten around to
> doing it.

 I have now run GDB regression testing with remote `gdbserver' on a HiFive 
Unleashed, lp64d ABI only, comparing 5.8.0-next-20200814 against 5.8.0-rc5 
with no issues observed.

> Oddly enough, despite not really using GDB I have used it for core dumps -- I
> was writing a tool to convert commit logs to coredumps with the GDB reverse
> debugging annotations, but I never got around to finishing it.

 I fiddled with core dump handling verification for GDB back in my MIPS 
days expanding an existing test case to interpret an OS-generated core 
dump in addition to one produced by GDB's `gcore' command, although in the 
case of local testing only (i.e. either native or running `gdbserver' on 
the same test machine GDB runs); this restriction is due to the need to 
isolate the core file produced, as it may or may not have a .$pid suffix 
attached (or may have yet another name variation with non-Linux targets), 
which is somewhat complicated with commands run remotely (though I imagine 
the restriction could be lifted by someone sufficiently inclined).

 The relevant tests results are as follows (on a successful run):

PASS: gdb.threads/tls-core.exp: native: load core file
PASS: gdb.threads/tls-core.exp: native: print thread-local storage variable
PASS: gdb.threads/tls-core.exp: gcore: load core file
PASS: gdb.threads/tls-core.exp: gcore: print thread-local storage variable

and the binutils-gdb change is commit d9f6d7f8b636 ("testsuite: Extend TLS 
core file testing with an OS-generated dump").  So that part should be 
covered at least to some extent by automated testing.

 However something is not exactly right and I recall having an issue 
recorded for later investigation (which may not happen given the recent 
turn of events) that RISC-V/Linux does not actually dump cores even in the 
circumstances it is supposed to (i.e. the combination of the specific 
signal delivered and RLIMIT_CORE set to infinity imply it).

 Indeed I have run the test natively now and I got:

PASS: gdb.threads/tls-core.exp: successfully compiled posix threads test case
WARNING: can't generate a core file - core tests suppressed - check ulimit -c
PASS: gdb.threads/tls-core.exp: gcore
UNSUPPORTED: gdb.threads/tls-core.exp: native: load core file
UNSUPPORTED: gdb.threads/tls-core.exp: native: print thread-local storage variable
PASS: gdb.threads/tls-core.exp: gcore: load core file
PASS: gdb.threads/tls-core.exp: gcore: print thread-local storage variable

which means things are not actually sound.  Likewise if I run the test 
program manually:

$ ulimit -c
unlimited
$ ./tls-core
Aborted (core dumped)
$ ls -la core*
ls: cannot access 'core*': No such file or directory
$ 

-- oops!

 [As it turned out MIPS core dump handling was completely messed up both 
on the Linux and the GDB side.  See binutils-gdb commit d8dab6c3bbe6 
("MIPS/Linux: Correct o32 core file FGR interpretation") if interested; 
there are further Linux commit references there.]

  Maciej
