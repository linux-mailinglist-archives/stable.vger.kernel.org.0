Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD01178CC0
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 09:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387648AbgCDIrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 03:47:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:56382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387644AbgCDIrG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 03:47:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1692620870;
        Wed,  4 Mar 2020 08:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583311625;
        bh=YRt4ny1N5XbDwaPfGXa8mDpw6A7mF9/GZ+UIVd8L6bE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yI+V0yzhyNgV85Sf/pnh/IEiItAmLRIV7vWmy2KZjuH1uLo8ckxb7h0NfK+c6DIcM
         TjfqUy/ofsM7b47Sv59CmTXX8YbrY89MGKa4tZCL6dWCFXWbR90Ofei2EltOmmCZ2f
         cUD6vNSq3/gKc2m8W4y+mqe5NzWhWjBctnEZivL8=
Date:   Wed, 4 Mar 2020 09:47:02 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.5 000/176] 5.5.8-stable review
Message-ID: <20200304084702.GA1416015@kroah.com>
References: <20200303174304.593872177@linuxfoundation.org>
 <CA+G9fYtNKXBOQKE_AD6qLoRo4TeaBYOc9Ce3kBxdLap1av4v=Q@mail.gmail.com>
 <20200304081128.GC1401372@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200304081128.GC1401372@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 04, 2020 at 09:11:28AM +0100, Greg Kroah-Hartman wrote:
> On Wed, Mar 04, 2020 at 12:43:42PM +0530, Naresh Kamboju wrote:
> > On Tue, 3 Mar 2020 at 23:16, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.5.8 release.
> > > There are 176 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Thu, 05 Mar 2020 17:42:06 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.8-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > >
> > 
> > Results from Linaro’s test farm.
> > Regressions detected on x86_64 and i386.
> > 
> > Test failure output:
> > CVE-2017-5715: VULN (IBRS+IBPB or retpoline+IBPB+RSB filling, is
> > needed to mitigate the vulnerability)
> > 
> > Test description:
> > CVE-2017-5715 branch target injection (Spectre Variant 2)
> > 
> > Impact: Kernel
> > Mitigation 1: new opcode via microcode update that should be used by
> > up to date compilers to protect the BTB (by flushing indirect branch
> > predictors)
> > Mitigation 2: introducing "retpoline" into compilers, and recompile
> > software/OS with it
> > Performance impact of the mitigation: high for mitigation 1, medium
> > for mitigation 2, depending on your CPU
> 
> So these are regressions or just new tests?
> 
> If regressions, can you do 'git bisect' to find the offending commit?
> 
> Also, are you sure you have an updated microcode on these machines and a
> proper compiler for retpoline?

As an example of just how crazy that script is, here's the output of my
machine for that first CVE issue:

CVE-2017-5715 aka 'Spectre Variant 2, branch target injection'
* Mitigated according to the /sys interface:  YES  (Mitigation: Full generic retpoline, IBPB: conditional, IBRS_FW, STIBP: conditional, RSB filling)
* Mitigation 1
  * Kernel is compiled with IBRS support:  YES
    * IBRS enabled and active:  YES  (for firmware code only)
  * Kernel is compiled with IBPB support:  YES
    * IBPB enabled and active:  YES
* Mitigation 2
  * Kernel has branch predictor hardening (arm):  NO
  * Kernel compiled with retpoline option:  YES
    * Kernel compiled with a retpoline-aware compiler:  YES  (kernel reports full retpoline compilation)
  * Kernel supports RSB filling:  UNKNOWN  (couldn't check (couldn't find your kernel image in /boot, if you used netboot, this is normal))
> STATUS:  VULNERABLE  (IBRS+IBPB or retpoline+IBPB+RSB filling, is needed to mitigate

So why is this "Vulnerable"?  Because it didn't think it could find my
kernel image for some odd reason, despite it really being in /boot/ (I
don't use netboot)

So please verify that this really is a real issue, and not just the
script doing foolish things.

thanks,

greg k-h
