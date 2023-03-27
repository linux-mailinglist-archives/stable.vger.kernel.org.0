Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFA26C9F18
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 11:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbjC0JNN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 27 Mar 2023 05:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbjC0JNH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 05:13:07 -0400
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACC949D7;
        Mon, 27 Mar 2023 02:12:54 -0700 (PDT)
Received: by mail-yb1-f170.google.com with SMTP id b18so9631264ybp.1;
        Mon, 27 Mar 2023 02:12:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679908373;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=39v8GGfodhYmnqk1H1AgJMeOw8tM+/daTtEK7WYqt90=;
        b=8Iugbv7T0o94bi94zHQcjq0Jdum+aXNoWpmTpSr6aYWzqDv9CXBRnVJsSku6TlAX62
         4+me5ppZH8Ow0HSvi07kd3uhsFqL0YeXHM4vUPfao70pg8Gi2///Ip8kk7JwTKOGgunr
         tyGZsWzEvra4uFqIa+2KP5XXuWJtZg83JAf/nFNrHPmXr2ccIvXdkUsCxdaNop2XNJyt
         2gH0SSh50abrM29vzG6xA4YrhfAQ3Spx5i4ytWDCsBovaqgMN+4uGqYPHXUXRcJOV8ZG
         h90UgBDTt35m+K+mU/LKZia50CU+ayofXqVJo0qDc7x+Dh7necgz4a+3qCKqJBKAvu1C
         l86A==
X-Gm-Message-State: AAQBX9e7gjJdPwnltm77R1cyypFmnhmnXtojsK3xe1A9BM3m7QsA7jlv
        nkRrMGLoCxH8Xf2dGH2at/oF1IgSmTLOMA==
X-Google-Smtp-Source: AKy350ZbiD2DZfC9lB73Jn30riKilr2X8uT0nw1RBArcpv0MEa87JI4UZ6FCRDOxAhjbmInKJTJjXw==
X-Received: by 2002:a25:b096:0:b0:b6e:3a15:403 with SMTP id f22-20020a25b096000000b00b6e3a150403mr11388524ybj.60.1679908373354;
        Mon, 27 Mar 2023 02:12:53 -0700 (PDT)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id p142-20020a25d894000000b00b7767ca746fsm2168764ybg.12.2023.03.27.02.12.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 02:12:53 -0700 (PDT)
Received: by mail-yb1-f172.google.com with SMTP id n125so9594935ybg.7;
        Mon, 27 Mar 2023 02:12:52 -0700 (PDT)
X-Received: by 2002:a05:6902:154e:b0:b77:d2db:5f8f with SMTP id
 r14-20020a056902154e00b00b77d2db5f8fmr6443739ybu.12.1679908372769; Mon, 27
 Mar 2023 02:12:52 -0700 (PDT)
MIME-Version: 1.0
References: <20230321114753.75038-1-biju.das.jz@bp.renesas.com> <20230321114753.75038-2-biju.das.jz@bp.renesas.com>
In-Reply-To: <20230321114753.75038-2-biju.das.jz@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 27 Mar 2023 11:12:41 +0200
X-Gmail-Original-Message-ID: <CAMuHMdV1kE3bBj2xPhahmW-LVMNgp6=eHOJE0AgmV2vHrQYArA@mail.gmail.com>
Message-ID: <CAMuHMdV1kE3bBj2xPhahmW-LVMNgp6=eHOJE0AgmV2vHrQYArA@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] tty: serial: sh-sci: Fix transmit end interrupt handler
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
> The fourth interrupt on SCI port is transmit end interrupt compared to
> the break interrupt on other port types. So, shuffle the interrupts to fix
> the transmit end interrupt handler.
>
> Fixes: e1d0be616186 ("sh-sci: Add h8300 SCI")
> Cc: stable@vger.kernel.org
> Suggested-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
> v3->v4:
>  * No change.

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
