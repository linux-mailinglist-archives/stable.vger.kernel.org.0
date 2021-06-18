Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BA93AD070
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 18:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235923AbhFRQeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 12:34:10 -0400
Received: from mail.efficios.com ([167.114.26.124]:59078 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbhFRQeC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 12:34:02 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 00410345A19;
        Fri, 18 Jun 2021 12:31:51 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id g5Prvf2nTCgQ; Fri, 18 Jun 2021 12:31:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 14489345611;
        Fri, 18 Jun 2021 12:31:49 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 14489345611
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1624033909;
        bh=c30zfFZ+WKXp4ykxS8QnPIbIIw3DBmBBPY/OSicceS4=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=UdYQQe9V8UnysEHZ4ypvGhvkJakwKFlXZfOOSiEIx6Vtn4MVWDCrB932vqHkbKDKO
         0R9dfLQXGPkjN89K5anYMmVgNOk6oFxWfoY7hu4LHYYqhYsFOEBkbgCQCJ+KnksiIo
         YRpyADqxvJEhcW/uoC3HtqyW987ODuYHgfKfd0kLgqp1P/734eJrGBnpOjUyLQF4AG
         kkoCq1Ds0EKHyY6V8GY3PAaZqCzpzoMt8y613SPe567xcsvzsIYaa8253BOuNNzf7X
         pVIVn4WSii7sy9z2zzLq6ld8JD/iEVwzmGvPjkDq/nkwmVI5H37veoPOBGZoqwjg4U
         YZPHdZIm0XFug==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id AfQYFeayD4T7; Fri, 18 Jun 2021 12:31:49 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id ED14C345A18;
        Fri, 18 Jun 2021 12:31:48 -0400 (EDT)
Date:   Fri, 18 Jun 2021 12:31:48 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     x86 <x86@kernel.org>, Dave Hansen <dave.hansen@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>
Message-ID: <593983567.12619.1624033908849.JavaMail.zimbra@efficios.com>
In-Reply-To: <26196903-4aee-33c4-bed8-8bf8c7b46793@kernel.org>
References: <cover.1623813516.git.luto@kernel.org> <07a8b963002cb955b7516e61bad19514a3acaa82.1623813516.git.luto@kernel.org> <827549827.10547.1623941277868.JavaMail.zimbra@efficios.com> <26196903-4aee-33c4-bed8-8bf8c7b46793@kernel.org>
Subject: Re: [PATCH 8/8] membarrier: Rewrite sync_core_before_usermode() and
 improve documentation
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF89 (Linux)/8.8.15_GA_4026)
Thread-Topic: membarrier: Rewrite sync_core_before_usermode() and improve documentation
Thread-Index: C3ezcgff2ZvgoZp+6lVucwS8DABVog==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- On Jun 17, 2021, at 8:12 PM, Andy Lutomirski luto@kernel.org wrote:

> On 6/17/21 7:47 AM, Mathieu Desnoyers wrote:
> 
>> Please change back this #ifndef / #else / #endif within function for
>> 
>> if (!IS_ENABLED(CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE)) {
>>   ...
>> } else {
>>   ...
>> }
>> 
>> I don't think mixing up preprocessor and code logic makes it more readable.
> 
> I agree, but I don't know how to make the result work well.
> membarrier_sync_core_before_usermode() isn't defined in the !IS_ENABLED
> case, so either I need to fake up a definition or use #ifdef.
> 
> If I faked up a definition, I would want to assert, at build time, that
> it isn't called.  I don't think we can do:
> 
> static void membarrier_sync_core_before_usermode()
> {
>    BUILD_BUG_IF_REACHABLE();
> }

Let's look at the context here:

static void ipi_sync_core(void *info)
{
    [....]
    membarrier_sync_core_before_usermode()
}

^ this can be within #ifdef / #endif

static int membarrier_private_expedited(int flags, int cpu_id)
[...]
               if (!IS_ENABLED(CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE))
                        return -EINVAL;
                if (!(atomic_read(&mm->membarrier_state) &
                      MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE_READY))
                        return -EPERM;
                ipi_func = ipi_sync_core;

All we need to make the line above work is to define an empty ipi_sync_core
function in the #else case after the ipi_sync_core() function definition.

Or am I missing your point ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
