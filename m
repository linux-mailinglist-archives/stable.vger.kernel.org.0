Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E787D3A6AD5
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 17:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbhFNPsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 11:48:50 -0400
Received: from mail.itouring.de ([85.10.202.141]:49404 "EHLO mail.itouring.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233482AbhFNPsu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 11:48:50 -0400
X-Greylist: delayed 596 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jun 2021 11:48:49 EDT
Received: from tux.applied-asynchrony.com (p5ddd760d.dip0.t-ipconnect.de [93.221.118.13])
        by mail.itouring.de (Postfix) with ESMTPSA id 59CF61259D3;
        Mon, 14 Jun 2021 17:36:46 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 02209F01606;
        Mon, 14 Jun 2021 17:36:45 +0200 (CEST)
Subject: Re: [PATCH 5.10 000/131] 5.10.44-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20210614102652.964395392@linuxfoundation.org>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <83a2f94d-dd6e-2796-ad04-2f92ac3e583d@applied-asynchrony.com>
Date:   Mon, 14 Jun 2021 17:36:45 +0200
MIME-Version: 1.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-06-14 12:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.44 release.

Hmm..I build my kernel with BTF for bpftrace and this gives me:

...
   CC      init/version.o
   AR      init/built-in.a
   LD      vmlinux.o
   MODPOST vmlinux.symvers
   MODINFO modules.builtin.modinfo
   GEN     modules.builtin
   LD      .tmp_vmlinux.btf
   BTF     .btf.vmlinux.bin.o
   LD      .tmp_vmlinux.kallsyms1
   KSYMS   .tmp_vmlinux.kallsyms1.S
   AS      .tmp_vmlinux.kallsyms1.S
   LD      .tmp_vmlinux.kallsyms2
   KSYMS   .tmp_vmlinux.kallsyms2.S
   AS      .tmp_vmlinux.kallsyms2.S
   LD      vmlinux
   BTFIDS  vmlinux
FAILED unresolved symbol migrate_enable

thanks to:

> Jiri Olsa <jolsa@kernel.org>
>      bpf: Add deny list of btf ids check for tracing programs

When I revert this it builds fine, just like before. Maybe a missing
requirement or followup fix? I didn't find anything with a quick search.
Using gcc-11, if it matters.

-h
