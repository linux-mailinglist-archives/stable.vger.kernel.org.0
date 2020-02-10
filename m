Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D40C157D80
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 15:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgBJOgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 09:36:32 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:41096 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727728AbgBJOgc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 09:36:32 -0500
Received: by mail-qv1-f65.google.com with SMTP id s7so3244129qvn.8
        for <stable@vger.kernel.org>; Mon, 10 Feb 2020 06:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sw8aLoMN7edQi9tCuvhNl/iVTODc75PkGH73eAqI96U=;
        b=jkUs4hzNPVCxprNaYv/MX6zJKcph8mNHMTtg4GPspg617lRSe8FqvFZb+o6DjOVQrr
         37PLeSeLutY7XJ9bF9R8p8fkpRVR1+dbJ/xoFkZpdtBhUjgQ8XP3/erYccm80CSIsQOt
         HdrE0hqNGzxMN1RMnvutju/NJGpV26qWRmjJE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sw8aLoMN7edQi9tCuvhNl/iVTODc75PkGH73eAqI96U=;
        b=G6GduyH0P673tlzmzMxRgC5mhukXqZhMEovg9dhD/bO0kOav4FAX1NzpW21LOC3PHs
         3e1oTE5Xdc0eStOKRZCvqEifi51DlW3F3tQ2USNsPJ/nyUl8vCL7A93i64CE3r2ZheaY
         ear9KtyakXG+Ksf5zMIg1CpoaeWtqkPcaXMCM6VuVh0OVYUEjmv3ASsSI+58IEXCp8k1
         gpKg4Qt3uqN9XwUO9Daa/WMXGIpS38AiBE6KZK+ztZSMo6CLGXSdLV45HIeTUw29txvH
         9Lf1bvB9Vz2sGz9hh6IRF2KeCk47uilKf8jSd9f+qizYXhZejS0Ehl2ViFq6zGmUmbGH
         FpRA==
X-Gm-Message-State: APjAAAXPXnnNFH9kh6O1QMPnRLD8M1Irxl1v2jgCaV175OjMb0VhXzBU
        f+apgkZexld70qUkMjJgd45sj4zstk6MSfZi/NTUZA==
X-Google-Smtp-Source: APXvYqwRHxH3WegeUNyf9KYF23HojSS4aZrwxB1WWUB6IVN0BNlAXwRaNtfCrRRaOByrQcK4G1XSGw2HvfkGNzkvMhQ=
X-Received: by 2002:a0c:f685:: with SMTP id p5mr10354179qvn.44.1581345391131;
 Mon, 10 Feb 2020 06:36:31 -0800 (PST)
MIME-Version: 1.0
References: <20200210122423.695146547@linuxfoundation.org> <20200210122438.674498788@linuxfoundation.org>
In-Reply-To: <20200210122438.674498788@linuxfoundation.org>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Mon, 10 Feb 2020 06:36:20 -0800
Message-ID: <CAEXW_YSPDHcuLiM4B8uXvw-0ei2Gj0x=QE1h+NMqzRiBph1oNw@mail.gmail.com>
Subject: Re: [PATCH 5.5 150/367] tracing: Annotate ftrace_graph_hash pointer
 with __rcu
To:     Amol Grover <frextrite@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 10, 2020 at 4:40 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Amol Grover <frextrite@gmail.com>
>
> [ Upstream commit 24a9729f831462b1d9d61dc85ecc91c59037243f ]

Amol, can you send a follow-up patch to annotate
ftrace_graph_notrace_hash as well?

- Joel

>
> Fix following instances of sparse error
> kernel/trace/ftrace.c:5664:29: error: incompatible types in comparison
> kernel/trace/ftrace.c:5785:21: error: incompatible types in comparison
> kernel/trace/ftrace.c:5864:36: error: incompatible types in comparison
> kernel/trace/ftrace.c:5866:25: error: incompatible types in comparison
>
> Use rcu_dereference_protected to access the __rcu annotated pointer.
>
> Link: http://lkml.kernel.org/r/20200201072703.17330-1-frextrite@gmail.com
>
> Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> Signed-off-by: Amol Grover <frextrite@gmail.com>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  kernel/trace/ftrace.c | 2 +-
>  kernel/trace/trace.h  | 9 ++++++---
>  2 files changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 9bf1f2cd515ef..959ded08dc13f 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -5596,7 +5596,7 @@ static const struct file_operations ftrace_notrace_fops = {
>
>  static DEFINE_MUTEX(graph_lock);
>
> -struct ftrace_hash *ftrace_graph_hash = EMPTY_HASH;
> +struct ftrace_hash __rcu *ftrace_graph_hash = EMPTY_HASH;
>  struct ftrace_hash *ftrace_graph_notrace_hash = EMPTY_HASH;
>
>  enum graph_filter_type {
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 63bf60f793987..97dad33260208 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -950,22 +950,25 @@ extern void __trace_graph_return(struct trace_array *tr,
>                                  unsigned long flags, int pc);
>
>  #ifdef CONFIG_DYNAMIC_FTRACE
> -extern struct ftrace_hash *ftrace_graph_hash;
> +extern struct ftrace_hash __rcu *ftrace_graph_hash;
>  extern struct ftrace_hash *ftrace_graph_notrace_hash;
>
>  static inline int ftrace_graph_addr(struct ftrace_graph_ent *trace)
>  {
>         unsigned long addr = trace->func;
>         int ret = 0;
> +       struct ftrace_hash *hash;
>
>         preempt_disable_notrace();
>
> -       if (ftrace_hash_empty(ftrace_graph_hash)) {
> +       hash = rcu_dereference_protected(ftrace_graph_hash, !preemptible());
> +
> +       if (ftrace_hash_empty(hash)) {
>                 ret = 1;
>                 goto out;
>         }
>
> -       if (ftrace_lookup_ip(ftrace_graph_hash, addr)) {
> +       if (ftrace_lookup_ip(hash, addr)) {
>
>                 /*
>                  * This needs to be cleared on the return functions
> --
> 2.20.1
>
>
>
