Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9CC60F4A3
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 12:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbiJ0KNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 06:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235248AbiJ0KNG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 06:13:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD85115400;
        Thu, 27 Oct 2022 03:13:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C520C6226C;
        Thu, 27 Oct 2022 10:13:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC411C433C1;
        Thu, 27 Oct 2022 10:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666865584;
        bh=yVmhw3y2OWp44DSjCHlO0oAg03ahIcs/vanAqKRUviY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e24edh4tK/S4pO9I1vfKB5gnsZmXh5LWk5xIqS3v7A0AQTC6vj/skpdbq+qexAzH3
         TJVtLOyE/2CWXdqH4dGCSx5v8Tjlyi+Pk+TfF10jP8S9Pxl2R/21kyEn0XWsmFWKbP
         tniyM1fnKEQKV8gihaWJgR4/n+2hNR6a4cM1iBx0=
Date:   Thu, 27 Oct 2022 12:13:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rishabh Bhatnagar <risbhat@amazon.com>
Cc:     stable@vger.kernel.org, sashal@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, linux-kernel@vger.kernel.org, benh@amazon.com,
        mbacco@amazon.com
Subject: Re: [PATCH 0/6] IRQ handling patches backport to 4.14 stable
Message-ID: <Y1pZrdySrzod3NCM@kroah.com>
References: <20220929210651.12308-1-risbhat@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929210651.12308-1-risbhat@amazon.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 29, 2022 at 09:06:45PM +0000, Rishabh Bhatnagar wrote:
> This patch series backports a bunch of patches related IRQ handling
> with respect to freeing the irq line while IRQ is in flight at CPU
> or at the hardware level.
> Recently we saw this issue in serial 8250 driver where the IRQ was being
> freed while the irq was in flight or not yet delivered to the CPU. As a
> result the irqchip was going into a wedged state and IRQ was not getting
> delivered to the cpu. These patches helped fixed the issue in 4.14
> kernel.
> Let us know if more patches need backporting.
> 
> Lukas Wunner (2):
>   genirq: Update code comments wrt recycled thread_mask
>   genirq: Synchronize only with single thread on free_irq()
> 
> Thomas Gleixner (4):
>   genirq: Delay deactivation in free_irq()
>   genirq: Fix misleading synchronize_irq() documentation
>   genirq: Add optional hardware synchronization for shutdown
>   x86/ioapic: Implement irq_get_irqchip_state() callback
> 
>  arch/x86/kernel/apic/io_apic.c |  46 ++++++++++++++
>  kernel/irq/autoprobe.c         |   6 +-
>  kernel/irq/chip.c              |   6 ++
>  kernel/irq/cpuhotplug.c        |   2 +-
>  kernel/irq/internals.h         |   5 ++
>  kernel/irq/manage.c            | 106 ++++++++++++++++++++++-----------
>  6 files changed, 133 insertions(+), 38 deletions(-)

A simple build test breaks with this series applied:

ld: kernel/irq/manage.o: in function `__synchronize_hardirq':
manage.c:(.text+0x149): undefined reference to `__irq_get_irqchip_state'
ld: kernel/irq/manage.o: in function `irq_get_irqchip_state':
manage.c:(.text+0x5a2): undefined reference to `__irq_get_irqchip_state'
make: *** [Makefile:1038: vmlinux] Error 1

How did you test this?

{sigh}

I'm dropping all of these from my queue.  I think you need to just keep
this in your device-specific tree as obviously this is not ready to be
backported anywhere.

greg k-h
