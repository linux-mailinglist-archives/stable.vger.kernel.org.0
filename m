Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA064296D0
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 20:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234382AbhJKS0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 14:26:34 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:39725 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232165AbhJKS0d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 14:26:33 -0400
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4HSnJH5qrNz9sTs;
        Mon, 11 Oct 2021 20:24:31 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id oGW88cp2Y0Fr; Mon, 11 Oct 2021 20:24:31 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4HSnJH4sXqz9sTq;
        Mon, 11 Oct 2021 20:24:31 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 6B0DE8B76E;
        Mon, 11 Oct 2021 20:24:31 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id JpZxGe21iLjb; Mon, 11 Oct 2021 20:24:31 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.202.147])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id A796B8B763;
        Mon, 11 Oct 2021 20:24:30 +0200 (CEST)
Subject: Re: [PATCH 5.4 49/52] powerpc/bpf: Fix BPF_MOD when imm == 1
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Song Liu <songliubraving@fb.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
References: <20211011134503.715740503@linuxfoundation.org>
 <20211011134505.420785540@linuxfoundation.org>
 <CA+G9fYtUcnJioz4rPonLvjhwwNFmXYfiqE+0uUDO5aZcuoa0MQ@mail.gmail.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <21099a2e-b1d3-a1dd-be79-3e491afe20cc@csgroup.eu>
Date:   Mon, 11 Oct 2021 20:24:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CA+G9fYtUcnJioz4rPonLvjhwwNFmXYfiqE+0uUDO5aZcuoa0MQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr-FR
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 11/10/2021 à 19:33, Naresh Kamboju a écrit :
> stable-rc 5.4 build failed due this patch.
>   - powerpc gcc-10-defconfig - FAILED
>   - powerpc gcc-11-defconfig - FAILED
>   - powerpc gcc-8-defconfig - FAILED
>   - powerpc gcc-9-defconfig - FAILED
> 
> 
> On Mon, 11 Oct 2021 at 19:28, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>>
>> [ Upstream commit 8bbc9d822421d9ac8ff9ed26a3713c9afc69d6c8 ]
>>
>> Only ignore the operation if dividing by 1.
> 
> <trim>
> 
> In file included from arch/powerpc/net/bpf_jit64.h:11,
>                   from arch/powerpc/net/bpf_jit_comp64.c:19:
> arch/powerpc/net/bpf_jit_comp64.c: In function 'bpf_jit_build_body':
> arch/powerpc/net/bpf_jit_comp64.c:415:46: error: implicit declaration
> of function 'PPC_RAW_LI'; did you mean 'PPC_RLWIMI'?

PPC_RAW_LI() was added by commit 3a1812379163 ("powerpc/ppc-opcode: 
Consolidate powerpc instructions from bpf_jit.h")

Priori to that you have to use PPC_LI() instead, with the same arguments.

Christophe

> [-Werror=implicit-function-declaration]
>    415 |                                         EMIT(PPC_RAW_LI(dst_reg, 0));
>        |                                              ^~~~~~~~~~
> arch/powerpc/net/bpf_jit.h:32:34: note: in definition of macro 'PLANT_INSTR'
>     32 |         do { if (d) { (d)[idx] = instr; } idx++; } while (0)
>        |                                  ^~~~~
> arch/powerpc/net/bpf_jit_comp64.c:415:41: note: in expansion of macro 'EMIT'
>    415 |                                         EMIT(PPC_RAW_LI(dst_reg, 0));
>        |                                         ^~~~
> cc1: all warnings being treated as errors
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> --
> Linaro LKFT
> https://lkft.linaro.org
> ReplyReply to allForward
> 
