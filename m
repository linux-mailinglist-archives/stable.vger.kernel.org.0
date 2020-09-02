Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABC025AB7B
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 14:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgIBMyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 08:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbgIBMyM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 08:54:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BD2C061245;
        Wed,  2 Sep 2020 05:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=isrzndUDYiz7AVFuWayAZA6ecBCJ63M610eK0GJhjus=; b=CJFTE95KS0gBy1UFDjdzh0P6Zl
        vDTCAlAnnxWW+J6nr0RwUn6VRG66ylaYFPPlvlH8rhBCX30JAYid8uFSWuD69AtxC76S30Nr9yXsl
        H9eSsb8jb691xbcuFWqBvs8VP94SA83/8/9kYBol3nd+u6Kw5IwsV0Hk7tHlS+sSfBM/nIW8oe1Ld
        NuJu5EM1RRyv7zitERugqVYenzVQi7IoEjJFh8U4MGebZbpucb8EHJA9shCLT3QeAcitanIwf1GXL
        hStgfJKmdVxowB0QR8dps2hyFpcFWoP2BEp4/AhKrNEmBmnuKbo2ZTE+mBMXLgyJG+bQq8WDwt5/L
        6ggoxK7Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kDSH5-00015w-UD; Wed, 02 Sep 2020 12:54:04 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id F0D3E3011C6;
        Wed,  2 Sep 2020 14:54:02 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id DE4C423D3D75E; Wed,  2 Sep 2020 14:54:02 +0200 (CEST)
Date:   Wed, 2 Sep 2020 14:54:02 +0200
From:   peterz@infradead.org
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Nadav Amit <namit@vmware.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/special_insn: reverse __force_order logic
Message-ID: <20200902125402.GG1362448@hirez.programming.kicks-ass.net>
References: <20200901161857.566142-1-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901161857.566142-1-namit@vmware.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 01, 2020 at 09:18:57AM -0700, Nadav Amit wrote:

> Unless I misunderstand the logic, __force_order should also be used by
> rdpkru() and wrpkru() which do not have dependency on __force_order. I
> also did not understand why native_write_cr0() has R/W dependency on
> __force_order, and why native_write_cr4() no longer has any dependency
> on __force_order.

There was a fairly large thread about this thing here:

  https://lkml.kernel.org/r/20200527135329.1172644-1-arnd@arndb.de

I didn't keep up, but I think the general concensus was that it's
indeed a bit naf.
