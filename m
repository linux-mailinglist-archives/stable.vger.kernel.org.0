Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156EB5475BF
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 16:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbiFKOsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 10:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233353AbiFKOsI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 10:48:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8DF1034;
        Sat, 11 Jun 2022 07:48:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34778B80123;
        Sat, 11 Jun 2022 14:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D32C34116;
        Sat, 11 Jun 2022 14:48:04 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="E+GwPZbQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654958882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fvbZPzkw/avTJd3PDrjqFs2/jjR0Wrowg5/jhXGMgzI=;
        b=E+GwPZbQn5HZkZ/Je4U2iWkYH800EZbWyPVtmRulfQOWzhqY66T7kchVriEcoTHzF5Rrlj
        KN/yWl8n0aCWdUS0NoYAgvpEWV4ep1tefZMlmFIu63U/CS64oDaLESnT7arVBLlS2ndvrT
        sOXIcAr899zw5akiFQw9Zbs/rBHQNm4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c9e06e7c (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sat, 11 Jun 2022 14:48:02 +0000 (UTC)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-30fdbe7467cso15939227b3.1;
        Sat, 11 Jun 2022 07:48:02 -0700 (PDT)
X-Gm-Message-State: AOAM532BM7ny3yDOIrxnjSGvhWCdaUk7veKmvzFdQ0MFfG76Q9nPj+Ds
        ymJ44kzoEQmiT+Cjcj222t9wtiwm65g+loMGINg=
X-Google-Smtp-Source: ABdhPJzzArFp2ddzM7VediG5TtTJ+j9tfjhdRZOJPfFq+eFrP3f9rqrR2Ogp08DsPZj5Pzv3mdiHrltJXT+JUtjiBUs=
X-Received: by 2002:a0d:e28d:0:b0:30c:572b:365c with SMTP id
 l135-20020a0de28d000000b0030c572b365cmr56411692ywe.499.1654958881016; Sat, 11
 Jun 2022 07:48:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220611100447.5066-1-Jason@zx2c4.com> <20220611100447.5066-3-Jason@zx2c4.com>
 <d310a8cf-79f8-89ed-41fd-ebe0281a67f4@csgroup.eu>
In-Reply-To: <d310a8cf-79f8-89ed-41fd-ebe0281a67f4@csgroup.eu>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sat, 11 Jun 2022 16:47:50 +0200
X-Gmail-Original-Message-ID: <CAHmME9rZSbvxaWQbVX6C001SUbkS3ryyAJds6KYu-42uhuN7tQ@mail.gmail.com>
Message-ID: <CAHmME9rZSbvxaWQbVX6C001SUbkS3ryyAJds6KYu-42uhuN7tQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] powerpc/powernv: wire up rng during setup_arch
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

On Sat, Jun 11, 2022 at 4:42 PM Christophe Leroy
<christophe.leroy@csgroup.eu> wrote:
> Same here, the prototype should go in a header file., should be 'void
> __init' (and indeed the __init is pointless in the prototype, only
> matters in the function definition).

I'll change the order, but I don't see a good place for the prototype
other than the .c file. It's not a big deal to keep it there.

>
> Maybe the name should be pnv_rng_init() like the setup arch below.

All the rng.c files are powernv_ prefixed, not pnv_ prefixed.

Jason
