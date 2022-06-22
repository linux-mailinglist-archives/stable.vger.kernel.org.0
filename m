Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8364C5543D3
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 10:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352477AbiFVHOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 03:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352415AbiFVHOU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 03:14:20 -0400
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA44175B4;
        Wed, 22 Jun 2022 00:14:19 -0700 (PDT)
Received: by mail-qv1-f48.google.com with SMTP id 88so20384894qva.9;
        Wed, 22 Jun 2022 00:14:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tuu+Yntf4skl/ZbQbx9nr+7W+bdBdIu+BOyv/WQzLoA=;
        b=uzQEeuW0JRifzwA0FHkjo13l363M0MKTde+apfkNUO5dH89vN0Rt8zje2eWjkJodbf
         N4Ta6crdDvwfcMbBHptkaQywWRet3uLw/T67SQ0uWyCSGvwuJk04jRaewhP9Nk6x41Ti
         9Vzu7a6TIYHawBk70dyTROiOIoFiP5sju6ZAlMn1dZCFLZ0WLQGhH14PuBIV8ICnDh9X
         3PNqkvlSMUfgUhhp2lMS3YwaNVKquO+tvWx4yX2kOnHni+xmfNe4v+lxS0IFZC6t9+7O
         p14Gx0T/WhKM3HyFgphuOaPLKXTtM6h8KUhtR+Xf1SjQUxJXCOXTlfVokI/gzlpJDyYy
         hfVQ==
X-Gm-Message-State: AJIora/N2Lwvfwai+jwHJwQV4vgCbWal+VophoBmUx7pqhpm5VoyWJzU
        ejIpnM/micEMHmjOZhWWNZxuGLQWkDyKKQ==
X-Google-Smtp-Source: AGRyM1tCuf7rEPEbGw7r6xrtNfYmPQiPbK5UVfyjn1vv2pCX1SLu49J4COh1dwmq2hDneVsC7ekj5g==
X-Received: by 2002:a05:6214:29ec:b0:470:5aec:e15e with SMTP id jv12-20020a05621429ec00b004705aece15emr4087996qvb.102.1655882058448;
        Wed, 22 Jun 2022 00:14:18 -0700 (PDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id v11-20020a05620a440b00b006a6a7b4e7besm17266328qkp.109.2022.06.22.00.14.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 00:14:17 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id t1so28631857ybd.2;
        Wed, 22 Jun 2022 00:14:16 -0700 (PDT)
X-Received: by 2002:a05:6902:120e:b0:634:6f29:6b84 with SMTP id
 s14-20020a056902120e00b006346f296b84mr2215179ybu.604.1655882056767; Wed, 22
 Jun 2022 00:14:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220621205010.250185-1-sashal@kernel.org> <20220621205010.250185-5-sashal@kernel.org>
In-Reply-To: <20220621205010.250185-5-sashal@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 22 Jun 2022 09:14:05 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXe5PZ-XeU678VxWgWbT8CRcUJgPRQk0pEO49_nnPhFew@mail.gmail.com>
Message-ID: <CAMuHMdXe5PZ-XeU678VxWgWbT8CRcUJgPRQk0pEO49_nnPhFew@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.17 05/20] eeprom: at25: Split reads into chunks
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
        Ralph Siemsen <ralph.siemsen@linaro.org>
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

On Tue, Jun 21, 2022 at 11:02 PM Sasha Levin <sashal@kernel.org> wrote:
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
