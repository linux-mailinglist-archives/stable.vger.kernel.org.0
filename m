Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4F6657E822
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 22:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbiGVUN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 16:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbiGVUN2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 16:13:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7734A9BB3;
        Fri, 22 Jul 2022 13:13:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88D6BB82A1E;
        Fri, 22 Jul 2022 20:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D761FC341C7;
        Fri, 22 Jul 2022 20:13:24 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="GSUj12W7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658520802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cbr6WT7XpEi62xrPCOkJlIx4PWAKKP3fq1AArMiGhbc=;
        b=GSUj12W70DJwjt1BJXyOY5N1UabSgk9H7Orc5/eJs/grd3SKWKvb1TeNn2QyYMcnJUO1kv
        /h3jGhXIVSKkwylb6CvonbaUMFK6ArWpkW9dM4mFkvNVhJjzwoqntsgOPr7d4NH6mbRLhw
        eJaHXMnFSWhnWRyJ+rUaeU7FMN4Wbe4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6d4ec7e3 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 22 Jul 2022 20:13:22 +0000 (UTC)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-31e1ecea074so58646847b3.8;
        Fri, 22 Jul 2022 13:13:22 -0700 (PDT)
X-Gm-Message-State: AJIora8xTShtpi1mr5lLv0pwfYXfScOV7jyKnr0EwykWoZEk2PQzd9oe
        TuS3RVtm9rUNMMuBufn2qXWPhBW8/4UUBx2SePA=
X-Google-Smtp-Source: AGRyM1tAsTcqJARdJbMpL2h5/RIuLnT1DatAsM2esbux1BQJWG2BzIXVeof8GwnFKFVFDXVtSp1s+wTuFMEW54mtGs0=
X-Received: by 2002:a81:ac11:0:b0:31e:5698:323a with SMTP id
 k17-20020a81ac11000000b0031e5698323amr1366450ywh.79.1658520800763; Fri, 22
 Jul 2022 13:13:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9qrd25vfRYYvCWtPg+wVC5joEzzJiihCN+L4rqMfTL4Rg@mail.gmail.com>
 <20220719201108.264322-1-Jason@zx2c4.com> <xhsmhfsisgbam.mognet@vschneid.remote.csb>
In-Reply-To: <xhsmhfsisgbam.mognet@vschneid.remote.csb>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 22 Jul 2022 22:13:09 +0200
X-Gmail-Original-Message-ID: <CAHmME9pEvr_F2C9cG4qNSCc91a7YAAquW7Jqczcgn2fr_vA4Ow@mail.gmail.com>
Message-ID: <CAHmME9pEvr_F2C9cG4qNSCc91a7YAAquW7Jqczcgn2fr_vA4Ow@mail.gmail.com>
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

On Fri, Jul 22, 2022 at 10:09 PM Valentin Schneider <vschneid@redhat.com> wrote:
> I had initially convinced myself this would be somewhat involved, but
> writing the above I thought maybe not... The below is applied on top of
> your v10, would you be able to test whether it actually works?
> It does however mean patching up any sleeping hwrng (a quick search tells
> me there are more, e.g. npcm-rng does readb_poll_timeout())

I'm not able to test this easily, no (I don't own any hardware), and
I'm not going to put in the effort to rewrite/audit every sleeping
hwrng. That's not a good use of time, given the numerous other
problems the framework has (briefly discussed with Eric). Instead,
maybe at some point I'll look into overhauling all of this so that
none of this will be required anyway. So I think v10 is my final
submission on this.

But if you'd like to attempt more comprehensive changes throughout the
tree on all the drivers and do something large, I guess you can do
that independently (since you mentioned your thing works on top of
v10). And this way v10 still exists to fix the actual bug that's
currently reeking havoc. On the other hand, maybe don't bother, and we
can look into fixing the whole rats nest properly in some months when
I'm more motivated to jump into hwrng.

Jason
