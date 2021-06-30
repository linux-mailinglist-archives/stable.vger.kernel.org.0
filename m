Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF363B8737
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 18:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbhF3QqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 12:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbhF3QqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 12:46:06 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BAA7C061756
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 09:43:36 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id g12so1919510qtb.2
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 09:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yVhBRrxZGR0rxMAiS7qzHWYBEjqBj6TxYGbAvGiianQ=;
        b=Zwbh/GOuxgAyqQQA57R/g81JXbZJ3RDtENMuCZEFLPtPQDN4vNoQ0n/o/q1apUKoSr
         n/QkGn1dXmVrF9iCfC1cpeefxaWaDTzPKCnzaJA89iA8YdDRHGymfnJS/n5ai7q3QV6O
         LyQprb0Qjh3gmtI2RJb5TwpbDNkBNTSRPGISm8xCkOZD8gSpf+aBm0KhLLkjZAeEVL2/
         fNefn8O2UgWWsTrdC8a09S9kEpATJi2uZpiHPIyC7DPx033pt+I/iFnRaX+4nea8Z5Dj
         U2W7GhZyYrKc6ki4fj/HzVzIfW6/NG8ZXFCBfgwwdBmFUHYqpBm/MRHyA2G7GluDDe6n
         o5OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yVhBRrxZGR0rxMAiS7qzHWYBEjqBj6TxYGbAvGiianQ=;
        b=rVdlJ+UCBrE8boxWe/hLXVdMdnW6CeQQi9wKa6qveOjqfEAjxybIn968j4T/Ac1FY2
         NLMLqP+SHMuVLbCF0Gp67+FF/xSdb116Yfs0vDLeAzMXeOLOhEkxEj8XnGWbfWsh7fgz
         bpZ9mD8MOjB8diDEqE+8ag2JBNG51uaQbI9dFcAI0SHjGNKeHjvRoNEubcQY3kZWpzDI
         PZs61UNki39eiuupHNnAjeCH03DX6tl6mhps802sSDeNUxHQ+rcX9tsMK2+xk4YBK2Do
         oVIlm599DEkFgb9UatPVHBhgnMKt0EkuaMHOR/LDebZhVXDiHs/r+0K+bpmkFKvbuTPz
         Smfw==
X-Gm-Message-State: AOAM533C4B1mvnjHWKn6lsrjdSihaD+5CFdngwikeF6ulki0Iy7FaPfO
        zRNPc+BpojCPesRPlaiiwmJAi/cvIpJddvXTcUkTXQ==
X-Google-Smtp-Source: ABdhPJwV1ZJ6tlrMieNC0OGsVefccE4/fU15zdFZa4cZth0gdhsAsZouQDAWzUL+D29Yg5OTVdi2bwORYcDlRQej4ks=
X-Received: by 2002:ac8:4798:: with SMTP id k24mr16802368qtq.258.1625071415069;
 Wed, 30 Jun 2021 09:43:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210630003406.4013668-1-paulburton@google.com> <20210630083146.7514cb1f@oasis.local.home>
In-Reply-To: <20210630083146.7514cb1f@oasis.local.home>
From:   Joel Fernandes <joelaf@google.com>
Date:   Wed, 30 Jun 2021 12:43:24 -0400
Message-ID: <CAJWu+oofNcZtg+EAduKzp=yFe5+AYNogvr-V0q3NWyLA_QCRJw@mail.gmail.com>
Subject: Re: [PATCH 1/2] tracing: Simplify & fix saved_tgids logic
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Paul Burton <paulburton@google.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 30, 2021 at 8:31 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 29 Jun 2021 17:34:05 -0700
> Paul Burton <paulburton@google.com> wrote:
>
> > The tgid_map array records a mapping from pid to tgid, where the index
> > of an entry within the array is the pid & the value stored at that index
> > is the tgid.
> >
> > The saved_tgids_next() function iterates over pointers into the tgid_map
> > array & dereferences the pointers which results in the tgid, but then it
> > passes that dereferenced value to trace_find_tgid() which treats it as a
> > pid & does a further lookup within the tgid_map array. It seems likely
> > that the intent here was to skip over entries in tgid_map for which the
> > recorded tgid is zero, but instead we end up skipping over entries for
> > which the thread group leader hasn't yet had its own tgid recorded in
> > tgid_map.
> >
> > A minimal fix would be to remove the call to trace_find_tgid, turning:
> >
> >   if (trace_find_tgid(*ptr))
> >
> > into:
> >
> >   if (*ptr)
> >
> > ..but it seems like this logic can be much simpler if we simply let
> > seq_read() iterate over the whole tgid_map array & filter out empty
> > entries by returning SEQ_SKIP from saved_tgids_show(). Here we take that
> > approach, removing the incorrect logic here entirely.
> >
> > Signed-off-by: Paul Burton <paulburton@google.com>
> > Fixes: d914ba37d714 ("tracing: Add support for recording tgid of tasks")
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Joel Fernandes <joelaf@google.com>
> > Cc: <stable@vger.kernel.org>
> > ---
>
> Joel,
>
> Can you review this please.

Sure thing Steve, will review it today.

thanks,
-Joel
