Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C2F4F3F0E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 22:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240170AbiDEOgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 10:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389337AbiDENdo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 09:33:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD24E9C90;
        Tue,  5 Apr 2022 05:39:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9201461802;
        Tue,  5 Apr 2022 12:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF7CC385A1;
        Tue,  5 Apr 2022 12:39:03 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="fOURhmSn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1649162341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0yCGiJPMEhyBglrpRDw/N/UymMsKw6+o4Dn9AYLm1Ro=;
        b=fOURhmSnfUqQ2UY50KIdC6WuOwRLuZqE9uXVqWrjYHBRr8HiCCMOU9c9DcrdYfLwCQzyS/
        SZvvF3eZb9hicxAy7rAHVJfETHUqXB3lXlm3BmenBkuHQ8ERGe09vte7nIlWW7ubllM5OI
        33yPc34rjyWRXeVUtg0ZGNUh/OFrJYI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1dcef730 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 5 Apr 2022 12:39:00 +0000 (UTC)
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-2eb3db5b172so88079487b3.6;
        Tue, 05 Apr 2022 05:39:00 -0700 (PDT)
X-Gm-Message-State: AOAM5316UDXjtr/8t1BkyZgEYtDDP4WD1ooheA6+jsY68aIcW23ndFag
        h2KbXp9qnFSHHGeEfjQyEJkJsGuOS60XqwDiTJE=
X-Google-Smtp-Source: ABdhPJzReerSJeFzBuDuWWB1BCduZovdDNRtUnzeD2HQItFoRgMyYRs0aj5KZJPM4aTyTVvYuF2w5uZ+AhZe+1/Abok=
X-Received: by 2002:a0d:e607:0:b0:2eb:87de:2cc4 with SMTP id
 p7-20020a0de607000000b002eb87de2cc4mr2392483ywe.485.1649162339400; Tue, 05
 Apr 2022 05:38:59 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7110:470c:b0:173:a80b:3ec5 with HTTP; Tue, 5 Apr 2022
 05:38:58 -0700 (PDT)
In-Reply-To: <202204041953.D7E0BA15@keescook>
References: <CAHmME9otYi4pCzZwSGnK40dp1QMRVPxp+DBysVuLXUKkXinAxg@mail.gmail.com>
 <20220403204036.1269562-1-Jason@zx2c4.com> <202204041144.96FC64A8@keescook>
 <Ykt1cj0wPKEsHL2q@zx2c4.com> <202204041953.D7E0BA15@keescook>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 5 Apr 2022 14:38:58 +0200
X-Gmail-Original-Message-ID: <CAHmME9rC-pmi3K=w06-bOsHP5=tPv9CS51hr69P1C5tmvHf_mA@mail.gmail.com>
Message-ID: <CAHmME9rC-pmi3K=w06-bOsHP5=tPv9CS51hr69P1C5tmvHf_mA@mail.gmail.com>
Subject: Re: [PATCH v2] gcc-plugins: latent_entropy: use /dev/urandom
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, PaX Team <pageexec@freemail.hu>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Kees,

On 4/5/22, Kees Cook <keescook@chromium.org> wrote:
> On Tue, Apr 05, 2022 at 12:47:14AM +0200, Jason A. Donenfeld wrote:
>> On Mon, Apr 4, 2022 at 8:49 PM Kees Cook <keescook@chromium.org> wrote:
>> > This mixes two changes: the pRNG change and the "use urandom if
>> > non-deterministic" change. I think these should be split, so the pRNG
>> > change can be explicitly justified.
>>
>> Alright, I'll split those. Or, more probably, just drop the xorshift
>> thing. There's not actually a strong reason for preferring xorshift. I
>> did it because it produces more uniformity and is faster to compute and
>> all that. But none of that stuff actually matters here. It was just a
>> sort of "well I'm at it..." thing.
>
> Well, it's nice to have and you already wrote it, so seems a waste to
> just drop it. :)
>
>> > >  static struct plugin_info latent_entropy_plugin_info = {
>> > > -     .version        = "201606141920vanilla",
>> > > +     .version        = "202203311920vanilla",
>> >
>> > This doesn't really need to be versioned. We can change this to just
>> > "vanilla", IMO.
>>
>> Okay. I suppose you want it to be in a different patch too, right? In
>> which case I'll leave it out and maybe get to it later. (I suppose one
>> probably needs to double check whether it's used for anything
>> interesting like dwarf debug info or whatever, where maybe it's
>> helpful?)
>
> Hm, I don't think it shows up anywhere, but you can just drop the hunk
> that touch it. I can remove them all with a separate patch later.
>

Okay. That's what I did here
https://lore.kernel.org/lkml/20220404230709.124508-1-Jason@zx2c4.com/
so awaiting your merge. (I still find all aspects of v2 more
preferable for a variety of weak reasons in case you'd like to merge
that instead, but v3 is available now.)

Jason
