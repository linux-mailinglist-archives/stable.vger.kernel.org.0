Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810052FADA8
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 00:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732760AbhARXGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 18:06:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731471AbhARXGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 18:06:52 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06657C061573
        for <stable@vger.kernel.org>; Mon, 18 Jan 2021 15:05:56 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id n2so18813415iom.7
        for <stable@vger.kernel.org>; Mon, 18 Jan 2021 15:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RNIIO1LfDdwmZD1fpi7N0jsea/5vNdEYtpT955Q+IpQ=;
        b=drSj6qv33myxlpEiC4qESl9upkPKuqyqoxsYjouA8LnGBOHrGhGDU+yzUWoYIBQ/EW
         Vw+PqDmhRrmMKbKD3NJjC2s4mCufYAvRkg10iCDjyl3DO67xFh8I0MQmIKVwvUV0UtyY
         Zgmmhlmak5KGcPDpP2EdVG6kqOH3ZpvPKzfU8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RNIIO1LfDdwmZD1fpi7N0jsea/5vNdEYtpT955Q+IpQ=;
        b=oZGd+CtJ12zycgvrQAAhwOu8Mkvw70X9EofFpNvSe0qbsJtGgpA8ETtaPqqLQTYaYl
         /5dd68xsCtotnyn3VUe/tUTsr6a0nkX/MLYwNkIvAfgNzwBCyceU7dwBx63gkz4eXHe8
         ugYPB5l+Qk64AA9BvOsWkF1TnO1XpwwwPAWamPlxv8aWobQjAxrTMZZFH2myruyjnpnA
         gY0oanjOWtBRjf0nM+cuhi32KNixJz59JlwXmoDklzR1x+OW/ndIC0uePO57PFuVh9o2
         E3byM0m/3rS7pm4RyTTy61ztlW6UKJGOIGfPEAP0W0Lg5bqFtMh4NZnlloGnYnJN8QTJ
         o46g==
X-Gm-Message-State: AOAM530i7ehBDzdDAs+VlwYupj4sVZSjtyW6/Kn20Y7TLJp0/to7J6GD
        U23nAwk0afIdBQBy5ClJvwh+8Lxqci94l1aVwYn5VQ==
X-Google-Smtp-Source: ABdhPJx+V+g6QeIGwWzhUdTaPINJzXCGW92jisLbX/hE/5EDswUqplRLtM3WDdR0ifVTp3lT68KVhon1u/BDqH8YlZM=
X-Received: by 2002:a05:6e02:1be6:: with SMTP id y6mr1071625ilv.145.1611011156183;
 Mon, 18 Jan 2021 15:05:56 -0800 (PST)
MIME-Version: 1.0
References: <20210118113352.764293297@linuxfoundation.org> <20210118113354.944646657@linuxfoundation.org>
 <20210118224431.GA26685@amd>
In-Reply-To: <20210118224431.GA26685@amd>
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Mon, 18 Jan 2021 23:05:45 +0000
Message-ID: <CALrw=nEgtxS_SDOP5+T0u6XZ74Hcr451L_d5QdUwDHi7ZaLQ6w@mail.gmail.com>
Subject: Re: [PATCH 5.10 045/152] dm crypt: use GFP_ATOMIC when allocating
 crypto requests from softirq
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 18, 2021 at 10:44 PM Pavel Machek <pavel@denx.de> wrote:
>
>
> > Fix this by allocating crypto requests with GFP_ATOMIC mask in
> > interrupt context.
> ...
>
> This one is wrong.
>
>
> > +++ b/drivers/md/dm-crypt.c
> > @@ -1454,13 +1454,16 @@ static int crypt_convert_block_skcipher(
> > -     if (!ctx->r.req)
> > -             ctx->r.req = mempool_alloc(&cc->req_pool, GFP_NOIO);
> > +     if (!ctx->r.req) {
> > +             ctx->r.req = mempool_alloc(&cc->req_pool, in_interrupt() ? GFP_ATOMIC : GFP_NOIO);
>
> Good so far. Ugly but good.
>
> > -static void crypt_alloc_req_aead(struct crypt_config *cc,
> > +static int crypt_alloc_req_aead(struct crypt_config *cc,
> >                                struct convert_context *ctx)
> >  {
> > -     if (!ctx->r.req_aead)
> > -             ctx->r.req_aead = mempool_alloc(&cc->req_pool, GFP_NOIO);
> > +     if (!ctx->r.req) {
> > +             ctx->r.req = mempool_alloc(&cc->req_pool, in_interrupt() ? GFP_ATOMIC : GFP_NOIO);
> > +             if (!ctx->r.req)
> > +                     return -ENOMEM;
> > +     }
>
> But this one can't be good. We are now allocating different field in
> the structure!

Good catch! Sorry for the copy-paste. It is actually not a big deal,
because this is not a structure, but a union:
as long as the mempool was initialized with the correct size, it
should be no different.

Nevertheless, I'll send the patch to fix the typo.

Regards,
Ignat

>                                                                 Pavel
>
> --
> DENX Software Engineering GmbH,      Managing Director:    Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194    Groebenzell, Germany
>
