Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D07C0542A3A
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 11:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbiFHJCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 05:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbiFHJBX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 05:01:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE609270412;
        Wed,  8 Jun 2022 01:20:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A3BFB82600;
        Wed,  8 Jun 2022 08:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CF5C341C0;
        Wed,  8 Jun 2022 08:20:35 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="I8nrspf8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654676433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s+nnloJXOZe3sp7KGEI5/CL3G/9pL2fN3vtSg1xL8Vw=;
        b=I8nrspf8j1gD5i4+wAjj0htInCIHYEOX8yRD7u0i8fGlrktR2IhBQAaY3IcVciYQrx3Va1
        qM6+b1o5rDAICdKXp2PSch8A+Tt607ym3NZbJ8MTzplaSPiFMecsP3auw3Ol9K+WDmkvMn
        +EVDPLefmhwodj0zKIX6vtyesR1I1cU=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ac2b5bff (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 8 Jun 2022 08:20:33 +0000 (UTC)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-31332df12a6so52993887b3.4;
        Wed, 08 Jun 2022 01:20:33 -0700 (PDT)
X-Gm-Message-State: AOAM5328PeFqmY48pm8DngclszuBMpcxSeGcx+7MEV+TgHTnzOxvE6nE
        4pwBrVHGM6IsWTVYd2GE1ro29wNysnBO7EnuUiQ=
X-Google-Smtp-Source: ABdhPJzYWhAiZY+gq/MBohBjnsZTJ7ZYRXoMS1F5fwcHI24a4Z7znU19lyYizM6OeIKgkvASrWmuHV/POva6koiqls4=
X-Received: by 2002:a81:6c89:0:b0:30c:4c36:f9c7 with SMTP id
 h131-20020a816c89000000b0030c4c36f9c7mr35742711ywc.485.1654676432063; Wed, 08
 Jun 2022 01:20:32 -0700 (PDT)
MIME-Version: 1.0
References: <8cc7ebe4-442b-a24b-9bb0-fce6e0425ee6@raspberrypi.com>
 <CAHmME9pL=g7Gz9-QOHnTosLHAL9YSPsW+CnE=9=u3iTQaFzomg@mail.gmail.com>
 <0f6458d7-037a-fa4d-8387-7de833288fb9@raspberrypi.com> <CAHmME9rJif3ydZuFJcSjPxkGMofZkbu2PXcHBF23OWVgGQ4c+A@mail.gmail.com>
 <Yp8jQG30OWOG9C4j@arm.com>
In-Reply-To: <Yp8jQG30OWOG9C4j@arm.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 8 Jun 2022 10:20:21 +0200
X-Gmail-Original-Message-ID: <CAHmME9p+FxQhTQYKWKkxkGiYxErP6NHuvSiFEat7ts1XgsM6YA@mail.gmail.com>
Message-ID: <CAHmME9p+FxQhTQYKWKkxkGiYxErP6NHuvSiFEat7ts1XgsM6YA@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: initialize jump labels before setup_machine_fdt()
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Phil Elwell <phil@raspberrypi.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
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

Hi Catalin,

On Tue, Jun 7, 2022 at 12:07 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> Do you plan to fix the crng_ready() static branch differently? If you
> do, I'd like to revert the corresponding arm64 commit as well. It seems
> to be harmless but I'd rather not keep it if no longer needed. So please
> keep me updated whatever you decide.

Feel free to revert. I'm aborting this line of inquiry and will just
fix it downstream in random.c.

Jason
