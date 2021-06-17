Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADDC03AB720
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 17:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbhFQPTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 11:19:04 -0400
Received: from mail.efficios.com ([167.114.26.124]:47702 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbhFQPTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Jun 2021 11:19:03 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 6DF8E33B97A;
        Thu, 17 Jun 2021 11:16:55 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 6FkT1ZEic_fK; Thu, 17 Jun 2021 11:16:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id EB82733BC58;
        Thu, 17 Jun 2021 11:16:54 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com EB82733BC58
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1623943015;
        bh=ROnVRWF2UoAH/7ueXDWMtiXvYVP3M18VQ9wYPKu2gEw=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=P3k3qk1cnD1lMMto5ySMR/WelzJExEJ0HujojzWruRzISCZGhhmX+ioxDmw7PyeGY
         oc4J928o7tDQSr8QG5gctcQsXN95YjffhsNb9fhoO0kXBhAvobKcaHCgIib33jUV+A
         QKL5TS9POshsmjI/cnxrpblCA4P/44fRil8k7b6Ja0WyqHiWxpJ4V0X0LEaFPmg8KR
         p1uHtTQkVc9VtTun/4yDAmZleAPe774yTA0HkLdpI43TB2+hP1JNLsW9QJmdbxhCn5
         4D5uifFDlPd8EneKXQyeSyBkA/Wv0cBWm6/WXKIw94lkdgdBaK5T7k+t35CT+TGlE8
         YeRPeMiEqjrPA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id cG6XBCwS7rhr; Thu, 17 Jun 2021 11:16:54 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id D62BE33BD1F;
        Thu, 17 Jun 2021 11:16:54 -0400 (EDT)
Date:   Thu, 17 Jun 2021 11:16:54 -0400 (EDT)
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
Message-ID: <1939350496.10696.1623943014767.JavaMail.zimbra@efficios.com>
In-Reply-To: <07a8b963002cb955b7516e61bad19514a3acaa82.1623813516.git.luto@kernel.org>
References: <cover.1623813516.git.luto@kernel.org> <07a8b963002cb955b7516e61bad19514a3acaa82.1623813516.git.luto@kernel.org>
Subject: Re: [PATCH 8/8] membarrier: Rewrite sync_core_before_usermode() and
 improve documentation
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF89 (Linux)/8.8.15_GA_4026)
Thread-Topic: membarrier: Rewrite sync_core_before_usermode() and improve documentation
Thread-Index: ELJGNmQxqiwrOsT5GguO2Vz+nt4HDg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- On Jun 15, 2021, at 11:21 PM, Andy Lutomirski luto@kernel.org wrote:

[...]

> +# An architecture that wants to support
> +# MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE needs to define precisely what it
> +# is supposed to do and implement membarrier_sync_core_before_usermode() to
> +# make it do that.  Then it can select ARCH_HAS_MEMBARRIER_SYNC_CORE via
> +# Kconfig.Unfortunately, MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE is not a
> +# fantastic API and may not make sense on all architectures.  Once an
> +# architecture meets these requirements,

Can we please remove the editorial comment about the quality of the membarrier
sync-core's API ?

At least it's better than having all userspace rely on mprotect() undocumented
side-effects to perform something which typically works, until it won't, or until
this prevents mprotect's implementation to be improved because it will start breaking
JITs all over the place.

We can simply state that the definition of what membarrier sync-core does is defined
per-architecture, and document the sequence of operations to perform when doing
cross-modifying code specifically for each architecture.

Now if there are weird architectures where membarrier is an odd fit (I've heard that
riscv might need address ranges to which the core sync needs to apply), then those
might need to implement their own arch-specific system call, which is all fine.

> +#
> +# On x86, a program can safely modify code, issue
> +# MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE, and then execute that code, via
> +# the modified address or an alias, from any thread in the calling process.
> +#
> +# On arm64, a program can modify code, flush the icache as needed, and issue
> +# MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE to force a "context synchronizing
> +# event", aka pipeline flush on all CPUs that might run the calling process.
> +# Then the program can execute the modified code as long as it is executed
> +# from an address consistent with the icache flush and the CPU's cache type.
> +#
> +# On powerpc, a program can use MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE
> +# similarly to arm64.  It would be nice if the powerpc maintainers could
> +# add a more clear explanantion.

We should document the requirements on ARMv7 as well.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
