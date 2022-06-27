Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F02A755E0F8
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbiF0Izb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 04:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232628AbiF0Iza (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 04:55:30 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36A56372
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 01:55:29 -0700 (PDT)
Received: from mail-yb1-f177.google.com ([209.85.219.177]) by
 mrelayeu.kundenserver.de (mreue011 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1Mzyi6-1nlSUg0Gu6-00x1gd for <stable@vger.kernel.org>; Mon, 27 Jun 2022
 10:55:28 +0200
Received: by mail-yb1-f177.google.com with SMTP id d5so15575487yba.5
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 01:55:27 -0700 (PDT)
X-Gm-Message-State: AJIora8E3/PWZpIZvuDr9JAZiDLf2Bur4dF3tGjPlfj1mnFMHX0/ClEp
        mgY8gPHbdGdt6wHKd1kiBNL/vle5Tf7R2S6sAJ8=
X-Google-Smtp-Source: AGRyM1tSldGSoH3YR/KQ0ZXaSbn7iZ8QT9+GjNvHYTKjPscxQCebUPrJjU4qspQif7WZYal2HIjx++Hnawfq26tEqqM=
X-Received: by 2002:a25:d60d:0:b0:66c:c951:3eb1 with SMTP id
 n13-20020a25d60d000000b0066cc9513eb1mr4831956ybg.550.1656320126863; Mon, 27
 Jun 2022 01:55:26 -0700 (PDT)
MIME-Version: 1.0
References: <CAK8P3a1L+_-qVEsOfoHgJ=3dg+cXLHQiWLC7HmQV07Ds8C8ZXA@mail.gmail.com>
 <20220627074018.19181-1-xyangxi5@gmail.com>
In-Reply-To: <20220627074018.19181-1-xyangxi5@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 27 Jun 2022 10:55:10 +0200
X-Gmail-Original-Message-ID: <CAK8P3a31O-_oGvG3bHCer7DXJApsd-TLV71_NwVt=yMGQ_iR_Q@mail.gmail.com>
Message-ID: <CAK8P3a31O-_oGvG3bHCer7DXJApsd-TLV71_NwVt=yMGQ_iR_Q@mail.gmail.com>
Subject: Re: [PATCH] asm-generic: fix buffer overflow read in __strncpy_from_user
To:     Yangxi Xiang <xyangxi5@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:31ubP6cLgMYh/Q8V9mHShpgNUcywgQXNn8JM0xrqTA70sTVn5wc
 DkoXUvX5ihxKftJxAU8pSCMvmIGCTNWdb/ncC97XHYnRU+NQOBcgw0W0rK+vEIUsXGWVrvz
 srelF8/Eo09PJWBODTSWmkrNQyyTWMPMxwFfVplQESQLmi19iniZD9ByYFOKwssVQAqIXGp
 hgHzqY0uJugJhoJUHedcg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:X7gMaAUoqTw=:oYlLaGGHmzhG1qz0PFjdUS
 067pIbBiwnmRbi4/kmCIY9pG7zMel30hSu2FDqATJRrAFFYkSu2FfgcWKG2zD9LgtsRvhQFAr
 RJ6Shh5hr5kvSiccP158LFU6WxfLTnmyQZLQxByWrX7T6KauDCuEt3d98KI7AhG+BBGnjOlBN
 mlTdm7z7Nk7/apN4iBv4q6MgYOv5bcozrUQLDe+SnONXXNQ3pJ2ll/AMrkDFIYCoHpKIb/Z/o
 O8nu7ebW+NuoVxSqkLk+DkRU65mao3o4xpWwvgNOTn10UFx83CDaJHDtuw6KnsuZnJCMvRtNw
 SYeL0PYxKghUT1gk8R0YNgv9YTWPwhAEQX0jr0F9fQuI1QHkUhlIjmbCwzR4YmGUvGSqBgO94
 rQN/wMPosW7ysLlWrWrvHLx593I7eK+da6duIRSqaZFTjzosqsGj7aO94o29F5Pv0Gt5SFUIe
 oa8hQxP4FPSx6+3ILAm0jRhN/6hSxjCLUnQdtPf4lOahk+gsZeA35FUOxf8n4Wz9tuGUdOa/W
 Qj5f+mW75JLUi0qubWYpG24cG6E9xRKAeK7CGZdSPfQvDIcjZiMReDyDKncdj+MQbBjVUeJgy
 IYKiYmHpiV8UM30IoxCO5Awi4bzfZoAjSfvsLUM2O7MoTmwKP+99rQ2unzdsjVwkIcAH2Pdfl
 QFfz8smbykvcNKqp9C2/3yqwWwn7xG7WggnEzpVoMZj5ZjfPLBGQf2Zthk2x5wkxlhMVj9Wze
 9RnLNjWO6nU3ddtoapkdbVf+jPgYp+Y+cwPutA==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 27, 2022 at 9:40 AM Yangxi Xiang <xyangxi5@gmail.com> wrote:
>
> I also noticed that it was removed in commit 98b861a30431. I did see
> this problem in kernel 5.1 and this problem remains in
> architectures without selecting config GENERIC_STRNCPY_FROM_USER.

Which architectures do you mean? I don't see any architecture using
asm-generic/uaccess.h without setting GENERIC_STRNCPY_FROM_USER
before commit 98b861a30431 or the prior release.

Also, I think the implementation relied on strncpy() setting a zero pad
at the end of the string, so the ckeck would only be needed for a count
value that starts out negative? Is there another way this can actually
cause problems?

        Arnd
