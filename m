Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23AF16C9F27
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 11:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233100AbjC0JPq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 27 Mar 2023 05:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233104AbjC0JPp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 05:15:45 -0400
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9456440F6;
        Mon, 27 Mar 2023 02:15:44 -0700 (PDT)
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-5456249756bso157889417b3.5;
        Mon, 27 Mar 2023 02:15:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679908543;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dxHTlHiZ/YxeWrFBazUQbtoVPajpatLFseY9xfpecZI=;
        b=bVKdmwru5nNA8IMZbjuEQEtIfUklUH7HVJl9soh/4sjQ/QJGiQOB3FtYDoYMr+DOt7
         2KQx6hGolcBEq0zlzA3VEWlux/7E6pZ+3oC4dxVNua+PwU3sIBTPySimLgFdFzfIidrY
         BbO/3a0WjI1SBipMWv7C9UuXkWMXepQ2kZC5zQRtZjxdpUGTz2J39VHmETUJQu3w/uoL
         HqK5AG/UoxMK+WVqo7er9RGT51fbrbw089pZ5+YmO4BfsHlC1slh2Qwe0TzQuU/YoqCv
         kfhZZEz8AFZcTbUvvCmjuMFVFuBzySWEpydf47z8yEmFaeqe9S5iEcimLg/vcXHIaHOk
         mxkQ==
X-Gm-Message-State: AAQBX9dIrAQcpfBYt1ACISf2t9QZwV3uvdCgtr96yTHld2iaru0Mq8dz
        AaMHF019KigbKNMH3+YJUtMfVNjGpyJ/1g==
X-Google-Smtp-Source: AKy350Ybbq7RfAWlzgkzebCBcMrhAvAQtu5xNQEjdZJLEM5vDvTqUJUNickyiV9xcy82sh3kfy4jOA==
X-Received: by 2002:a0d:ef86:0:b0:545:dca6:4e0 with SMTP id y128-20020a0def86000000b00545dca604e0mr3585885ywe.41.1679908543654;
        Mon, 27 Mar 2023 02:15:43 -0700 (PDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id u123-20020a817981000000b00545a08184a1sm1863903ywc.49.2023.03.27.02.15.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 02:15:43 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id k17so9587173ybm.11;
        Mon, 27 Mar 2023 02:15:43 -0700 (PDT)
X-Received: by 2002:a05:6902:10c3:b0:b75:9519:dbcd with SMTP id
 w3-20020a05690210c300b00b759519dbcdmr7051141ybu.12.1679908542944; Mon, 27 Mar
 2023 02:15:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230321114753.75038-1-biju.das.jz@bp.renesas.com> <20230321114753.75038-3-biju.das.jz@bp.renesas.com>
In-Reply-To: <20230321114753.75038-3-biju.das.jz@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 27 Mar 2023 11:15:31 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXO+ZEotRSSRnqeB+YxY4jUm+zNyecEiZHqBQcAd_oXpA@mail.gmail.com>
Message-ID: <CAMuHMdXO+ZEotRSSRnqeB+YxY4jUm+zNyecEiZHqBQcAd_oXpA@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] tty: serial: sh-sci: Fix Rx on RZ/G2L SCI
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        linux-serial@vger.kernel.org,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 21, 2023 at 12:48 PM Biju Das <biju.das.jz@bp.renesas.com> wrote:
> SCI IP on RZ/G2L alike SoCs do not need regshift compared to other SCI
> IPs on the SH platform. Currently, it does regshift and configuring Rx
> wrongly. Drop adding regshift for RZ/G2L alike SoCs.
>
> Fixes: dfc80387aefb ("serial: sh-sci: Compute the regshift value for SCI ports")
> Cc: stable@vger.kernel.org
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
> v3->v4:
>  * Updated the fixes tag
>  * Replaced sci_port->is_rz_sci with dev->dev.of_node as regshift are only needed
>    for sh770x/sh7750/sh7760, which don't use DT yet.
>  * Dropped is_rz_sci variable from struct sci_port.

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

One can wonder how this ever worked on DT-based H8/300...

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
