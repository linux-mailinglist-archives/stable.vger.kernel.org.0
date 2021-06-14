Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031333A6B6B
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 18:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234618AbhFNQQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 12:16:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234013AbhFNQQy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 12:16:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F37761246;
        Mon, 14 Jun 2021 16:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623687290;
        bh=MEFzlXmEBG7aEcrezijH8iOebotC+nhLpTf9hTNnRlo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JwcodTUU0EqajHZuAooo23UdzzJvTWRq9MwhPFTieb5DqsusTbx4hcTxYgpFiidpx
         QvgxlWvZKFetbqJlibjOmjkJcGpf5Dq6LN4q/i+ZTsK1Rt1aRdQkxT86a8D0z9at0F
         DBqWz9x1yhTNgVr2Ep5qz61jXUiyArSGNXpeIdW0=
Date:   Mon, 14 Jun 2021 18:14:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 000/131] 5.10.44-rc1 review
Message-ID: <YMeAeNwHflP1vsCP@kroah.com>
References: <20210614102652.964395392@linuxfoundation.org>
 <83a2f94d-dd6e-2796-ad04-2f92ac3e583d@applied-asynchrony.com>
 <YMd/owzz9xQ9p0ca@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YMd/owzz9xQ9p0ca@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 14, 2021 at 06:11:15PM +0200, Greg Kroah-Hartman wrote:
> On Mon, Jun 14, 2021 at 05:36:45PM +0200, Holger Hoffstätte wrote:
> > On 2021-06-14 12:26, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.44 release.
> > 
> > Hmm..I build my kernel with BTF for bpftrace and this gives me:
> > 
> > ...
> >   CC      init/version.o
> >   AR      init/built-in.a
> >   LD      vmlinux.o
> >   MODPOST vmlinux.symvers
> >   MODINFO modules.builtin.modinfo
> >   GEN     modules.builtin
> >   LD      .tmp_vmlinux.btf
> >   BTF     .btf.vmlinux.bin.o
> >   LD      .tmp_vmlinux.kallsyms1
> >   KSYMS   .tmp_vmlinux.kallsyms1.S
> >   AS      .tmp_vmlinux.kallsyms1.S
> >   LD      .tmp_vmlinux.kallsyms2
> >   KSYMS   .tmp_vmlinux.kallsyms2.S
> >   AS      .tmp_vmlinux.kallsyms2.S
> >   LD      vmlinux
> >   BTFIDS  vmlinux
> > FAILED unresolved symbol migrate_enable
> > 
> > thanks to:
> > 
> > > Jiri Olsa <jolsa@kernel.org>
> > >      bpf: Add deny list of btf ids check for tracing programs
> > 
> > When I revert this it builds fine, just like before. Maybe a missing
> > requirement or followup fix? I didn't find anything with a quick search.
> > Using gcc-11, if it matters.
> 
> Looks like we need the change that exported this function, let me see if
> it's worth to add that, or to revert this one...

No, that's a mess, and the "bug" this commit was trying to fix, isn't
there for 5.10 as migrate_enable is not a function in 5.10.  So I'll go
drop this patch and push out a -rc2 in a few minutes.

thanks for testing and letting me know.

greg k-h
