Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1314128355
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 21:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbfLTUiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 15:38:52 -0500
Received: from albireo.enyo.de ([37.24.231.21]:55826 "EHLO albireo.enyo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726525AbfLTUiw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 15:38:52 -0500
Received: from [172.17.203.2] (helo=deneb.enyo.de)
        by albireo.enyo.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1iiP2t-00038h-Cg; Fri, 20 Dec 2019 20:38:47 +0000
Received: from fw by deneb.enyo.de with local (Exim 4.92)
        (envelope-from <fw@deneb.enyo.de>)
        id 1iiP27-00038J-SH; Fri, 20 Dec 2019 21:37:59 +0100
From:   Florian Weimer <fw@deneb.enyo.de>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>,
        Neel Natu <neelnatu@google.com>
Subject: Re: [PATCH for 5.5 1/2] rseq: Fix: Clarify rseq.h UAPI rseq_cs memory reclaim requirements
References: <20191220201207.17389-1-mathieu.desnoyers@efficios.com>
Date:   Fri, 20 Dec 2019 21:37:59 +0100
In-Reply-To: <20191220201207.17389-1-mathieu.desnoyers@efficios.com> (Mathieu
        Desnoyers's message of "Fri, 20 Dec 2019 15:12:06 -0500")
Message-ID: <87imman36g.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Mathieu Desnoyers:

> diff --git a/include/uapi/linux/rseq.h b/include/uapi/linux/rseq.h
> index 9a402fdb60e9..6f26b0b148a6 100644
> --- a/include/uapi/linux/rseq.h
> +++ b/include/uapi/linux/rseq.h
> @@ -100,7 +100,9 @@ struct rseq {
>  	 * instruction sequence block, as well as when the kernel detects that
>  	 * it is preempting or delivering a signal outside of the range
>  	 * targeted by the rseq_cs. Also needs to be set to NULL by user-space
> -	 * before reclaiming memory that contains the targeted struct rseq_cs.
> +	 * before reclaiming memory that contains the targeted struct rseq_cs
> +	 * or reclaiming memory that contains the code refered to by the
> +	 * start_ip and post_commit_offset fields of struct rseq_cs.

Maybe mention that it's good practice to clear rseq_cs before
returning from a function that contains a restartable sequence?

That will deal with the dlclose issue because even if the function
calls dlclose itself, unmapping something on call stack for dlclose is
already undefined.
