Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B164D469D
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 13:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234966AbiCJMR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 07:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbiCJMR0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 07:17:26 -0500
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BD5C9A36;
        Thu, 10 Mar 2022 04:16:25 -0800 (PST)
Received: by mail-qv1-f51.google.com with SMTP id kl20so4313593qvb.10;
        Thu, 10 Mar 2022 04:16:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VXWjjmCL6PQMmHC/BXr8XwSL9VjR6u26j2gFJ4nELpM=;
        b=yhOVPv2d3XhOYDCRes/2daJKK+LWNkB5myZzkU6MzrvguVWvEd6kbLIg4MbXcmYjY6
         g063NQAI733L9w7GImoykBBgWVc63M5Up96K7QRPs7isCHf8AYesfmNn5HZvA/qG+us6
         B11MtPrrNv1ee3jgGMMxYMxo3XStDsYdlr7vDDTENP7oM9jZWBTAqKzUOnJ3B9INNE07
         s7tZ688MaWVyGxNbsGShoiYRKrK/cRHvl6v/fbM22JDN+fgd8UNkdtkk5WmQVVMgHK7s
         0aLOn9PjaYv2GgitblLTkFdj810JViJoBMaYk8JRQ+gkPOqR1Dl884RYWWI2aRU9RfWP
         tRgw==
X-Gm-Message-State: AOAM531leDApxVIlHjQN4eRXlSBP1WSB5aLDIA/bqhFoWYkGiLcZOSJt
        SRh0qrd1500EQhM86S24wq+5lnRFAncBfw==
X-Google-Smtp-Source: ABdhPJzcCyZ4nSIJWQNwMpAifksVlHIL9QzEDfce66wjiMLHfu6moLGtpKdyfV3REmQ1uHCl0arupA==
X-Received: by 2002:a05:6214:2424:b0:435:8d8b:57e9 with SMTP id gy4-20020a056214242400b004358d8b57e9mr3577501qvb.128.1646914584365;
        Thu, 10 Mar 2022 04:16:24 -0800 (PST)
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com. [209.85.128.169])
        by smtp.gmail.com with ESMTPSA id y7-20020a05622a164700b002e077bc9f88sm3090538qtj.57.2022.03.10.04.16.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 04:16:24 -0800 (PST)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-2dc0364d2ceso55413287b3.7;
        Thu, 10 Mar 2022 04:16:23 -0800 (PST)
X-Received: by 2002:a81:c703:0:b0:2d0:cc6b:3092 with SMTP id
 m3-20020a81c703000000b002d0cc6b3092mr3532252ywi.449.1646914583451; Thu, 10
 Mar 2022 04:16:23 -0800 (PST)
MIME-Version: 1.0
References: <20220310090048.1933020-1-laurent@vivier.eu> <20220310090048.1933020-3-laurent@vivier.eu>
In-Reply-To: <20220310090048.1933020-3-laurent@vivier.eu>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 10 Mar 2022 13:16:12 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVcbcDvETmVsipYyixAYeQEm9sQORd_UfiwvZj1W2ft4w@mail.gmail.com>
Message-ID: <CAMuHMdVcbcDvETmVsipYyixAYeQEm9sQORd_UfiwvZj1W2ft4w@mail.gmail.com>
Subject: Re: [PATCH v15 2/5] tty: goldfish: introduce gf_ioread32()/gf_iowrite32()
To:     Laurent Vivier <laurent@vivier.eu>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-rtc@vger.kernel.org, Stephen Boyd <sboyd@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 10:01 AM Laurent Vivier <laurent@vivier.eu> wrote:
> Revert
> commit da31de35cd2f ("tty: goldfish: use __raw_writel()/__raw_readl()")
>
> and define gf_ioread32()/gf_iowrite32() to be able to use accessors
> defined by the architecture.
>
> Cc: stable@vger.kernel.org # v5.11+
> Fixes: da31de35cd2f ("tty: goldfish: use __raw_writel()/__raw_readl()")
> Signed-off-by: Laurent Vivier <laurent@vivier.eu>

Please include tags given on previous versions:
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
