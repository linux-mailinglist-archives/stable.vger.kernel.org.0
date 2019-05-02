Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65F7F12429
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 23:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbfEBVdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 17:33:13 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55544 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbfEBVdN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 17:33:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZXqnuo0JSIuRggTcqyOSAvcyo1xhZ/4jSajZfdhhW24=; b=RQWf4StrNHmwEF6NAVXxFPJ2s
        Sxzl51CDrOJuvMAA+fYwI41eZ3d7WnH69VgOI8/coS6GZjyfBkyouvMkqz0y4EFDW6C90it/y+BMI
        lstFwapGleV7DCIkgIZCWUp78icSvdsGnF5QiJREea/5Sw6MNdWEEGOIFUwkl15Yx1+ai0jlv3w91
        +yrUGaP4xHamqYJCQa6ZPGC0dYo1uWWJGS+rA8yjN4/fPvrYV9Wu2PDu4v0yjn4rk7OzEJt25cg7C
        nC1O8DHz7/yJdbKdhlfmTV8mChs6Kt8K8AGEb7fQWqMw48YUjfCXSTLGkvupy9TvKXNgjlIhJmEXi
        1/2p9Dl+A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hMJJq-0004Nq-5V; Thu, 02 May 2019 21:32:42 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 69A4F209A1C85; Thu,  2 May 2019 23:32:39 +0200 (CEST)
Date:   Thu, 2 May 2019 23:32:39 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
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
        <linux-kselftest@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
Message-ID: <20190502213239.GA2623@hirez.programming.kicks-ass.net>
References: <20190501202830.347656894@goodmis.org>
 <20190501203152.397154664@goodmis.org>
 <20190501232412.1196ef18@oasis.local.home>
 <20190502162133.GX2623@hirez.programming.kicks-ass.net>
 <CAHk-=wijZ-MD4g3zMJ9W2r=h8LUWneiu29OWuxZEoSfAF=0bhQ@mail.gmail.com>
 <20190502181811.GY2623@hirez.programming.kicks-ass.net>
 <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
 <20190502202146.GZ2623@hirez.programming.kicks-ass.net>
 <CAHk-=wh8bi5c_GkyjPtDAiaXaZRqtmhWs30usUvs4qK_F+c9tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wh8bi5c_GkyjPtDAiaXaZRqtmhWs30usUvs4qK_F+c9tg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 02, 2019 at 01:49:29PM -0700, Linus Torvalds wrote:

> We *could* also make this kernel-mode-only do_int3() be a special
> function, and do something like

I think I prefer the variant we have now. The int3_emulate_*() things
work uniformly and as expected on 32 and 64 bit (it would even work for
userspace if it weren't for SMAP).

So while the 32bit kernel entry is 'special' all the INT3 handlers can
uniformly prod at pt_regs in a natural way and have it work.

Making it special -- just for 32bit, seems like the wrong thing to me.
