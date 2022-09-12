Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF3D5B58B5
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 12:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiILKsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 06:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiILKsy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 06:48:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8068431235;
        Mon, 12 Sep 2022 03:48:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A640B80C67;
        Mon, 12 Sep 2022 10:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995EFC433D7;
        Mon, 12 Sep 2022 10:48:50 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Zx1K59G3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1662979728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3VnHRnWmfy4jhV6KCdBef2U7FhBpmZNXtEsd1ClbkL4=;
        b=Zx1K59G30k1A0f9R5lMLwo48fu9x1wD3wzU6pGWApFx5fZKyC8qT8xRjTOL0FiSMGE6P52
        zc5sUhwEF7EkHzugKR3DTEFxJe/Mqdh5Epp9qmiKD3TQoN3R7fegarphy3F2A/LzUv1E5N
        nS2iGwA7D4yPV3nYMkHxB/TvTxs8Rcg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0ce992cc (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 12 Sep 2022 10:48:48 +0000 (UTC)
Received: by mail-yb1-f175.google.com with SMTP id e187so5873159ybh.10;
        Mon, 12 Sep 2022 03:48:48 -0700 (PDT)
X-Gm-Message-State: ACgBeo3Eo2pHHMbzR6MEn718/phigi0aK/8FhHf7qC1u2rTENFnd3WW6
        rXNfqQhvf3GEJwE2J5DR7EeBYG0abziad1Ug7k8=
X-Google-Smtp-Source: AA6agR5v23F4RNQIBWKNs0tmqLeQUA02Utt9tgDO1RoqEqnJqEFv5c2vqOMiSGBJwBSif0imljZZ/lf+IcZVNgxH9qQ=
X-Received: by 2002:a25:be42:0:b0:695:e187:4e51 with SMTP id
 d2-20020a25be42000000b00695e1874e51mr21935328ybm.258.1662979727250; Mon, 12
 Sep 2022 03:48:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAJZ5v0js78b3qZXoxgXEwG7g0a7n_ALnEYjjzBGaQW7q4_ceCA@mail.gmail.com>
 <20220905172428.105564-1-Jason@zx2c4.com> <20220911123346.a7xbzdlbb7r5p6ih@mercury.elektranox.org>
 <Yx8N0hGNcbVPnJxW@zx2c4.com>
In-Reply-To: <Yx8N0hGNcbVPnJxW@zx2c4.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 12 Sep 2022 11:48:35 +0100
X-Gmail-Original-Message-ID: <CAHmME9popsZskH5xR0sX2Prhd_R78Dc9mEO3BKy6qcvaok1MXQ@mail.gmail.com>
Message-ID: <CAHmME9popsZskH5xR0sX2Prhd_R78Dc9mEO3BKy6qcvaok1MXQ@mail.gmail.com>
Subject: Re: [PATCH RESEND] power: supply: avoid nullptr deref in __power_supply_is_system_supplied
To:     Sebastian Reichel <sebastian.reichel@collabora.com>
Cc:     linux-pm@vger.kernel.org, stable@vger.kernel.org,
        "Rafael J . Wysocki" <rafael@kernel.org>
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

Ah another thing:

On Mon, Sep 12, 2022 at 11:45 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> My machine went through three changes I know about between the threshold
> of "not crashing" and "crashing":
> - Upgraded to 5.19 and then 6.0-rc1.
> - I used my laptop on batteries for a prolonged period of time for the
>   first time in a while.
> - I updated KDE, whose power management UI elements may or may not make
>   frequent calls to this subsystem to update some visual representation.

- Updated my BIOS.
