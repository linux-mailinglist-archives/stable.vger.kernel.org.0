Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E0D1D15A4
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 15:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbgEMNgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 09:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728694AbgEMNgW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 09:36:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701F2C061A0C
        for <stable@vger.kernel.org>; Wed, 13 May 2020 06:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xSs+CiMh9BR2tUWPtLIWKfYTZt/YCN37Fjwh7L7I57Y=; b=QZE+tPjw5bLjLKdncReNYoVYse
        efOvAy74RxzcsrWZ/PVPP+KT1AOzMulRr+AvwKAl2mTNFpfa6AzhycN+WulVFmMPakCjCtGACZyg2
        fzf3krqfwvrhACxntfH+kGfM1Ki+Sj//qcWku14oH4cVsgXLs5Q1KPovKPJMjz/3NHXuW48K2z9xZ
        ALdQNYx2vwnqEb9drfxdX3WyIvsqtWFgNVb3DTDDJGLBaKNYFQMDoQVg0w89C8cilWAogWWpd/K1N
        NwbrBfue+QJ7TyaCtZkcSIPBMjB8O8prUVh0DcglkU8EATaizdskWYivdTFGHU3youDgVipAdbQbb
        j3n6L6/Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYrYR-0006Hf-GW; Wed, 13 May 2020 13:36:11 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 74CD0301A66;
        Wed, 13 May 2020 15:36:09 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5E84924C0C645; Wed, 13 May 2020 15:36:09 +0200 (CEST)
Date:   Wed, 13 May 2020 15:36:09 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Geert Uytterhoeven' <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        stable <stable@vger.kernel.org>,
        Alexey Brodkin <alexey.brodkin@synopsys.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vineet Gupta <vgupta@synopsys.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 4.4 03/16] devres: Align data[] to ARCH_KMALLOC_MINALIGN
Message-ID: <20200513133609.GO2978@hirez.programming.kicks-ass.net>
References: <20200423204014.784944-1-lee.jones@linaro.org>
 <20200423204014.784944-4-lee.jones@linaro.org>
 <20200513093536.GB830571@kroah.com>
 <CAMuHMdVZHodDXGOMuOpVLbgiy9_WeHHKKq4kG7Cz9u9pm8UZuw@mail.gmail.com>
 <335fbcc7d9ad4d429ec11e9ac2caf118@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <335fbcc7d9ad4d429ec11e9ac2caf118@AcuMS.aculab.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 13, 2020 at 10:10:03AM +0000, David Laight wrote:
> From: Geert Uytterhoeven
> > Sent: 13 May 2020 10:49
> ...
> > > I don't want to apply this to older kernels as it could cause extra
> > > memory usage for no good reason.  I have no idea why a non ARC system
> > > would want it :(
> > 
> > I think the reference to ARC is a red herring.
> > The real issue is that buffers used for DMA may not have the required
> > alignment, which is not limited to ARC systems.
> > 
> > Note that I'm also not super happy with the extra memory usage.
> > But devm_*() conveniences come with their penalties...
> 
> Interesting thought.
> Could the devm 'header' be put right at the end of the kmalloc()
> buffer?

https://lkml.kernel.org/r/20191220140655.GN2827@hirez.programming.kicks-ass.net
