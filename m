Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F7C2CC6E6
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 20:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387803AbgLBToO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 14:44:14 -0500
Received: from mail.efficios.com ([167.114.26.124]:35830 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387728AbgLBToN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 14:44:13 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 85A1B2958A0;
        Wed,  2 Dec 2020 14:43:32 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id LMQl0FbQ0MwZ; Wed,  2 Dec 2020 14:43:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 320CF29598B;
        Wed,  2 Dec 2020 14:43:32 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 320CF29598B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1606938212;
        bh=ogheDfKtXNTDNHhK32MxcfwuxxfxJsU42z+GpqPElTc=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=RBHXCKKMEgXXw1xvhiAdyiNdsqDmyn0AUgnT/2Ex8LyYKGY78L+HkHaenafTrWeSy
         myKVZe6L97RLDwSjPu7nYE+goo4eiZZaYh1nRLey5BPFp8WeQhXZJQ74MzjtavoR94
         fMkqHM9Qp6s/daxiWuU99NOBgM9QzhPJZga7TS0J3gY1sgr6/4fZHPrrO298d0CYhW
         tP9AwingvjbhbPOYwWBMhAsOiDImiLEmW7b2+Xec7KpFfuQu+3trtcJtMDJoTq+6JM
         /L3oVadZwUZbvaPTq0YCxitafsgSShTRqInkxGLrJoWMqguarkTVKlluUe5Em3LTav
         IWgPEsotKkiQQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id rEmeOrRFCK1m; Wed,  2 Dec 2020 14:43:32 -0500 (EST)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 27CDE2956F7;
        Wed,  2 Dec 2020 14:43:32 -0500 (EST)
Date:   Wed, 2 Dec 2020 14:43:32 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     x86 <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Anton Blanchard <anton@ozlabs.org>,
        stable <stable@vger.kernel.org>
Message-ID: <1515215436.71.1606938212130.JavaMail.zimbra@efficios.com>
In-Reply-To: <6d4c8ff7300c72fd4d44ee5755bd149359f2661a.1606923183.git.luto@kernel.org>
References: <cover.1606923183.git.luto@kernel.org> <6d4c8ff7300c72fd4d44ee5755bd149359f2661a.1606923183.git.luto@kernel.org>
Subject: Re: [PATCH v2 3/4] membarrier: Explicitly sync remote cores when
 SYNC_CORE is requested
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3980 (ZimbraWebClient - FF83 (Linux)/8.8.15_GA_3975)
Thread-Topic: membarrier: Explicitly sync remote cores when SYNC_CORE is requested
Thread-Index: e/tbmxOQ2nZ95dGLmHykVXHQTDm2nQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- On Dec 2, 2020, at 10:35 AM, Andy Lutomirski luto@kernel.org wrote:

> membarrier() does not explicitly sync_core() remote CPUs; instead, it
> relies on the assumption that an IPI will result in a core sync.  On
> x86, I think this may be true in practice, but it's not architecturally
> reliable.  In particular, the SDM and APM do not appear to guarantee
> that interrupt delivery is serializing.  While IRET does serialize, IPI
> return can schedule, thereby switching to another task in the same mm
> that was sleeping in a syscall.  The new task could then SYSRET back to
> usermode without ever executing IRET.
> 
> Make this more robust by explicitly calling sync_core_before_usermode()
> on remote cores.  (This also helps people who search the kernel tree for
> instances of sync_core() and sync_core_before_usermode() -- one might be
> surprised that the core membarrier code doesn't currently show up in a
> such a search.)
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Andy Lutomirski <luto@kernel.org>

Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

> ---
> kernel/sched/membarrier.c | 18 ++++++++++++++++++
> 1 file changed, 18 insertions(+)
> 
> diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
> index 6251d3d12abe..01538b31f27e 100644
> --- a/kernel/sched/membarrier.c
> +++ b/kernel/sched/membarrier.c
> @@ -166,6 +166,23 @@ static void ipi_mb(void *info)
> 	smp_mb();	/* IPIs should be serializing but paranoid. */
> }
> 
> +static void ipi_sync_core(void *info)
> +{
> +	/*
> +	 * The smp_mb() in membarrier after all the IPIs is supposed to
> +	 * ensure that memory on remote CPUs that occur before the IPI
> +	 * become visible to membarrier()'s caller -- see scenario B in
> +	 * the big comment at the top of this file.
> +	 *
> +	 * A sync_core() would provide this guarantee, but
> +	 * sync_core_before_usermode() might end up being deferred until
> +	 * after membarrier()'s smp_mb().
> +	 */
> +	smp_mb();	/* IPIs should be serializing but paranoid. */
> +
> +	sync_core_before_usermode();
> +}
> +
> static void ipi_rseq(void *info)
> {
> 	/*
> @@ -301,6 +318,7 @@ static int membarrier_private_expedited(int flags, int
> cpu_id)
> 		if (!(atomic_read(&mm->membarrier_state) &
> 		      MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE_READY))
> 			return -EPERM;
> +		ipi_func = ipi_sync_core;
> 	} else if (flags == MEMBARRIER_FLAG_RSEQ) {
> 		if (!IS_ENABLED(CONFIG_RSEQ))
> 			return -EINVAL;
> --
> 2.28.0

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
