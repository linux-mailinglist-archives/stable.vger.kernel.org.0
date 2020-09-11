Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611F1265ACF
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 09:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725648AbgIKHuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 03:50:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgIKHun (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 03:50:43 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD7E42076C;
        Fri, 11 Sep 2020 07:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599810643;
        bh=nRYPJjnlVsKFjfs8QXkPB5GTb07r7c2hZuIqaiaHkPc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CEEWrpyc+3geow4CnTiWj5CSu+r97jczejt8iq7pkQ+/c/IWKqthlU+2ca/06wL22
         AoXCwNNf/Truif1lXBlYk3z3KYxQ9bG1dyRtL9XKkLg1xJdWO1ZJ/q6w88doZvigVw
         4D60FwbPyi+3zohY9NYVqHKej50QkYkojAZbsYuU=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kGdpQ-00Avhn-U1; Fri, 11 Sep 2020 08:50:41 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 11 Sep 2020 08:50:40 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 3/3] irqchip/loongson-pch-pic: Reserve legacy LPC irqs
In-Reply-To: <CAAhV-H5Rs-PHV6Sy=1tbhsF-nj5MOYgvNie_5g7+8yFYT_2Anw@mail.gmail.com>
References: <1599624552-17523-1-git-send-email-chenhc@lemote.com>
 <1599624552-17523-3-git-send-email-chenhc@lemote.com>
 <613dd7bc4d7eeec1a5fd30f679fc83eb@kernel.org>
 <CAAhV-H5Rs-PHV6Sy=1tbhsF-nj5MOYgvNie_5g7+8yFYT_2Anw@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <6af66ab3dbf81cc1d0cf4c204ebac2b8@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: chenhc@lemote.com, tsbogend@alpha.franken.de, tglx@linutronix.de, jason@lakedaemon.net, linux-mips@vger.kernel.org, zhangfx@lemote.com, jiaxun.yang@flygoat.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-09-11 05:13, Huacai Chen wrote:
> Hi, Marc,
> 
> On Thu, Sep 10, 2020 at 6:08 PM Marc Zyngier <maz@kernel.org> wrote:
>> 
>> On 2020-09-09 05:09, Huacai Chen wrote:
>> > Reserve legacy LPC irqs (0~15) to avoid spurious interrupts.
>> 
>> How can they be spurious? Why are they enabled the first place?
>> 
>> This looks like you are papering over a much bigger issue.
> The spurious interrupts are probably occurred after kdump and the irq
> number is in legacy LPC ranges. I think this is because the old kernel
> doesn't (and it can't) disable devices properly so there are stale
> interrupts in the kdump case.

I don't really understand why the old kernel can't turn the interrupts
off. Most architectures are able t, why not yours?

Finally, why don't you just shut these interrupts off the first place
in the interrupt controller init? Adding a whole lot of kernel
data structures as a band-aid doesn't strike me as the best possible
idea. Not to mention that if they keep firing, all you are doing
is adding extra overhead.

         M.
-- 
Jazz is not dead. It just smells funny...
