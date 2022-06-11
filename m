Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9935475B0
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 16:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235409AbiFKOmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 10:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232546AbiFKOmR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 10:42:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55994131;
        Sat, 11 Jun 2022 07:42:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0B57B80011;
        Sat, 11 Jun 2022 14:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103C8C34116;
        Sat, 11 Jun 2022 14:42:12 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="UYGc4j1X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654958531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8XsNMWveW3v/x7u53JLf6fWX09OODXTZVKXlrKRTL14=;
        b=UYGc4j1XtVbnfMAK8TlhjwymMtlm3YyWpDoYXyQAPx+cPR4oMwNUH/paGfI9Y+BgIFJcHL
        OlwbNsY62b4rt/dQXG3Ce6oMhpllwgWqMKQgced44BrI6OL9/zS0iNmBM/OkwnsIDpcvrh
        bv4HTdbxdhrnRrGsPQzbYVEqWAbYl6k=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 680a44aa (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sat, 11 Jun 2022 14:42:11 +0000 (UTC)
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-3137c877092so15253577b3.13;
        Sat, 11 Jun 2022 07:42:11 -0700 (PDT)
X-Gm-Message-State: AOAM533u1/lZfkg5kKXwGDi+Yz+t9li9jMNW45IBjgMVDZuVOxpeoGRj
        DC6sT5HaPFXBiO/sQMCcKeahKZKuxMiXJ2NK0X0=
X-Google-Smtp-Source: ABdhPJz5kaNE/RndD3vlkyWhsQWFUFJLFK6/QX+q18w97fqoUN3lzUnNNL3H1bfOVfbyaz0Hi7XlJxODgyofj4hOQZQ=
X-Received: by 2002:a81:7d09:0:b0:313:fb25:9104 with SMTP id
 y9-20020a817d09000000b00313fb259104mr2170770ywc.2.1654958530119; Sat, 11 Jun
 2022 07:42:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220611100447.5066-1-Jason@zx2c4.com> <20220611100447.5066-2-Jason@zx2c4.com>
 <6432586f-9eb9-ac71-7934-c48da09a928e@csgroup.eu>
In-Reply-To: <6432586f-9eb9-ac71-7934-c48da09a928e@csgroup.eu>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sat, 11 Jun 2022 16:41:58 +0200
X-Gmail-Original-Message-ID: <CAHmME9rBWcdZtJCQ1WZAPOJtnA6u4w0ub4s4M+UW60gMSNgWrQ@mail.gmail.com>
Message-ID: <CAHmME9rBWcdZtJCQ1WZAPOJtnA6u4w0ub4s4M+UW60gMSNgWrQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] powerpc/microwatt: wire up rng during setup_arch
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
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

Hi Christophe,

On Sat, Jun 11, 2022 at 4:40 PM Christophe Leroy
<christophe.leroy@csgroup.eu> wrote:
> >
> > +__init void microwatt_rng_init(void);
>
> This prototype should be declared in a header file, for instance asm/setup.h

Alright.

> And I think the __init keyword usually goes after the type, so should be
> 'void __init'.

Indeed I thought so too. It just wasn't like this before, but that
doesn't mean I shouldn't fix it.

v3 coming right up.

Jason
