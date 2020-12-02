Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E888D2CC6DC
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 20:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731208AbgLBTlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 14:41:25 -0500
Received: from mail.efficios.com ([167.114.26.124]:34380 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729325AbgLBTlY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 14:41:24 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id D6F7929590D;
        Wed,  2 Dec 2020 14:40:43 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id vWrVUVd2iSpP; Wed,  2 Dec 2020 14:40:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id A75C02956D3;
        Wed,  2 Dec 2020 14:40:43 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com A75C02956D3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1606938043;
        bh=ZbWych+DujWRPNQmIVevb1qb7nYwsQhMJTPEt1G9wvI=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=mq4kKfdpP86aZ67hjHKoJzldX1l+cuT2FrRyPSlSjks7sEHxdtbiww4eL2WXBuYyX
         YPAY1ksUKugID8bvrmu1seFIBNvcTpJ3dfuwNsFPH4r3Ul/6+timWoVGGgwmAU1dFW
         UmH8O2dnBxy44wGYcpASSfWtIUpBg0GfKavY5pQnE00fRAQ9CQrgd8FdBw/nrDlFCA
         iV9Y5drtefc2F2tVSU5HGwDQ3lxoUqVvbUWpCare4LwaKRdsP6MXj2IK34+T4LrrpG
         gxAL1y1zypn5d54G9n/+kDkIk2iaEGqzKfBwfPvPh+KR1qiBiY+gzxPXEU6SvLNA9D
         2sv0P1ckCgjfg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id t2orNj_2KpMg; Wed,  2 Dec 2020 14:40:43 -0500 (EST)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 9BB37295883;
        Wed,  2 Dec 2020 14:40:43 -0500 (EST)
Date:   Wed, 2 Dec 2020 14:40:43 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     x86 <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Anton Blanchard <anton@ozlabs.org>,
        stable <stable@vger.kernel.org>
Message-ID: <203775582.21.1606938043613.JavaMail.zimbra@efficios.com>
In-Reply-To: <510cb07946be056d2da7dda721bbf444c288751b.1606923183.git.luto@kernel.org>
References: <cover.1606923183.git.luto@kernel.org> <510cb07946be056d2da7dda721bbf444c288751b.1606923183.git.luto@kernel.org>
Subject: Re: [PATCH v2 2/4] membarrier: Add an actual barrier before
 rseq_preempt()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3980 (ZimbraWebClient - FF83 (Linux)/8.8.15_GA_3975)
Thread-Topic: membarrier: Add an actual barrier before rseq_preempt()
Thread-Index: DUdPRLnf4KSSPgoZCd6tDT7cln3AyA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- On Dec 2, 2020, at 10:35 AM, Andy Lutomirski luto@kernel.org wrote:

> It seems to me that most RSEQ membarrier users will expect any
> stores done before the membarrier() syscall to be visible to the
> target task(s).  While this is extremely likely to be true in
> practice, nothing actually guarantees it by a strict reading of the
> x86 manuals.  Rather than providing this guarantee by accident and
> potentially causing a problem down the road, just add an explicit
> barrier.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Andy Lutomirski <luto@kernel.org>

Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

> ---
> kernel/sched/membarrier.c | 8 ++++++++
> 1 file changed, 8 insertions(+)
> 
> diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
> index 5a40b3828ff2..6251d3d12abe 100644
> --- a/kernel/sched/membarrier.c
> +++ b/kernel/sched/membarrier.c
> @@ -168,6 +168,14 @@ static void ipi_mb(void *info)
> 
> static void ipi_rseq(void *info)
> {
> +	/*
> +	 * Ensure that all stores done by the calling thread are visible
> +	 * to the current task before the current task resumes.  We could
> +	 * probably optimize this away on most architectures, but by the
> +	 * time we've already sent an IPI, the cost of the extra smp_mb()
> +	 * is negligible.
> +	 */
> +	smp_mb();
> 	rseq_preempt(current);
> }
> 
> --
> 2.28.0

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
