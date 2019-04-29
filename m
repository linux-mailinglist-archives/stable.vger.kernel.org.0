Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38943E761
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 18:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728394AbfD2QNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 12:13:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56184 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728253AbfD2QNl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 12:13:41 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BDCBAC04959E;
        Mon, 29 Apr 2019 16:13:40 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.159])
        by smtp.corp.redhat.com (Postfix) with SMTP id 346B56B64A;
        Mon, 29 Apr 2019 16:13:38 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Mon, 29 Apr 2019 18:13:39 +0200 (CEST)
Date:   Mon, 29 Apr 2019 18:13:36 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Zhenliang Wei <weizhenliang@huawei.com>
Cc:     ebiederm@xmission.com, colona@arista.com,
        akpm@linux-foundation.org, christian@brauner.io, arnd@arndb.de,
        tglx@linutronix.de, deepa.kernel@gmail.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v5] signal: trace_signal_deliver when signal_group_exit
Message-ID: <20190429161336.GE17715@redhat.com>
References: <20190425025812.91424-1-weizhenliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190425025812.91424-1-weizhenliang@huawei.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Mon, 29 Apr 2019 16:13:41 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/25, Zhenliang Wei wrote:
>
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>

Yes, everything looks good to me

> Cc: <stable@vger.kernel.org>
> Fixes: cf43a757fd4944 ("signal: Restore the stop PTRACE_EVENT_EXIT")
> 
> Signed-off-by: Zhenliang Wei <weizhenliang@huawei.com>
> ---
>  kernel/signal.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 227ba170298e..429f5663edd9 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2441,6 +2441,8 @@ bool get_signal(struct ksignal *ksig)
>  	if (signal_group_exit(signal)) {
>  		ksig->info.si_signo = signr = SIGKILL;
>  		sigdelset(&current->pending.signal, SIGKILL);
> +		trace_signal_deliver(SIGKILL, SEND_SIG_NOINFO,
> +				&sighand->action[SIGKILL - 1]);
>  		recalc_sigpending();
>  		goto fatal;
>  	}
> -- 
> 2.14.1.windows.1
> 
> 

