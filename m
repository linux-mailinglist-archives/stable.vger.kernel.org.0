Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5FE24B13C
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 10:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgHTIov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 04:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgHTIou (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 04:44:50 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FC3C061757;
        Thu, 20 Aug 2020 01:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+br4Xi9BUvjm1jO27R9i4VKynvG3ohMl1AfROGyvnRY=; b=CgDhH2a7Rc7W/e8dYGrNIh8YPu
        YXC5qQ1mUhO4kiL3+di3H+QmlF67a9TzrLTDP/nG0Rj317H0Gd8gG4GGqpxu3qeL5S5lEnZe1joiL
        FT8OUGDzT/OD8gVlVHVPMdnCniVLkLqZUloEr4nYott6iTZFGLdbQkpisJQN6TWUGnoCJ2hio0oz2
        muklmR4M7OLBVh5CpuNx7nir7ZXpEjHfTAn/+whk1r7nY9FBV0VBx3+6tyQwsxhx2V73w6zgFWXV6
        LjuNvVsGpiTRoyMDKzkWDWOmAhbI0oSF9uHP3roUuIvVIbnJKVcb20xqA0ru35Cx/g2rJ/EhiEPt8
        63qB1vvg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k8gBR-0001TJ-Hr; Thu, 20 Aug 2020 08:44:29 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 031D5301324;
        Thu, 20 Aug 2020 10:44:28 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id DCD7428B7E836; Thu, 20 Aug 2020 10:44:27 +0200 (CEST)
Date:   Thu, 20 Aug 2020 10:44:27 +0200
From:   peterz@infradead.org
To:     Andy Lutomirski <luto@kernel.org>
Cc:     x86@kernel.org, Kyle Huey <me@kylehuey.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Robert O'Callahan <rocallahan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Brian Gerst <brgerst@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Will Deacon <will@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/debug: Allow a single level of #DB recursion
Message-ID: <20200820084427.GO2674@hirez.programming.kicks-ass.net>
References: <8b9bd05f187231df008d48cf818a6a311cbd5c98.1597882384.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b9bd05f187231df008d48cf818a6a311cbd5c98.1597882384.git.luto@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 19, 2020 at 05:15:43PM -0700, Andy Lutomirski wrote:
> +static __always_inline void debug_enter(unsigned long *dr6, unsigned long *dr7)
> +{
> +	*dr6 = debug_read_clear_dr6();
>  }
>  
>  static __always_inline void debug_exit(unsigned long dr7)
>  {
> -	local_db_restore(dr7);
>  }

That's all unused after this patch, might as well remove it.
