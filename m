Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE1657FE81
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 13:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbiGYLlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 07:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiGYLlq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 07:41:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA559AE49;
        Mon, 25 Jul 2022 04:41:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9ED02CE1197;
        Mon, 25 Jul 2022 11:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65907C341CE;
        Mon, 25 Jul 2022 11:41:39 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="OX8iP9XF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658749296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=snNmtNpAD+4T2xYJlTy16N746DVx+7vAQcSlY0eqPQ4=;
        b=OX8iP9XFveAlJues0PzDBzCSpGKd5MZFA3ggJ4bIMbv5qRjzfCdMDRiAxHV2J5Rl4PMPWg
        hyQqdi2I816VJViagjOPOg9sXOBjKupEtZ9Wp0xhVeq+3DpgxcK3wcrVbQZvCgWyyHYEcb
        hvDhqxvlMk7SGSCRIlG68fivrzJLoMo=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a5eb5f0c (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 25 Jul 2022 11:41:36 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id d124so2105484ybb.5;
        Mon, 25 Jul 2022 04:41:36 -0700 (PDT)
X-Gm-Message-State: AJIora+b71Bbq5sKdJVr6xGFP8ewT1sGAe9JBSizN0cxYtmOQv1s1Fm1
        hjv2/5GMJPZD7QNMLfERpBCltq6CZb7j9ZZumII=
X-Google-Smtp-Source: AGRyM1uEWMaeH2vYM13zJOE12Ad5anczdXVRTirNiVZun7WozkUU416pIzL0vNTGDpg+YFrRsXbp0oPPFl+U9IsqWsY=
X-Received: by 2002:a25:cf16:0:b0:671:60e5:e9e2 with SMTP id
 f22-20020a25cf16000000b0067160e5e9e2mr496508ybg.231.1658749294667; Mon, 25
 Jul 2022 04:41:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9qrd25vfRYYvCWtPg+wVC5joEzzJiihCN+L4rqMfTL4Rg@mail.gmail.com>
 <20220719201108.264322-1-Jason@zx2c4.com> <xhsmhfsisgbam.mognet@vschneid.remote.csb>
 <CAHmME9pEvr_F2C9cG4qNSCc91a7YAAquW7Jqczcgn2fr_vA4Ow@mail.gmail.com> <xhsmhbktdfqrp.mognet@vschneid.remote.csb>
In-Reply-To: <xhsmhbktdfqrp.mognet@vschneid.remote.csb>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 25 Jul 2022 13:41:23 +0200
X-Gmail-Original-Message-ID: <CAHmME9rp0kCLKvXWfmRHi=p2PLYRszqQqQWZLHyofJ=9xZCtMA@mail.gmail.com>
Message-ID: <CAHmME9rp0kCLKvXWfmRHi=p2PLYRszqQqQWZLHyofJ=9xZCtMA@mail.gmail.com>
Subject: Re: [PATCH v10] ath9k: let sleep be interrupted when unregistering hwrng
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        stable <stable@vger.kernel.org>,
        Gregory Erwin <gregerwin256@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Valentin,

On Mon, Jul 25, 2022 at 12:09 PM Valentin Schneider <vschneid@redhat.com> wrote:
> > maybe at some point I'll look into overhauling all of this so that
> > none of this will be required anyway. So I think v10 is my final
> > submission on this.
>
> I think that's fair, I hope I didn't discourage you too much from
> contributing in that area.

While not strictly necessary because of Eric's ack, since you continue
to grow this thread that addresses an active bug people are suffering
from, it might be some very useful signaling if you too would provide
your Acked-by, so that Kalle picks this up and people's laptops work
again.

>
> Just to make sure I'm on the same page as you - is your patch solely for
> ath9k, or is it supposed to fix other drivers?

The intent here is ath9k, but in the process it of course fixes other
things too, and I'm quite pleased with the multiple-birds-one-stone
consequence.

> So if ath9k is widely used / a problem for lots of folks, we could just fix
> that one and leave the others TBD. What do you think?

No, that kind of band aid doesn't really sit well, especially as
you've proposed struct changes inside hwrng. I'm not going to do that.

As mentioned, v10 is my final submission here. If you'd like to Ack
it, please go ahead. If not, and if as a consequence Kalle doesn't
pick up the patch, perhaps you'll develop this yourself moving forward
and you'll also fix the longstanding problems with hwrng so that I
don't have to. In case it's not clear to you: I'm no longer interested
in any aspect of this discussion, I find the current patch
satisfactory of numerous goals, and I would appreciate this whole
thing being over. I am no longer available to work further on this
patch.

Thanks,
Jason
