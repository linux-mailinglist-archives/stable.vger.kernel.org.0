Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F6A429A8B
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 02:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbhJLAzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 20:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230384AbhJLAzS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 20:55:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CE6C60EE2;
        Tue, 12 Oct 2021 00:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633999997;
        bh=rADcbdxnrZ5MPsZ8lJCYjLoyw1wI9SqH6FD/5rH7vCE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cbvqkF3nWsEU9G1HODrRHUpYx8Wdg7YwxlDYf6jUnF9jJ1wrewB014/dVwCxWsVzx
         1AouA0URAdT4Am8arNwtzgvDknrQ7JEkaSf5ie+gz3UY5j8B+iH5dP8xi1JcxFXiIS
         5KVHeK9D3IcH4nf0bpnwdr/vB9skHYeAWgl4ttE4pmSjAhWbpbB7sBHilVVOfi5N0m
         +uCfvEUO3sYJaHoyMXW3iOMWjktqJJF3Ru5WOj6LFnwsW2Xl5UO3nIhjW4bxvZatI9
         C8F1vpx6gowizknBUDwzBdtgER5LouV4ovOVY66rxShZgVIUTc5TLFg3M3/Gbz/Lyp
         3rBZt4I+kCrVg==
Date:   Mon, 11 Oct 2021 20:53:16 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Song Liu <songliubraving@fb.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 5.4 49/52] powerpc/bpf: Fix BPF_MOD when imm == 1
Message-ID: <YWTcfEigynJLoEa/@sashalap>
References: <20211011134503.715740503@linuxfoundation.org>
 <20211011134505.420785540@linuxfoundation.org>
 <CA+G9fYtUcnJioz4rPonLvjhwwNFmXYfiqE+0uUDO5aZcuoa0MQ@mail.gmail.com>
 <21099a2e-b1d3-a1dd-be79-3e491afe20cc@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <21099a2e-b1d3-a1dd-be79-3e491afe20cc@csgroup.eu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 11, 2021 at 08:24:30PM +0200, Christophe Leroy wrote:
>
>
>Le 11/10/2021 à 19:33, Naresh Kamboju a écrit :
>>stable-rc 5.4 build failed due this patch.
>>  - powerpc gcc-10-defconfig - FAILED
>>  - powerpc gcc-11-defconfig - FAILED
>>  - powerpc gcc-8-defconfig - FAILED
>>  - powerpc gcc-9-defconfig - FAILED
>>
>>
>>On Mon, 11 Oct 2021 at 19:28, Greg Kroah-Hartman
>><gregkh@linuxfoundation.org> wrote:
>>>
>>>From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>>>
>>>[ Upstream commit 8bbc9d822421d9ac8ff9ed26a3713c9afc69d6c8 ]
>>>
>>>Only ignore the operation if dividing by 1.
>>
>><trim>
>>
>>In file included from arch/powerpc/net/bpf_jit64.h:11,
>>                  from arch/powerpc/net/bpf_jit_comp64.c:19:
>>arch/powerpc/net/bpf_jit_comp64.c: In function 'bpf_jit_build_body':
>>arch/powerpc/net/bpf_jit_comp64.c:415:46: error: implicit declaration
>>of function 'PPC_RAW_LI'; did you mean 'PPC_RLWIMI'?
>
>PPC_RAW_LI() was added by commit 3a1812379163 ("powerpc/ppc-opcode: 
>Consolidate powerpc instructions from bpf_jit.h")
>
>Priori to that you have to use PPC_LI() instead, with the same arguments.

I think that I forgot to reply: I've pushed a fixed patch resolved as
proposed above.

-- 
Thanks,
Sasha
