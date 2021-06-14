Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6863A6B53
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 18:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233968AbhFNQNk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 12:13:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234071AbhFNQNe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 12:13:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CB5B61245;
        Mon, 14 Jun 2021 16:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623687077;
        bh=mCCajpVFmAKPfyqCanoKSj9iuz7ExznsWTObsblRRT4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MxmyVwVIab1QLHpYofe2yxmrihigIDDJou71cn+GJ3Bp8hlI/u27NSsQf4QuuyyxS
         Y5x3OxZ2yFzDI8vaR5r0UIAz/BpK/jfPL+ukuzTfSe6HefEFx14UMQqPnOMcA8HUMm
         vZtzhUImx1P1ER0PPaQ5O3sKjwFlBM+qT+GmFk7g=
Date:   Mon, 14 Jun 2021 18:11:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 000/131] 5.10.44-rc1 review
Message-ID: <YMd/owzz9xQ9p0ca@kroah.com>
References: <20210614102652.964395392@linuxfoundation.org>
 <83a2f94d-dd6e-2796-ad04-2f92ac3e583d@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <83a2f94d-dd6e-2796-ad04-2f92ac3e583d@applied-asynchrony.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 14, 2021 at 05:36:45PM +0200, Holger Hoffstätte wrote:
> On 2021-06-14 12:26, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.44 release.
> 
> Hmm..I build my kernel with BTF for bpftrace and this gives me:
> 
> ...
>   CC      init/version.o
>   AR      init/built-in.a
>   LD      vmlinux.o
>   MODPOST vmlinux.symvers
>   MODINFO modules.builtin.modinfo
>   GEN     modules.builtin
>   LD      .tmp_vmlinux.btf
>   BTF     .btf.vmlinux.bin.o
>   LD      .tmp_vmlinux.kallsyms1
>   KSYMS   .tmp_vmlinux.kallsyms1.S
>   AS      .tmp_vmlinux.kallsyms1.S
>   LD      .tmp_vmlinux.kallsyms2
>   KSYMS   .tmp_vmlinux.kallsyms2.S
>   AS      .tmp_vmlinux.kallsyms2.S
>   LD      vmlinux
>   BTFIDS  vmlinux
> FAILED unresolved symbol migrate_enable
> 
> thanks to:
> 
> > Jiri Olsa <jolsa@kernel.org>
> >      bpf: Add deny list of btf ids check for tracing programs
> 
> When I revert this it builds fine, just like before. Maybe a missing
> requirement or followup fix? I didn't find anything with a quick search.
> Using gcc-11, if it matters.

Looks like we need the change that exported this function, let me see if
it's worth to add that, or to revert this one...

thanks,

greg k-h
