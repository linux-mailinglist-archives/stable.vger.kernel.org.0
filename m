Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 014E520E24
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 19:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbfEPRnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 13:43:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38860 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbfEPRnQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 13:43:16 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 966D830043F8;
        Thu, 16 May 2019 17:43:15 +0000 (UTC)
Received: from treble (ovpn-120-91.rdu2.redhat.com [10.10.120.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A8C2608A6;
        Thu, 16 May 2019 17:43:14 +0000 (UTC)
Date:   Thu, 16 May 2019 12:43:12 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] cpu/speculation: Warn on unsupported mitigations=
 parameter
Message-ID: <20190516174312.f3ipwv4io4tnulnn@treble>
References: <20190516070935.22546-1-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190516070935.22546-1-geert@linux-m68k.org>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 16 May 2019 17:43:15 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 16, 2019 at 09:09:35AM +0200, Geert Uytterhoeven wrote:
> Currently, if the user specifies an unsupported mitigation strategy on
> the kernel command line, it will be ignored silently.  The code will
> fall back to the default strategy, possibly leaving the system more
> vulnerable than expected.
> 
> This may happen due to e.g. a simple typo, or, for a stable kernel
> release, because not all mitigation strategies have been backported.
> 
> Inform the user by printing a message.
> 
> Fixes: 98af8452945c5565 ("cpu/speculation: Add 'mitigations=' cmdline option")
> Cc: stable@vger.kernel.org
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  kernel/cpu.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index f2ef10460698e9ec..8458fda00e6ddb88 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -2339,6 +2339,9 @@ static int __init mitigations_parse_cmdline(char *arg)
>  		cpu_mitigations = CPU_MITIGATIONS_AUTO;
>  	else if (!strcmp(arg, "auto,nosmt"))
>  		cpu_mitigations = CPU_MITIGATIONS_AUTO_NOSMT;
> +	else
> +		pr_crit("Unsupported mitigations=%s, system may still be vulnerable\n",
> +			arg);
>  
>  	return 0;
>  }
> -- 
> 2.17.1
> 

Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

-- 
Josh
