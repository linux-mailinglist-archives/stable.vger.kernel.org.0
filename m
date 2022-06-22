Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B79D65543FD
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 10:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbiFVHPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 03:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350659AbiFVHPT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 03:15:19 -0400
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE2F36E1D;
        Wed, 22 Jun 2022 00:15:18 -0700 (PDT)
Received: by mail-qv1-f43.google.com with SMTP id n15so19900375qvh.12;
        Wed, 22 Jun 2022 00:15:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lHEhufuR0BCwdgBJ9UiDykLCzo+7fjj1KMdN8Y47avc=;
        b=osZL6e19UyN+wUDEWFphga5cbgcSKq902CLx+IBBOgQH2ryjjvsrsV4gHRg0+jCvdM
         l7+9VPhaDlDy/zOnPdxwiX39Tdpd3RloXlpAQZ1biUT6y/zwBSsR8ZqPERrcuYJNNUO1
         yKJkh1Ek+AWj+CYKERuKtaZx866REk4LS+uRwkqC6eP1+TkUzLzQc5g/AVtN+WNAu64X
         +Gb/52jCszcKvRO4gTLw/T+CSeFasnRwOMfghvVGHWfuWb+I0hOvBeWTsr8tol41haUv
         7gv+mQdnlTMU9IIa5imCN+zyIo0WsljlQaIep6aUxfPKLruxR1Dq6wJBUpnDxFzahFdm
         8ykA==
X-Gm-Message-State: AJIora8pTZB0yxE7PjkuNhge68t5IfSVfBROPfCUfBfI7J2iKrJ5FdWZ
        Dpe/nBLTJfYmhjGsEGexHYtL2PxEIudn0g==
X-Google-Smtp-Source: AGRyM1vLlVlUEYkp6KfhJmCWmyg6tRO82+0hpeHTNPYk9pbj49uvmhJFD3QGvb+9g2InOcnCWzg2bQ==
X-Received: by 2002:ac8:7dc2:0:b0:306:6881:2693 with SMTP id c2-20020ac87dc2000000b0030668812693mr1803460qte.16.1655882117867;
        Wed, 22 Jun 2022 00:15:17 -0700 (PDT)
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com. [209.85.128.182])
        by smtp.gmail.com with ESMTPSA id bp15-20020a05620a458f00b006a72b38e2ecsm15450053qkb.51.2022.06.22.00.15.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 00:15:17 -0700 (PDT)
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-3176b6ed923so153599027b3.11;
        Wed, 22 Jun 2022 00:15:17 -0700 (PDT)
X-Received: by 2002:a81:574c:0:b0:317:7c3a:45be with SMTP id
 l73-20020a81574c000000b003177c3a45bemr2586631ywb.316.1655882117218; Wed, 22
 Jun 2022 00:15:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220621204928.249907-1-sashal@kernel.org> <20220621204928.249907-5-sashal@kernel.org>
In-Reply-To: <20220621204928.249907-5-sashal@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 22 Jun 2022 09:15:06 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVmkr2sQ6-1pu=B7EscXWY-ZwONo=WGGwDOK_D6VxKc=A@mail.gmail.com>
Message-ID: <CAMuHMdVmkr2sQ6-1pu=B7EscXWY-ZwONo=WGGwDOK_D6VxKc=A@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.18 05/22] eeprom: at25: Split reads into chunks
 and cap write size
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Brad Bishop <bradleyb@fuzziesquirrel.com>,
        Eddie James <eajames@linux.ibm.com>,
        Joel Stanley <joel@jms.id.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Ralph Siemsen <ralph.siemsen@linaro.org>,
        Mark Brown <broonie@kernel.org>
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

Hi Sasha,

On Tue, Jun 21, 2022 at 10:57 PM Sasha Levin <sashal@kernel.org> wrote:
> From: Brad Bishop <bradleyb@fuzziesquirrel.com>
>
> [ Upstream commit 0a35780c755ccec097d15c6b4ff8b246a89f1689 ]
>
> Make use of spi_max_transfer_size to avoid requesting transfers that are
> too large for some spi controllers.
>
> Signed-off-by: Brad Bishop <bradleyb@fuzziesquirrel.com>
> Signed-off-by: Eddie James <eajames@linux.ibm.com>
> Signed-off-by: Joel Stanley <joel@jms.id.au>
> Link: https://lore.kernel.org/r/20220524215142.60047-1-eajames@linux.ibm.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Please drop this, as it breaks operation on devices that don't need
the split, and may cause a buffer overflow on those that do.

https://lore.kernel.org/r/7ae260778d2c08986348ea48ce02ef148100e088.1655817534.git.geert+renesas@glider.be/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
