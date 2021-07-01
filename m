Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8533B95F0
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 20:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbhGASKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 14:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbhGASKE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 14:10:04 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99103C061764
        for <stable@vger.kernel.org>; Thu,  1 Jul 2021 11:07:33 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id g14so3413804qvo.7
        for <stable@vger.kernel.org>; Thu, 01 Jul 2021 11:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NVSKoBt2z1qak8JlO8036fYKzXIM1f92CLbSFQ7Q3dA=;
        b=pE23NV1bx3tkqEhyGqVwhLzlSXgUawfHfhffIcx9gPigYmAqKOyOjtJrHf4IVRn/6C
         Os5t574z0ShM1THpTWuB1qF8pJ5CW6dnPVjsCnjsUI69t1/WB2zZQAtWMTIVtYpyuuRd
         HOy5EzLep5UP43j5zxCgQ6SZU9jHII9/9EL1bqbWzkJSa4BsvcS8Bi3j5vClIxoqDXbq
         NbRBydVt3TgIv6iZZrFk6ifqAZucC1gNhXSeAVs0xaai+7SINFEKKKWlhiCjm26hTKuu
         QLNXb4kI1jw4c/i3p+MLkRxT4f9uQ3L4NGJUsIa9bLtVhqh1pEjwGOcvvsTEovM0guNx
         Umpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NVSKoBt2z1qak8JlO8036fYKzXIM1f92CLbSFQ7Q3dA=;
        b=YTV/1FdeiLUjKgqu7K029iOFfWe+luCR26XWS7jqXTYb6IzPeaSGphSRr1bDnbt5RY
         MzAVnaP/VgMoE7XCpqwCqj9V21EjErHhYq/BnELiqrmvQ0+yxEUY1cyfLnQPWpBKZirc
         WWzKhz7BubcwfaoczNu1BbNW593WYtqFpEorFnNzAeNx70HHGEhIhq/IPjyy+BQwY+2j
         kQS/omf+NopmQ1HqMoqtp76q6R5pJqmgnw3jUTFIbBBzMATujXiN2P40TzzNnxVmNTA7
         lNhTKL4LNzl176vTHRRoM62zZbwQtajlQK2/7b9//sFiXd1sL6i3pipRuTW0pwoS+9dd
         76zg==
X-Gm-Message-State: AOAM5321wzPqaIzgm2T3RE5PQT5OESPbTEUtM6MQkpJiCx0FnnCyrr2p
        bo6tMuzpcHgWeuAh/FHcbXohUhm2zpA2TjU7A1RsAw==
X-Google-Smtp-Source: ABdhPJzNBChzvPsQQ2LA6oEbgIiRVtSa75l3kUnxIfr0QPhzRz2WoZezHxsJFrH3t6EdtcsXm5/Cvhszfe5jCEV6P+E=
X-Received: by 2002:a0c:ed46:: with SMTP id v6mr1115038qvq.35.1625162852576;
 Thu, 01 Jul 2021 11:07:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210701095525.400839d3@oasis.local.home> <20210701172407.889626-1-paulburton@google.com>
In-Reply-To: <20210701172407.889626-1-paulburton@google.com>
From:   Joel Fernandes <joelaf@google.com>
Date:   Thu, 1 Jul 2021 14:07:21 -0400
Message-ID: <CAJWu+oqLVE9aE_=atqbXMx9+uz1NB3M+SxOg6vjOTirS0HA1Pg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] tracing: Simplify & fix saved_tgids logic
To:     Paul Burton <paulburton@google.com>
Cc:     linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 1, 2021 at 1:24 PM Paul Burton <paulburton@google.com> wrote:
>
> The tgid_map array records a mapping from pid to tgid, where the index
> of an entry within the array is the pid & the value stored at that index
> is the tgid.
>
> The saved_tgids_next() function iterates over pointers into the tgid_map
> array & dereferences the pointers which results in the tgid, but then it
> passes that dereferenced value to trace_find_tgid() which treats it as a
> pid & does a further lookup within the tgid_map array. It seems likely
> that the intent here was to skip over entries in tgid_map for which the
> recorded tgid is zero, but instead we end up skipping over entries for
> which the thread group leader hasn't yet had its own tgid recorded in
> tgid_map.
>
> A minimal fix would be to remove the call to trace_find_tgid, turning:
>
>   if (trace_find_tgid(*ptr))
>
> into:
>
>   if (*ptr)
>
> ..but it seems like this logic can be much simpler if we simply let
> seq_read() iterate over the whole tgid_map array & filter out empty
> entries by returning SEQ_SKIP from saved_tgids_show(). Here we take that
> approach, removing the incorrect logic here entirely.
>
> Signed-off-by: Paul Burton <paulburton@google.com>
> Fixes: d914ba37d714 ("tracing: Add support for recording tgid of tasks")
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Joel Fernandes <joelaf@google.com>

Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
