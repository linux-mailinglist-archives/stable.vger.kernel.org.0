Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1796D499C94
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1579701AbiAXWGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:06:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1458035AbiAXVzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:55:06 -0500
Received: from mail.itouring.de (mail.itouring.de [IPv6:2a01:4f8:a0:4463::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E27C07E2A6;
        Mon, 24 Jan 2022 12:36:43 -0800 (PST)
Received: from tux.applied-asynchrony.com (p5b07e69a.dip0.t-ipconnect.de [91.7.230.154])
        by mail.itouring.de (Postfix) with ESMTPSA id 6DE0D103765;
        Mon, 24 Jan 2022 21:36:39 +0100 (CET)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 13DC6F0160A;
        Mon, 24 Jan 2022 21:36:39 +0100 (CET)
Subject: Re: [PATCH 5.15 000/846] 5.15.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>
References: <20220124184100.867127425@linuxfoundation.org>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <29a0f562-af46-f4d0-182c-09c8d99e0a93@applied-asynchrony.com>
Date:   Mon, 24 Jan 2022 21:36:39 +0100
MIME-Version: 1.0
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-01-24 19:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.17 release.

Oh noes :(

   DESCEND bpf/resolve_btfids
   MKDIR     /tmp/linux-5.15.17/tools/bpf/resolve_btfids//libbpf
   GEN     /tmp/linux-5.15.17/tools/bpf/resolve_btfids/libbpf/bpf_helper_defs.h
   MKDIR   /tmp/linux-5.15.17/tools/bpf/resolve_btfids/libbpf/staticobjs/
   CC      /tmp/linux-5.15.17/tools/bpf/resolve_btfids/libbpf/staticobjs/libbpf.o
libbpf.c: In function 'bpf_object__elf_collect':
libbpf.c:3038:31: error: invalid type argument of '->' (have 'GElf_Shdr' {aka 'Elf64_Shdr'})
  3038 |                         if (sh->sh_type != SHT_PROGBITS)
       |                               ^~
libbpf.c:3042:31: error: invalid type argument of '->' (have 'GElf_Shdr' {aka 'Elf64_Shdr'})
  3042 |                         if (sh->sh_type != SHT_PROGBITS)
       |                               ^~
make[4]: *** [/tmp/linux-5.15.17/tools/build/Makefile.build:97: /tmp/linux-5.15.17/tools/bpf/resolve_btfids/libbpf/staticobjs/libbpf.o] Error 1
make[3]: *** [Makefile:158: /tmp/linux-5.15.17/tools/bpf/resolve_btfids/libbpf/staticobjs/libbpf-in.o] Error 2
make[2]: *** [Makefile:44: /tmp/linux-5.15.17/tools/bpf/resolve_btfids//libbpf/libbpf.a] Error 2
make[1]: *** [Makefile:72: bpf/resolve_btfids] Error 2
make: *** [Makefile:1371: tools/bpf/resolve_btfids] Error 2

Reverting "libbpf-validate-that-.btf-and-.btf.ext-sections-cont.patcht" aka
this one:

> Andrii Nakryiko <andrii@kernel.org>
>      libbpf: Validate that .BTF and .BTF.ext sections contain data

makes it build & run fine. I looked for followups but couldn't find anything that
stood out, maybe the BPF folks (cc'ed) know what's missing/wrong.

cheers
Holger
