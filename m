Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD3253F949
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 11:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239158AbiFGJQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 05:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239198AbiFGJQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 05:16:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD1DDFF79;
        Tue,  7 Jun 2022 02:16:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6103AB81E09;
        Tue,  7 Jun 2022 09:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB17C3411F;
        Tue,  7 Jun 2022 09:16:28 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="DnYxqIuP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654593386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8JxrXr9JI6SCO4Edcm5jD4dlFLfy78aly9kboFioEZ8=;
        b=DnYxqIuP+4rADUna88H7IsDE+r7H2bsdZDRsM69bEjDnYNgfvMuSeeZ+SfrhmEPKz5kiLo
        LKHcKm4NVfYGzNv4wjT2xKdWZcktNpmwx5o2bCOG+rr42LHUKAoP8140Tp1T29YIxVUpo+
        klXZhlzflwr4w7GJlvTZo5KS+i3qAeo=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e5e86f92 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 7 Jun 2022 09:16:25 +0000 (UTC)
Received: by mail-yb1-f175.google.com with SMTP id l204so30083034ybf.10;
        Tue, 07 Jun 2022 02:16:25 -0700 (PDT)
X-Gm-Message-State: AOAM532sLhpa8hzfpnIWReOikSfeGwyRefxIOvv4G7wB1zRMnTfuco73
        1D56W/B7c/SRQ8yTv2SVredz151Ii1WAmPV3mFo=
X-Google-Smtp-Source: ABdhPJyNWSzlwWjTxvo6G7qJuMtryN7Cm9X99MgTvRBPUejF+9jh9gfuzlcoYwg8GImZLDhzOr1cNA4BOcayZFhTCJs=
X-Received: by 2002:a5b:dcf:0:b0:64a:6923:bbba with SMTP id
 t15-20020a5b0dcf000000b0064a6923bbbamr30583298ybr.398.1654593384225; Tue, 07
 Jun 2022 02:16:24 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7110:6407:b0:181:6914:78f6 with HTTP; Tue, 7 Jun 2022
 02:16:23 -0700 (PDT)
In-Reply-To: <Yp8W68o37X6aAD86@shell.armlinux.org.uk>
References: <8cc7ebe4-442b-a24b-9bb0-fce6e0425ee6@raspberrypi.com>
 <CAHmME9pL=g7Gz9-QOHnTosLHAL9YSPsW+CnE=9=u3iTQaFzomg@mail.gmail.com> <Yp8W68o37X6aAD86@shell.armlinux.org.uk>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 7 Jun 2022 11:16:23 +0200
X-Gmail-Original-Message-ID: <CAHmME9r21wP324DCbBSZWd+mFR+=4M4pjgkJ83HdbhZ=prJdpg@mail.gmail.com>
Message-ID: <CAHmME9r21wP324DCbBSZWd+mFR+=4M4pjgkJ83HdbhZ=prJdpg@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: initialize jump labels before setup_machine_fdt()
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Phil Elwell <phil@raspberrypi.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        stable <stable@vger.kernel.org>
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

On 6/7/22, Russell King (Oracle) <linux@armlinux.org.uk> wrote:
> On Tue, Jun 07, 2022 at 10:30:49AM +0200, Jason A. Donenfeld wrote:
>> Hi Phil,
>>
>> Thanks for testing this. Can you let me know if v1 of this works?
>>
>> https://lore.kernel.org/lkml/20220602212234.344394-1-Jason@zx2c4.com/
>>
>> (I'll also fashion a revert for this part of stable.)
>
> As the arm32 version hasn't been merged yet, how is it in stable already?
> If it is in stable, isn't that a yet another violation of the stable
> kernel rules?

You misunderstood my ambiguous sentence, sorry. I meant a revert of
the thing in stable that makes this discussion here a stable
discussion rather than a 5.19 discussion. No arm32 stuff has been
committed anywhere.

Jason
