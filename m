Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7293ECF622
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 11:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbfJHJgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 05:36:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38618 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728866AbfJHJgD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 05:36:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0YgVP91KI4VHuLmn1K3QzHL12U4bKFNdz2YEz+MPIYM=; b=Vi4LUbhXPdMNEefTwmilVNP8m
        GI1KuLTMqSWRU9k3hfr6M+XEc8f+ZeUgZRTDufoV9bgNgAiPS87Qscw+JJ2cJdCnyr8c9ZZEhgg9q
        HnBoEH9QFskTymjHM3Hzw2zvkrhEpqagFMJb7Xqhf+JMKFY/Oa0jXpPQ92jxFM6TFyIj7okcDfWcf
        XvjUfqNS0+cE3mSQTF7rkf11dj1dPHiJGoz7/kGj0XsrmWxa3TOfSxHeorppXTBVKNPGORL0kx7Xw
        CsVGhTwDLLy7uPsl1TW1QHMIsN5Bcpj3OaCMIqN1gSKy1VUHsAigHCzfS4PEEEpXqFuQnn8FIYN/o
        be1AwYXqQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iHluP-0005hB-Ne; Tue, 08 Oct 2019 09:35:57 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 61F51305EE1;
        Tue,  8 Oct 2019 11:35:03 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id ACF02202A1956; Tue,  8 Oct 2019 11:35:54 +0200 (CEST)
Date:   Tue, 8 Oct 2019 11:35:54 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-kernel@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] perf/core: fix corner case in perf_rotate_context()
Message-ID: <20191008093554.GK2294@hirez.programming.kicks-ass.net>
References: <20191003064317.3961135-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003064317.3961135-1-songliubraving@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 02, 2019 at 11:43:17PM -0700, Song Liu wrote:
> This is a rare corner case, but it does happen:
> 
> In perf_rotate_context(), when the first cpu flexible event fail to
> schedule, cpu_rotate is 1, while cpu_event is NULL.

You're failing to explain how we get here in the first place.

> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 4655adbbae10..50021735f367 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3775,6 +3775,13 @@ static void rotate_ctx(struct perf_event_context *ctx, struct perf_event *event)
>  	if (ctx->rotate_disable)
>  		return;
>  
> +	/* if no event specified, try to rotate the first event */
> +	if (!event)
> +		event = rb_entry_safe(rb_first(&ctx->flexible_groups.tree),
> +				      typeof(*event), group_node);
> +	if (!event)
> +		return;
> +
>  	perf_event_groups_delete(&ctx->flexible_groups, event);
>  	perf_event_groups_insert(&ctx->flexible_groups, event);
>  }

I don't think that is a very nice solution; would not something simpler
like this be sufficient? (although possible we should rename that
function now).

And it needs more comments.

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4655adbbae10..772a9854eb3a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3782,8 +3797,17 @@ static void rotate_ctx(struct perf_event_context *ctx, struct perf_event *event)
 static inline struct perf_event *
 ctx_first_active(struct perf_event_context *ctx)
 {
-	return list_first_entry_or_null(&ctx->flexible_active,
-					struct perf_event, active_list);
+	struct perf_event *event;
+
+	event = list_first_entry_or_null(&ctx->flexible_active,
+					 struct perf_event, active_list);
+
+	if (!event) {
+		event = rb_entry_safe(rb_first(&ctx->flexible_groups.tree),
+				      typeof(*event), group_node);
+	}
+
+	return event;
 }
 
 static bool perf_rotate_context(struct perf_cpu_context *cpuctx)
