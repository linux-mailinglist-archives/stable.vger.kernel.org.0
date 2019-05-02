Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB4EB1202D
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 18:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfEBQaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 12:30:07 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50860 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbfEBQaH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 12:30:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=d/mogJNEljMgTR4EF767wY8IUbjJwC9Mjt7j8iKP5Ss=; b=uhbId7piLVXP4Ru9l8Ti/O27c
        ZcWp8dbZDP2EGhcZiHtQyJwDR6ECvulcXyh31Bfw9jLNVY1wXFCNjhVqGmcwuLgv01ylniHTj656j
        BGjYd13Oj/Ed3fuRuLCD1SxAwYtPwBz8Q49QPzObe1qDRW8l/SqWMBPgNlqfPdWjgH3b3AWeRHnDe
        93gJa2g8w6lRp/RFbg1zNtxJD6Ud/S6mw0Sxn0Xuh2i5+kAvE84A1khjbYt4X/s3H1Eay6Y9ShL+X
        abYQVze9WZPb32yxMlSmduNDCFkN5+jsfIUUUasO4/VxybjcYcJulmOXwn0m8y56SWoZ+H63RXMeU
        phN+LLNwA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hMEaX-00016L-GN; Thu, 02 May 2019 16:29:37 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id BCCE22066BB89; Thu,  2 May 2019 18:29:35 +0200 (CEST)
Date:   Thu, 2 May 2019 18:29:35 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Juergen Gross <jgross@suse.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nayna Jain <nayna@linux.ibm.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Joerg Roedel <jroedel@suse.de>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
Message-ID: <20190502162935.GC2650@hirez.programming.kicks-ass.net>
References: <20190501202830.347656894@goodmis.org>
 <20190501203152.397154664@goodmis.org>
 <20190501232412.1196ef18@oasis.local.home>
 <20190502162133.GX2623@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502162133.GX2623@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 02, 2019 at 06:21:33PM +0200, Peter Zijlstra wrote:
> Much thanks to Joerg Roedel for talking entry_32.S with me.
> 
> TL;DR, on x86_32 kernel->kernel IRET frames are only 3 entries and do
> not include ESP/SS, so not only wasn't regs->sp setup, if you changed it
> it wouldn't be effective and corrupt random stack state.

Also, i386 is bloody insane...
