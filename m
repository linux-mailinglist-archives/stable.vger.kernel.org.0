Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9503E842E
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 22:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbhHJUPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 16:15:14 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:50663 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbhHJUPO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 16:15:14 -0400
Received: (Authenticated sender: alex@ghiti.fr)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 1FD9B100003;
        Tue, 10 Aug 2021 20:14:48 +0000 (UTC)
Subject: Re: FAILED: patch "[PATCH] riscv: Get rid of CONFIG_PHYS_RAM_BASE in
 kernel physical" failed to apply to 5.13-stable tree
To:     Palmer Dabbelt <palmerdabbelt@google.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     jszhang@kernel.org, kernel@esmil.dk, stable@vger.kernel.org
References: <mhng-6aba8a9e-0527-47a3-8f64-128a9f7e8342@palmerdabbelt-glaptop>
From:   Alex Ghiti <alex@ghiti.fr>
Message-ID: <ae03ecab-5a55-d973-fd31-851f746d3d60@ghiti.fr>
Date:   Tue, 10 Aug 2021 22:14:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <mhng-6aba8a9e-0527-47a3-8f64-128a9f7e8342@palmerdabbelt-glaptop>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 10/08/2021 à 17:07, Palmer Dabbelt a écrit :
> On Tue, 10 Aug 2021 02:35:25 PDT (-0700), Greg KH wrote:
>> On Tue, Aug 10, 2021 at 10:26:31AM +0200, Alex Ghiti wrote:
>>> Hi Greg,
>>>
>>> Le 9/08/2021 à 12:42, gregkh@linuxfoundation.org a écrit :
>>> >
>>> > The patch below does not apply to the 5.13-stable tree.
>>>
>>> I don't know when stable was cc on this patch, this fixes something
>>> introduced in 5.14-rc1, so this is not normal it can't be applied.
>>>
>>> Sorry for the noise,
>>>
>>> Alex
>>>
>>> > If someone wants it applied there, or to any other stable or longterm
>>> > tree, then please email the backport, including the original git 
>>> commit
>>> > id to <stable@vger.kernel.org>.
>>> >
>>> > thanks,
>>> >
>>> > greg k-h
>>> >
>>> > ------------------ original commit in Linus's tree ------------------
>>> >
>>> >  From 6d7f91d914bc90a15ebc426440c26081337ceaa1 Mon Sep 17 00:00:00 
>>> 2001
>>> > From: Alexandre Ghiti <alex@ghiti.fr>
>>> > Date: Wed, 21 Jul 2021 09:59:35 +0200
>>> > Subject: [PATCH] riscv: Get rid of CONFIG_PHYS_RAM_BASE in kernel 
>>> physical
>>> >   address conversion
>>> >
>>> > The usage of CONFIG_PHYS_RAM_BASE for all kernel types was a mistake:
>>> > this value is implementation-specific and this breaks the 
>>> genericity of
>>> > the RISC-V kernel.
>>> >
>>> > Fix this by introducing a new variable phys_ram_base that holds this
>>> > value at runtime and use it in the kernel physical address conversion
>>> > macro. Since this value is used only for XIP kernels, evaluate it 
>>> only if
>>> > CONFIG_XIP_KERNEL is set which in addition optimizes this macro for
>>> > standard kernels at compile-time.
>>> >
>>> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
>>> > Tested-by: Emil Renner Berthing <kernel@esmil.dk>
>>> > Reviewed-by: Jisheng Zhang <jszhang@kernel.org>
>>> > Fixes: 44c922572952 ("RISC-V: enable XIP")
>>
>> But this commit id is in 5.13, is that incorrect?
> 
> I wasn't sure what to do here: IMO this fixes a bug that was there the 
> whole time, it's just not one that actually manifests until the 
> refactoring.  I figured I'd put the farther back tag just to be safe, in 
> case someone had picked up the feature (more likely a distro tree, but 
> IIUC they're also looking here).


Ok I understand why it got to stable but the Fixes tag is wrong to me, 
it should be commit 7094e6acaf7a ("riscv: Simplify xip and !xip kernel 
address conversion macros") because this is the one that makes use of 
CONFIG_PHYS_RAM_BASE for *all* kernels, and not only xip kernel, which 
was wrong. The original problem comes from this commit introduced in 
v5.14-rc1 so it should not be backported.

Alex
