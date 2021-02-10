Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3AEA315F86
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 07:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbhBJGej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 01:34:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbhBJGef (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 01:34:35 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F8FC061574;
        Tue,  9 Feb 2021 22:33:54 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id d2so573832pjs.4;
        Tue, 09 Feb 2021 22:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IgfJFLW1z3gVepYjmhnQ4mZUHtKbQsPBUsYEXTNmLYY=;
        b=S4R8vtRxt1u/T8R6CF5zagqoMYBD9y9ejUwMrI5K+DlyGSbKOHi6wT64gPbGUSwLkX
         hlkwlcN/kdpCCPhzocImdzQXR7+Zo35Rmdqa3o95DJ76DFnFT+GISHa+ce8DsmUEwDUj
         2FozhpC6CvJqrLeML12gZ9Gqc3VDoQ1POY/VCDbeUqfKGxLWR84rrg0QjyfGKoufG8OW
         9SN97LWHGPT+dbRoYcbsW+bcGi4EO8ku6SwIzhdDWgIdYQTqM10IGRW814t942ElJIfI
         6CzwC6TJQFUbAKlD9SWt7/I7rBhBkdu70BUwt6Agq7MstzLmT2Fpz8IymDSWsQaxqFVm
         G8hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IgfJFLW1z3gVepYjmhnQ4mZUHtKbQsPBUsYEXTNmLYY=;
        b=EDaAjcMZo1KnwU0CNOXL3TiZFyam+ywwhRC+aW2MyqoIv/2OFV0dvPibh8yIg9U4SL
         GxvPOmwbNqbvpS4VjFA3NxcV29gBEZAHg8Qvd84C0owIfptL46A1n5DDYJU0fRa6MtR1
         vIJ87Dh3GM3bxDW8o3HkH6zTu4+L5YTiDwvyY6AmzZM7e2HBUzK69pHIA4FxAf4mticq
         z0ELL/5Rr8Kjvg3Ucs9UJPFpQ1jwQdBBjMdo4MA9e7CeGMQxyfMjOqL+17PZDP68c1dz
         TEh6t/BZUVzUayc34vZOVnLCkmysEMThfLwYv9jLWX1zgXybFE7SmAJcZtQEIClGO/df
         vj8A==
X-Gm-Message-State: AOAM530r0LemGsxlldwRnUEIVRAQwyrlTYy/RZ/2xq+zQIbxQMDerd80
        qcFcxvSP75XbAA6sxLukDKw+w6b4za46rg==
X-Google-Smtp-Source: ABdhPJxxA4QoyVcc435f7Ljs/HZo0zZz0RwIIR/6k4cG0fKnZTaDLGa3NA1TipjoC/VgBv+SS5XVAQ==
X-Received: by 2002:a17:90a:470b:: with SMTP id h11mr1677204pjg.186.1612938834051;
        Tue, 09 Feb 2021 22:33:54 -0800 (PST)
Received: from localhost ([2409:10:2e40:5100:6e29:95ff:fe2d:8f34])
        by smtp.gmail.com with ESMTPSA id q1sm1044688pgr.58.2021.02.09.22.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 22:33:53 -0800 (PST)
Date:   Wed, 10 Feb 2021 15:33:51 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     pmladek@suse.com, sergey.senozhatsky@gmail.com,
        rostedt@goodmis.org, john.ogness@linutronix.de,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] printk: fix deadlock when kernel panic
Message-ID: <YCN+T5X7/uzv2n0c@jagdpanzerIV.localdomain>
References: <20210210034823.64867-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210034823.64867-1-songmuchun@bytedance.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On (21/02/10 11:48), Muchun Song wrote:
> printk_safe_flush_on_panic() caused the following deadlock on our
> server:
> 
> CPU0:                                         CPU1:
> panic                                         rcu_dump_cpu_stacks
>   kdump_nmi_shootdown_cpus                      nmi_trigger_cpumask_backtrace
>     register_nmi_handler(crash_nmi_callback)      printk_safe_flush
>                                                     __printk_safe_flush
>                                                       raw_spin_lock_irqsave(&read_lock)
>     // send NMI to other processors
>     apic_send_IPI_allbutself(NMI_VECTOR)
>                                                         // NMI interrupt, dead loop
>                                                         crash_nmi_callback
>   printk_safe_flush_on_panic
>     printk_safe_flush
>       __printk_safe_flush
>         // deadlock
>         raw_spin_lock_irqsave(&read_lock)
> 
> DEADLOCK: read_lock is taken on CPU1 and will never get released.
> 
> It happens when panic() stops a CPU by NMI while it has been in
> the middle of printk_safe_flush().
> 
> Handle the lock the same way as logbuf_lock. The printk_safe buffers
> are flushed only when both locks can be safely taken. It can avoid
> the deadlock _in this particular case_ at expense of losing contents
> of printk_safe buffers.
> 
> Note: It would actually be safe to re-init the locks when all CPUs were
>       stopped by NMI. But it would require passing this information
>       from arch-specific code. It is not worth the complexity.
>       Especially because logbuf_lock and printk_safe buffers have been
>       obsoleted by the lockless ring buffer.
> 
> Fixes: cf9b1106c81c ("printk/nmi: flush NMI messages on the system panic")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> Cc: <stable@vger.kernel.org>

Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

	-ss
