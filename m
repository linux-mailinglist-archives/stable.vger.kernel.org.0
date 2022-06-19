Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB89550CEC
	for <lists+stable@lfdr.de>; Sun, 19 Jun 2022 22:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbiFSUc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jun 2022 16:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiFSUcZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jun 2022 16:32:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7F3BCD;
        Sun, 19 Jun 2022 13:32:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F12EDB80BA9;
        Sun, 19 Jun 2022 20:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366BCC34114;
        Sun, 19 Jun 2022 20:32:21 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="GqC6I5Te"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1655670738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E43yYKQ93Nj8ZBsO2wdXwId/ptjpjzHFd5icsbHgVck=;
        b=GqC6I5TerNfh9l2Mcco256Fmef6HflorZBDQ0NDeoojcq/i8GEPcoS17TNYd8LL4kkFkzf
        slNAYwQY65wwc87Bo4QEkItaLLXchOLYKbatW4DhYm7Pgf7V5QpaqVZBRBQBdwYknSDYMa
        HCM2mSVrkR2dXiW7PMnwjZ5HaAN6mJ8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4987202e (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sun, 19 Jun 2022 20:32:18 +0000 (UTC)
Received: by mail-yb1-f182.google.com with SMTP id 23so15721938ybe.8;
        Sun, 19 Jun 2022 13:32:18 -0700 (PDT)
X-Gm-Message-State: AJIora/altS9MnBUhy/sTxD1kVibwQQktDhbDIViVtCOHrFf5FTCEqi5
        pFa2rRA7KY9hTWUCJF5KySukIUy+4ws5ozeXHRI=
X-Google-Smtp-Source: AGRyM1tZ32bZ28frjHDR0YYsFFJW4/YL3Si9ca7cVn+cWmRP8nzQzoDRZHpvCijN6G+esDqpLb1Q0ccATdsA4PgL8nU=
X-Received: by 2002:a5b:dcf:0:b0:64a:6923:bbba with SMTP id
 t15-20020a5b0dcf000000b0064a6923bbbamr22761168ybr.398.1655670737153; Sun, 19
 Jun 2022 13:32:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220611151015.548325-1-Jason@zx2c4.com> <20220611151015.548325-3-Jason@zx2c4.com>
 <87czf4c1q1.fsf@mpe.ellerman.id.au>
In-Reply-To: <87czf4c1q1.fsf@mpe.ellerman.id.au>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sun, 19 Jun 2022 22:32:06 +0200
X-Gmail-Original-Message-ID: <CAHmME9rWkvDDYHPi-TJR-ATts6pLPY6D8LUaYDJ-=7w7qsFCvg@mail.gmail.com>
Message-ID: <CAHmME9rWkvDDYHPi-TJR-ATts6pLPY6D8LUaYDJ-=7w7qsFCvg@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] powerpc/powernv: wire up rng during setup_arch
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
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

Hi Michael,

On Sun, Jun 19, 2022 at 1:49 PM Michael Ellerman <mpe@ellerman.id.au> wrote:
> This crashes on power8 because it's too early to call kzalloc() in
> rng_create(), and it's also too early to setup the percpu variables in
> there.
>
> I'll rework it and post a v4.

Oh, darn. Sorry about that. Thanks for reworking it.

Jason
