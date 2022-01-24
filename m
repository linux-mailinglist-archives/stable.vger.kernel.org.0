Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F27D497E40
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 12:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237956AbiAXLtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 06:49:53 -0500
Received: from mail.efficios.com ([167.114.26.124]:48842 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237983AbiAXLtw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 06:49:52 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id E32AA3428CE;
        Mon, 24 Jan 2022 06:49:50 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id xz0Jvo2HHOPX; Mon, 24 Jan 2022 06:49:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 5268C3429C4;
        Mon, 24 Jan 2022 06:49:50 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 5268C3429C4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1643024990;
        bh=70Ro/A1XGeVG9oQHqw8ICvwdo6uwoHMdEEqIu4jOcjc=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=CCTZDNReJNz+g8Q/BAXAtCATWo+ddvis2ieBCNx06veeVI9Z63AOvNgeqs+XpxpSi
         Pylm5U+q07ZA611ZEozxcFHwAvZntIcP2T/t3joS4b1Zwa4qjAUv/I4YOZljgbmrtG
         XPL83WbL70b645aDRPd+cTcDW9FCjJZAeTFIMZDFLF5/PR32WygE6hal+q4kU3S6Tl
         elY6pAMJqv1d+4Lv6R4IktecsOAr0hP+xMtrTT0mg3cW11H5ALQ3f9CyP+TPEixLW4
         sVVT6GjFvkrb31gZ19avdTlTeR9kyibc8tN+rHO5vOOE8B/bwoQb6U7dPmTZU2e6Iz
         Rz99nqIG6oZkQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id wHkc4UUiQWQT; Mon, 24 Jan 2022 06:49:50 -0500 (EST)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 33E473429C3;
        Mon, 24 Jan 2022 06:49:50 -0500 (EST)
Date:   Mon, 24 Jan 2022 06:49:50 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        paulmck <paulmck@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api <linux-api@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Florian Weimer <fw@deneb.enyo.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Dave Watson <davejwatson@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andi Kleen <andi@firstfloor.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Joel Fernandes <joelaf@google.com>
Message-ID: <1704063895.68277.1643024990042.JavaMail.zimbra@efficios.com>
In-Reply-To: <CAHk-=whhEB-A-ahgeMsozDfdGNmP_MB9JVnV3bavGbeqgfpStQ@mail.gmail.com>
References: <20220123193154.14565-1-mathieu.desnoyers@efficios.com> <CAHk-=whhEB-A-ahgeMsozDfdGNmP_MB9JVnV3bavGbeqgfpStQ@mail.gmail.com>
Subject: Re: [RFC PATCH] rseq: Fix broken uapi field layout on 32-bit little
 endian
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4180 (ZimbraWebClient - FF96 (Linux)/8.8.15_GA_4177)
Thread-Topic: rseq: Fix broken uapi field layout on 32-bit little endian
Thread-Index: 91NRQaoYbR37CijZG/AtbbyrNK/roA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- On Jan 24, 2022, at 2:42 AM, Linus Torvalds torvalds@linux-foundation.org wrote:

> On Sun, Jan 23, 2022 at 9:32 PM Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
>>
>> The rseq rseq_cs.ptr.{ptr32,padding} uapi endianness handling is
>> entirely wrong on 32-bit little endian: a preprocessor logic mistake
>> wrongly uses the big endian field layout on 32-bit little endian
>> architectures.
>>
>> Fortunately, those ptr32 accessors were never used within the kernel,
>> and only meant as a convenience for user-space.
> 
> Please don't double down on something that was already broken once.
> 
> Just remove the broken 32-bit one entirely that the kernel doesn't
> even use, and make everybody use
> 
>   __u64 ptr64;
> 
> and be done with it.

OK, should I just leave:

struct rseq {
  [...]
  union rseq_cs {
    __u64 ptr64;
  } rseq_cs;
  [...]
};

and remove all the other content from the union, so users of
rseq_abi->rseq_cs.ptr64 will continue to work as-is with either
old and new headers ? This keeps a union in place with a single
element, so I just want to confirm with you that is what you
have in mind.

It does make tons of sense to just remove the broken convenience
code and let user-space handle this based on the ptr64 field, so
it will work fine with old and new headers.

Thanks for your feedback, and travel safe!

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
