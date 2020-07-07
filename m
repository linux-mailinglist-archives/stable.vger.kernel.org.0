Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C79721677C
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 09:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgGGHaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 03:30:16 -0400
Received: from albireo.enyo.de ([37.24.231.21]:49088 "EHLO albireo.enyo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgGGHaP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 03:30:15 -0400
Received: from [172.17.203.2] (helo=deneb.enyo.de)
        by albireo.enyo.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1jsi3R-0000ZL-3u; Tue, 07 Jul 2020 07:30:13 +0000
Received: from fw by deneb.enyo.de with local (Exim 4.92)
        (envelope-from <fw@deneb.enyo.de>)
        id 1jsi3R-0003fR-19; Tue, 07 Jul 2020 09:30:13 +0200
From:   Florian Weimer <fw@deneb.enyo.de>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Neel Natu <neelnatu@google.com>, stable@vger.kernel.org
Subject: Re: [RFC PATCH for 5.8 1/4] sched: Fix unreliable rseq cpu_id for new tasks
References: <20200706204913.20347-1-mathieu.desnoyers@efficios.com>
        <20200706204913.20347-2-mathieu.desnoyers@efficios.com>
Date:   Tue, 07 Jul 2020 09:30:13 +0200
In-Reply-To: <20200706204913.20347-2-mathieu.desnoyers@efficios.com> (Mathieu
        Desnoyers's message of "Mon, 6 Jul 2020 16:49:10 -0400")
Message-ID: <87blkrzssa.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Mathieu Desnoyers:

> While integrating rseq into glibc and replacing glibc's sched_getcpu
> implementation with rseq, glibc's tests discovered an issue with
> incorrect __rseq_abi.cpu_id field value right after the first time
> a newly created process issues sched_setaffinity.
>
> For the records, it triggers after building glibc and running tests, and
> then issuing:
>
>   for x in {1..2000} ; do posix/tst-affinity-static  & done
>
> and shows up as:
>
> error: Unexpected CPU 2, expected 0
> error: Unexpected CPU 2, expected 0
> error: Unexpected CPU 2, expected 0
> error: Unexpected CPU 2, expected 0
> error: Unexpected CPU 138, expected 0
> error: Unexpected CPU 138, expected 0
> error: Unexpected CPU 138, expected 0
> error: Unexpected CPU 138, expected 0

As far as I can tell, the glibc reproducer no longer shows the issue
with this patch applied.

Tested-By: Florian Weimer <fweimer@redhat.com>
