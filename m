Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81845656BB
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 14:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbfGKMVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 08:21:42 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48942 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbfGKMVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jul 2019 08:21:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=L126jU2Qut/Cmlk8jA+23vne4GbXn8MhE5v9IRsKS9M=; b=AecyH3z7vXeAN3yErZeLBcVM3
        1CLnyldEBELmTQSTRbZnMXHcVP9G88OdSk1+qmHTAzrHYdGK6X2RBRD0m2YVGIGHAhmvw13muh6/p
        9GJhsJ49riwz9Ag6bx0hTFzZYSl0jfVOBOMIry49pOuciDHVGQ7pzTLM2m17QhjRIBw0OWSHwj0y8
        SHzS2FYUdGLPdvuk6K4xOqnCow8cHyWcCtbbjGiw5fnl9K/i3o+rf9fe+PcsQ4GGcMlQuYpDnf5VA
        zH4XaiqGEASDw2heBdtp6+vsTsZ78FrTtrkq+MYhRoH1tDLtqqJyc0CD3vB47FXtgmF24olza0mDX
        dgvffZEKQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hlY4m-00032z-35; Thu, 11 Jul 2019 12:21:28 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 801AC20B2B4DF; Thu, 11 Jul 2019 14:21:26 +0200 (CEST)
Date:   Thu, 11 Jul 2019 14:21:26 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Juergen Gross <jgross@suse.com>,
        LKML <linux-kernel@vger.kernel.org>,
        He Zhe <zhe.he@windriver.com>,
        Joel Fernandes <joel@joelfernandes.org>, devel@etsukata.com,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH v2 5/7] x86/mm, tracing: Fix CR2 corruption
Message-ID: <20190711122126.GN3419@hirez.programming.kicks-ass.net>
References: <20190704195555.580363209@infradead.org>
 <20190704200050.534802824@infradead.org>
 <CALCETrXvTvFBaQB-kEe4cRTCXUyTbWLbcveWsH-kX4j915c_=w@mail.gmail.com>
 <CALCETrUzP4Wb=WNhGvc7k4oX7QQz1JXZ3-O8PQhs39kmZid0nw@mail.gmail.com>
 <CAHk-=wh+J7ts6OrzzscMj5FONd3TRAwAKPZ=BQmEb2E8_-RXTA@mail.gmail.com>
 <20190710162709.1c306f8a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190710162709.1c306f8a@gandalf.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 10, 2019 at 04:27:09PM -0400, Steven Rostedt wrote:

> But isn't it easier for them to just pull the quick fix in, if it is in

Steve, I've not yet seen a quick fix that actually fixes all the
problems.

Your initial one only fixes the IRQ tracing one, but leaves the context
tracking one wide open.
