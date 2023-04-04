Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCBF16D5AAD
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 10:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbjDDIXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 04:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbjDDIXR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 04:23:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2852F1B7;
        Tue,  4 Apr 2023 01:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KtSOeF+WNLp6LDrLU00+5iLlovDzZEod0pAEJUP6bi0=; b=Gb7lXsGgza8FyhMkmFJCeJ+L91
        067XAhZ6Y4vACCH/9V/gMgUecKcilHprdAXrl/+VvVH4GfF0kLe4+VG/wgSPqtj/lrljkdS6flADe
        KC8s7CZhQYpF+PUfnQEDD+1ebia65r8CCjJSDja+482qwgg8zH7x5o9b/dMhAtVJ0Zqw7v7yNlJ1u
        Q5qO3yHCOlblfou1IMebCnWcMk3FDyJ2WPwNgauiHBUjAUDYm96c54muj5L7z9nuSfpRDugLlvwTr
        PpCdkL4shkyIPggC3MpYpoyODraoW8bYh+qPV4B9QuZuhly67r/0bUKYGHqfmYCnTUJnZgmX9OtU4
        ehkIr3EA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pjbwR-00FBOk-Ds; Tue, 04 Apr 2023 08:22:59 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id AC52E300338;
        Tue,  4 Apr 2023 10:22:55 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 35E42242109FC; Tue,  4 Apr 2023 10:22:55 +0200 (CEST)
Date:   Tue, 4 Apr 2023 10:22:55 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Benjamin Bara <bbara93@gmail.com>
Cc:     Wolfram Sang <wsa@kernel.org>, Lee Jones <lee@kernel.org>,
        rafael.j.wysocki@intel.com, dmitry.osipenko@collabora.com,
        jonathanh@nvidia.com, richard.leitner@linux.dev,
        treding@nvidia.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-tegra@vger.kernel.org,
        Benjamin Bara <benjamin.bara@skidata.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 2/4] i2c: core: run atomic i2c xfer when !preemptible
Message-ID: <20230404082255.GU4253@hirez.programming.kicks-ass.net>
References: <20230327-tegra-pmic-reboot-v3-0-3c0ee3567e14@skidata.com>
 <20230327-tegra-pmic-reboot-v3-2-3c0ee3567e14@skidata.com>
 <ZCGuMzmS0Lz5WX2/@ninjato>
 <CAJpcXm6bt100442y8ajz7kR0nF3Gm9PVVwo3EKVBDC4Pmd-7Ag@mail.gmail.com>
 <ZCSWkhyQjnzByDoR@shikoro>
 <CAJpcXm5eKhQg3JDksGs5fHi-DN+VAJNnuyUKtQGiS2OzTgzyVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJpcXm5eKhQg3JDksGs5fHi-DN+VAJNnuyUKtQGiS2OzTgzyVw@mail.gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 02, 2023 at 12:04:48PM +0200, Benjamin Bara wrote:
> On Wed, 29 Mar 2023 at 21:50, Wolfram Sang <wsa@kernel.org> wrote:
> > Could you make sure please?
> 
> Sure, I'll try. The check before bae1d3a was:
> in_atomic() || irqs_disabled()
> which boils down to:
> (preempt_count() != 0) || irqs_disabled()
> preemptible() is defined as:
> (preempt_count() == 0 && !irqs_disabled())
> 
> so this patch should behave the same as pre-v5.2, but with the
> additional system state check. From my point of view, the additional
> value of the in_atomic() check was that it activated atomic i2c xfers
> when preemption is disabled, like in the case of panic(). So reverting
> that commit would also re-activate atomic i2c transfers during emergency
> restarts. However, I think considering the system state makes sense
> here.
> 
> From my understanding, non-atomic i2c transfers require enabled IRQs,
> but atomic i2c transfers do not have any "requirements". So the
> irqs_disabled() check is not here to ensure that the following atomic
> i2c transfer works correctly, but to use non-atomic i2c xfer as
> long/often as possible.
> 
> Unfortunately, I am not sure yet about !CONFIG_PREEMPTION. I looked into
> some i2c-bus implementations which implement both, atomic and
> non-atomic. As far as I saw, the basic difference is that the non-atomic
> variants usually utilize the DMA and then call a variant of
> wait_for_completion(), like in i2c_imx_dma_write() [1]. However, the
> documentation of wait_for_completion [2] states that:
> "wait_for_completion() and its variants are only safe in process context
> (as they can sleep) but not (...) [if] preemption is disabled".
> Therefore, I am not quite sure yet if !CONFIG_PREEMPTION uses the
> non-atomic variant at all or if this case is handled differently.
> 
> > Asking Peter Zijlstra might be a good idea.
> > He helped me with the current implementation.
> 
> Thanks for the hint! I wrote an extra email to him and added him to CC.

So yeah, can't call schedule() if non preemptible (which is either
preempt_disable(), local_bh_disable() (true for bh handlers) or
local_irq_disable() (true for IRQ handlers) and mostly rcu_read_lock()).

You can mostly forget about CONFIG_PREEMPT=n (or more specifically
CONFIG_PREMPT_COUNT=n) things that work for PREEMPT typically also work
for !PREEMPT.

The question here seems to be if i2c_in_atomic_xfer_mode() should have
an in_atomic() / !preemptible() check, right? IIUC Wolfram doesn't like
it being used outside of extra special cicumstances?




