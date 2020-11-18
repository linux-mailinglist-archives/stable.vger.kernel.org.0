Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884422B7A06
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 10:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgKRJIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 04:08:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:42722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725879AbgKRJIj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Nov 2020 04:08:39 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A8A52463B;
        Wed, 18 Nov 2020 09:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605690518;
        bh=0ATTxIgskS+BZwwszpKGet1lWX/ZRWNJjUV/O3xhweA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GzQoelJDAKUQ6/YrBN4SCwv/xPpRDrx7yIlgvQNVhiLEfAeMBTMaKJjw8HHrz2M29
         CUh0j1br1BD4gpzXRTtML40jSCdU8yTeOqzIHebDA5IwlLpZ8JgmfEmEl1E6HPjNoW
         JwHzyVaGjbLZnQYNQbMk1czMGHvLourEBxyzpJo0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kfJS8-00Bd2B-9J; Wed, 18 Nov 2020 09:08:36 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 18 Nov 2020 09:08:36 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: WARNING: kernel/irq/chip.c:242 __irq_startup+0xa8/0xb0
In-Reply-To: <CA+G9fYsfEVK86ask=fL=M5juerbz+BwbFGcAZ_UxWrPHXYpA1Q@mail.gmail.com>
References: <CA+G9fYtwycbC+Hf9aP5Br8wq7cKWVqjhcGusn2DbJaNauGC3Og@mail.gmail.com>
 <CA+G9fYsfEVK86ask=fL=M5juerbz+BwbFGcAZ_UxWrPHXYpA1Q@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <0256a0a0139c56db75cffa4fe14079ad@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: naresh.kamboju@linaro.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, tglx@linutronix.de, gregkh@linuxfoundation.org, sashal@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Naresh,

On 2020-11-18 06:11, Naresh Kamboju wrote:
> On Tue, 13 Oct 2020 at 11:09, Naresh Kamboju 
> <naresh.kamboju@linaro.org> wrote:
>> 
>> On stable rc  5.8.15 the following kernel warning was noticed once
>> while boot and this is hard to reproduce.
> 
> This is now reproduciable on arm64 NXP ls2088 device

How reproducible? On demand? Once in a while?

> 
> [   19.980839] ------------[ cut here ]------------
> [   19.985468] WARNING: CPU: 1 PID: 441 at kernel/irq/chip.c:242
> __irq_startup+0x9c/0xa8
> [   19.985472] Modules linked in: rfkill lm90 ina2xx crct10dif_ce
> qoriq_thermal fuse
> [   20.000773] CPU: 1 PID: 441 Comm: (agetty) Not tainted 5.4.78-rc1 #2

Can you please try and reproduce this on mainline?

> [   20.000775] Hardware name: Freescale Layerscape 2088A RDB Board (DT)
> [   20.000779] pstate: 60000085 (nZCv daIf -PAN -UAO)
> [   20.018253] pc : __irq_startup+0x9c/0xa8
> [   20.018256] lr : irq_startup+0x64/0x130
> [   20.018259] sp : ffff80001122f8e0
> [   20.029303] x29: ffff80001122f8e0 x28: ffff0082c242d400
> [   20.029306] x27: ffffdd0f47234768 x26: 0000000000020902
> [   20.029309] x25: ffffdd0f461a6f10 x24: ffffdd0f461a6bc8
> [   20.029311] x23: 0000000000000000 x22: 0000000000000001
> [   20.029314] x21: 0000000000000001 x20: ffff0082c22f8780
> [   20.029316] x19: ffff0082c1060800 x18: 0000000000000001
> [   20.029318] x17: 0000000000000000 x16: ffff8000114a0000
> [   20.029321] x15: 0000000000000000 x14: ffff0082c0e92f90
> [   20.071738] x13: ffff0082c0e93080 x12: ffff800011460000
> [   20.071741] x11: dead000000000100 x10: 0000000000000040
> [   20.071743] x9 : ffffdd0f47093ba8 x8 : ffffdd0f47093ba0
> [   20.087653] x7 : ffff0082a00002b0 x6 : ffffdd0f47074958
> [   20.087655] x5 : ffffdd0f47074000 x4 : ffff800011230000
> [   20.087657] x3 : 0000000000000504 x2 : 0000000000000001
> [   20.103567] x1 : 0000000003032004 x0 : ffff0082c1060858
> [   20.103570] Call trace:
> [   20.103573]  __irq_startup+0x9c/0xa8
> [   20.103577]  irq_startup+0x64/0x130
> [   20.118359]  __enable_irq+0x7c/0x88
> [   20.118362]  enable_irq+0x54/0xa8
> [   20.118367]  serial8250_do_startup+0x658/0x718
> [   20.118371]  serial8250_startup+0x38/0x48

Looking at the DT:

                 serial0: serial@21c0500 {
                         interrupts = <0 32 0x4>; /* Level high type */

                 serial1: serial@21c0600 {
                         interrupts = <0 32 0x4>; /* Level high type */

                 serial2: serial@21d0500 {
                         interrupts = <0 33 0x4>; /* Level high type */

                 serial3: serial@21d0600 {
                         interrupts = <0 33 0x4>; /* Level high type */


The UART interrupt lines are shared. Braindead, 1980 style.

Which UART is agetty trying to use? Is there any other process using
another UART concurrently? We could have a race between the line being
shut down on one device, and activated from the other, but I can't
spot it right away.

If you can reproduce it easily enough, it shouldn't be too hard to trace
what happens around the activation of the shared interrupt (assuming 
that
this is where the problem is).

         M.
-- 
Jazz is not dead. It just smells funny...
