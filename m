Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC95447305
	for <lists+stable@lfdr.de>; Sun,  7 Nov 2021 14:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbhKGNQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Nov 2021 08:16:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:54322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231136AbhKGNQU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Nov 2021 08:16:20 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B90561074;
        Sun,  7 Nov 2021 13:13:38 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mjhzM-003xkb-17; Sun, 07 Nov 2021 13:13:36 +0000
MIME-Version: 1.0
Date:   Sun, 07 Nov 2021 13:13:35 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Guo Ren <guoren@kernel.org>
Cc:     Anup Patel <anup@brainfault.org>,
        Atish Patra <atish.patra@wdc.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Guo Ren <guoren@linux.alibaba.com>,
        Vincent Pelletier <plr.vincent@gmail.com>,
        Nikita Shubin <nikita.shubin@maquefel.me>,
        stable@vger.kernel.org
Subject: Re: [PATCH V7] irqchip/sifive-plic: Fixup EOI failed when masked
In-Reply-To: <CAJF2gTTcx0GWQ6CY0VJtzAi8TqvOKK00py4f-d_1iHhi1XAXmw@mail.gmail.com>
References: <20211105094748.3894453-1-guoren@kernel.org>
 <CAAhSdy1vyCQdv_gNaNSzU79PC4giCAig6hzgD9JXSXs6+gfFPA@mail.gmail.com>
 <CAJF2gTTcx0GWQ6CY0VJtzAi8TqvOKK00py4f-d_1iHhi1XAXmw@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <7f9e088982de34e71b8bf656c770427c@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: guoren@kernel.org, anup@brainfault.org, atish.patra@wdc.com, tglx@linutronix.de, palmer@dabbelt.com, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, guoren@linux.alibaba.com, plr.vincent@gmail.com, nikita.shubin@maquefel.me, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-11-07 13:09, Guo Ren wrote:
> On Sat, Nov 6, 2021 at 9:45 PM Anup Patel <anup@brainfault.org> wrote:
>> 
>> On Fri, Nov 5, 2021 at 3:18 PM <guoren@kernel.org> wrote:
>> >
>> > From: Guo Ren <guoren@linux.alibaba.com>
>> >
>> > When using "devm_request_threaded_irq(,,,,IRQF_ONESHOT,,)" in the driver,
>> > only the first interrupt could be handled, and continue irq is blocked by
>> > hw. Because the riscv plic couldn't complete masked irq source which has
>> > been disabled in enable register. The bug was firstly reported in [1].
>> >
>> > Here is the description of Interrupt Completion in PLIC spec [2]:
>> >
>> > The PLIC signals it has completed executing an interrupt handler by
>> > writing the interrupt ID it received from the claim to the claim/complete
>> > register. The PLIC does not check whether the completion ID is the same
>> > as the last claim ID for that target. If the completion ID does not match
>> > an interrupt source that is currently enabled for the target, the
>> >                          ^^ ^^^^^^^^^ ^^^^^^^
>> > completion is silently ignored.
>> >
>> > [1] http://lists.infradead.org/pipermail/linux-riscv/2021-July/007441.html
>> > [2] https://github.com/riscv/riscv-plic-spec/blob/8bc15a35d07c9edf7b5d23fec9728302595ffc4d/riscv-plic.adoc
>> >
>> > Fixes: bb0fed1c60cc ("irqchip/sifive-plic: Switch to fasteoi flow")
>> > Reported-by: Vincent Pelletier <plr.vincent@gmail.com>
>> > Tested-by: Nikita Shubin <nikita.shubin@maquefel.me>
>> > Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
>> 
>> Looks good to me.
>> 
>> Reviewed-by: Anup Patel <anup@brainfault.org>
> Thx
> 
> @Marc Zyngier
> Could you help to take the patch into your tree include "Anup's
> Reviewed-by"? Or Let me update a new version of the patch.

You should have received [1], which shows you what I have done.

         M.

[1] 
https://lore.kernel.org/all/163620881803.626.5045336370262044443.tip-bot2@tip-bot2/
-- 
Jazz is not dead. It just smells funny...
