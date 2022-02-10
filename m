Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467F64B0E1D
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 14:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241954AbiBJNHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 08:07:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbiBJNHs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 08:07:48 -0500
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD56C1A7;
        Thu, 10 Feb 2022 05:07:49 -0800 (PST)
Received: by mail-vk1-f181.google.com with SMTP id b2so3026779vkl.1;
        Thu, 10 Feb 2022 05:07:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9xSDkfGA7Gbw9lubbu8lfvfHIM/jNHECsHfMyY0SuGE=;
        b=bO6RaScuERw3GXVA1DRl1JfheXTC9eP+i0yiS4PhaE58qtBR/633FNWC10gxVpRfaL
         hz+srg73qHj43kG+d73xS9Hz6mQDPmjqoxjfChXrp0YgEJn6R4Ba9PqDqUpZwyBsROyZ
         PED5b8G4G2OMfvc70Q3B40VkLXNKg7dzMCP2Avv5ObYJUJBtb1m27VbzUrvNiE7+scn1
         AL5BahMBzw0fxL2v9nkD/nM3BTO7yuBMR2BGEdk4YqdT+3Q+yLTBFgSwZZUBhI56UwRP
         jMzOdNGDp/zoRELmzIHZxj9aArCUH2mMFjYx0nZYWQB/8gdJMxcq3x8co5neVEC9O+Eq
         xmzQ==
X-Gm-Message-State: AOAM530eqhXHZMhigdTH5Tgx98OXm9vNQE96GRvh6N4yllSs2CoAgZZQ
        IGsAfDf5CIdZcNFXRKBhRpAbab+4AS2Phg==
X-Google-Smtp-Source: ABdhPJzsuCoIpxIyzoLNmr4cvl9yb0J3mW4bbHtKwyfaLdkjoo0STed/5HGv4Mfp8fADBo4HBC+ZAw==
X-Received: by 2002:a05:6122:588:: with SMTP id i8mr2560846vko.41.1644498468895;
        Thu, 10 Feb 2022 05:07:48 -0800 (PST)
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com. [209.85.217.47])
        by smtp.gmail.com with ESMTPSA id g27sm1394621vkd.17.2022.02.10.05.07.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 05:07:48 -0800 (PST)
Received: by mail-vs1-f47.google.com with SMTP id z62so4070774vsz.2;
        Thu, 10 Feb 2022 05:07:48 -0800 (PST)
X-Received: by 2002:a05:6102:34d9:: with SMTP id a25mr2360386vst.68.1644498468038;
 Thu, 10 Feb 2022 05:07:48 -0800 (PST)
MIME-Version: 1.0
References: <20220130143333.552646-1-laurent@vivier.eu> <20220130143333.552646-3-laurent@vivier.eu>
In-Reply-To: <20220130143333.552646-3-laurent@vivier.eu>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 10 Feb 2022 14:07:37 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVX_DTZDTad9iU2DkTT_KTyducGJWtisj8wpTOzWdZMgg@mail.gmail.com>
Message-ID: <CAMuHMdVX_DTZDTad9iU2DkTT_KTyducGJWtisj8wpTOzWdZMgg@mail.gmail.com>
Subject: Re: [PATCH v14 2/5] tty: goldfish: introduce gf_ioread32()/gf_iowrite32()
To:     Laurent Vivier <laurent@vivier.eu>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-rtc@vger.kernel.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Stephen Boyd <sboyd@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
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

On Sun, Jan 30, 2022 at 3:33 PM Laurent Vivier <laurent@vivier.eu> wrote:
> Revert
> commit da31de35cd2f ("tty: goldfish: use __raw_writel()/__raw_readl()")
>
> and define gf_ioread32()/gf_iowrite32() to be able to use accessors
> defined by the architecture.
>
> Cc: stable@vger.kernel.org # v5.11+
> Fixes: da31de35cd2f ("tty: goldfish: use __raw_writel()/__raw_readl()")
> Signed-off-by: Laurent Vivier <laurent@vivier.eu>

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
