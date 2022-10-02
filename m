Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1AB5F23DD
	for <lists+stable@lfdr.de>; Sun,  2 Oct 2022 17:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiJBP3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 11:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiJBP3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 11:29:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD3110FF7;
        Sun,  2 Oct 2022 08:29:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3665260EDE;
        Sun,  2 Oct 2022 15:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF36C433C1;
        Sun,  2 Oct 2022 15:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664724583;
        bh=ofutt5Q0qW9gogheXmlT5bUSqdw50QFhZCeand4aYZg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bq60aLknLfJOMOpNq7yUZVQ1Iw2pfJaGmsvAPJYouJ0grrjmlssOxFalefnC0dYgk
         Xj1d/fLpnWXzMBtdYt+A3fAVpGEFCKZMv1DdM9dlwjUbrGjtKoJR/rllSHJzmbZwGL
         fLCPG+EXf60l+leQyIePHZS2LDfgrG+33ZpNQSSk=
Date:   Sun, 2 Oct 2022 17:30:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rishabh Bhatnagar <risbhat@amazon.com>
Cc:     stable@vger.kernel.org, sashal@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, linux-kernel@vger.kernel.org, benh@amazon.com,
        mbacco@amazon.com
Subject: Re: [PATCH 0/6] IRQ handling patches backport to 4.14 stable
Message-ID: <YzmujBxtwUxHexem@kroah.com>
References: <20220929210651.12308-1-risbhat@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929210651.12308-1-risbhat@amazon.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Why is the serial driver freeing an irq while the system is running?
Ah, this could happen on a tty hangup, right?

> Let us know if more patches need backporting.

What hardware platform were these patches tested on to verify they work
properly?  And why can't they move to 4.19 or newer if they really need
this fix?  What's preventing that?

As Amazon doesn't seem to be testing 4.14.y -rc releases, I find it odd
that you all did this backport.  Is this a kernel that you all care
about?

thanks,

greg k-h
