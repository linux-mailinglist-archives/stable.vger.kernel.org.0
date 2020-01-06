Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC1A913185B
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 20:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgAFTKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 14:10:40 -0500
Received: from mail.efficios.com ([167.114.142.138]:39290 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbgAFTKk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 14:10:40 -0500
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id A03D16944EA;
        Mon,  6 Jan 2020 14:10:38 -0500 (EST)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id KyGeu2p5HyCe; Mon,  6 Jan 2020 14:10:38 -0500 (EST)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 213486944E7;
        Mon,  6 Jan 2020 14:10:38 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 213486944E7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1578337838;
        bh=Qu3x60DNx5arxiFWBfIIJu97/cDoqLXAFxljCMqLL1I=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=EFgVP5Agp46TJfrFCfmQu30xM4M15qtYoOBPE+P0dSLyYa/1lN0YF+vPMgFFNL1Ao
         Elw/mxXy8fBsG8RSh0HLXgjvnNo5nET2r/g9ONkCdDUPIC4cEpSZR68jElaUoY/GnL
         xV4GL9g5bplJdjYt05np0AGEKe2DiOF6lkrQp309whne+3u7+qIRhOphfyowGYASpC
         2te9k69yCjUwr+ojToFtYG2krlwabhS3dNh5FL1TFXFdi3xoGg40YklQXxu9GkxsoY
         0iD7r1whdGVfpPa1qEz2tlvVjCIh0t3X+2TVOEtXnWnM+xYPVze58RCSEJwCOtdO41
         0KrdSFKMuf84g==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id 2zMWPdjfYLT5; Mon,  6 Jan 2020 14:10:38 -0500 (EST)
Received: from mail02.efficios.com (mail02.efficios.com [167.114.142.138])
        by mail.efficios.com (Postfix) with ESMTP id 062136944D6;
        Mon,  6 Jan 2020 14:10:38 -0500 (EST)
Date:   Mon, 6 Jan 2020 14:10:37 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        paulmck <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api <linux-api@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Florian Weimer <fw@deneb.enyo.de>,
        Dmitry Vyukov <dvyukov@google.com>,
        Neel Natu <neelnatu@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Message-ID: <688649540.853.1578337837967.JavaMail.zimbra@efficios.com>
In-Reply-To: <20191220203318.18739-1-mathieu.desnoyers@efficios.com>
References: <20191220203318.18739-1-mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH for 5.5 1/2 v2] rseq: Fix: Clarify rseq.h UAPI rseq_cs
 memory reclaim requirements
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.142.138]
X-Mailer: Zimbra 8.8.15_GA_3894 (ZimbraWebClient - FF71 (Linux)/8.8.15_GA_3890)
Thread-Topic: rseq: Fix: Clarify rseq.h UAPI rseq_cs memory reclaim requirements
Thread-Index: 7VOxhyid3ErFvbM9DicoUvZrucOkXg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- On Dec 20, 2019, at 3:33 PM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> The rseq.h UAPI documents that the rseq_cs field must be cleared
> before reclaiming memory that contains the targeted struct rseq_cs.
> 
> We should extend this comment to also dictate that the rseq_cs field
> must be cleared before reclaiming memory of the code pointed to by
> the rseq_cs start_ip and post_commit_offset fields.
> 
> While we can expect that use of dlclose(3) will typically unmap
> both struct rseq_cs and its associated code at once, nothing would
> theoretically prevent a JIT from reclaiming the code without
> reclaiming the struct rseq_cs, which would erroneously allow the
> kernel to consider new code which is not a rseq critical section
> as a rseq critical section following a code reclaim.

Hi Peter,

Is there anything preventing this rseq UAPI documentation fix from being merged ?

Thanks,

Mathieu

> 
> Suggested-by: Florian Weimer <fw@deneb.enyo.de>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Florian Weimer <fw@deneb.enyo.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: "H . Peter Anvin" <hpa@zytor.com>
> Cc: Paul Turner <pjt@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Neel Natu <neelnatu@google.com>
> Cc: linux-api@vger.kernel.org
> ---
> include/uapi/linux/rseq.h | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/rseq.h b/include/uapi/linux/rseq.h
> index 9a402fdb60e9..d94afdfc4b7c 100644
> --- a/include/uapi/linux/rseq.h
> +++ b/include/uapi/linux/rseq.h
> @@ -100,7 +100,9 @@ struct rseq {
> 	 * instruction sequence block, as well as when the kernel detects that
> 	 * it is preempting or delivering a signal outside of the range
> 	 * targeted by the rseq_cs. Also needs to be set to NULL by user-space
> -	 * before reclaiming memory that contains the targeted struct rseq_cs.
> +	 * before reclaiming memory that contains the targeted struct rseq_cs
> +	 * or reclaiming memory that contains the code referred to by the
> +	 * start_ip and post_commit_offset fields of struct rseq_cs.
> 	 *
> 	 * Read and set by the kernel. Set by user-space with single-copy
> 	 * atomicity semantics. This field should only be updated by the
> --
> 2.17.1

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
