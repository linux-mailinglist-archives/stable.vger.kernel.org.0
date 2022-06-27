Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2370A55C65F
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbiF0G7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 02:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232364AbiF0G7F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 02:59:05 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B591821A4
        for <stable@vger.kernel.org>; Sun, 26 Jun 2022 23:59:02 -0700 (PDT)
Received: from mail-yb1-f172.google.com ([209.85.219.172]) by
 mrelayeu.kundenserver.de (mreue108 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1M89TB-1o1ZyR2Yhn-005Ek4 for <stable@vger.kernel.org>; Mon, 27 Jun 2022
 08:59:00 +0200
Received: by mail-yb1-f172.google.com with SMTP id r3so15142176ybr.6
        for <stable@vger.kernel.org>; Sun, 26 Jun 2022 23:59:00 -0700 (PDT)
X-Gm-Message-State: AJIora/1ZCnHY4wgeoEsVDroxw7KwSYcBZjv3WDHbMsItk2/2TOJ7FFy
        5wpr9uSSE8R5qCi2uznMHkEMHJldCrkj0TujUzo=
X-Google-Smtp-Source: AGRyM1uQt+1XGUbIPHFdjSBX5mznj0ldKaweebeqCcii4Y6MsFEcWB4DjElgscuIMmBjyyVmeplhr0IrZxvqgmxfTZI=
X-Received: by 2002:a25:9241:0:b0:669:ad54:70b6 with SMTP id
 e1-20020a259241000000b00669ad5470b6mr11515689ybo.480.1656313139497; Sun, 26
 Jun 2022 23:58:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220627063212.21626-1-xyangxi5@gmail.com>
In-Reply-To: <20220627063212.21626-1-xyangxi5@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 27 Jun 2022 08:58:41 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1L+_-qVEsOfoHgJ=3dg+cXLHQiWLC7HmQV07Ds8C8ZXA@mail.gmail.com>
Message-ID: <CAK8P3a1L+_-qVEsOfoHgJ=3dg+cXLHQiWLC7HmQV07Ds8C8ZXA@mail.gmail.com>
Subject: Re: [PATCH] asm-generic: fix buffer overflow read in __strncpy_from_user
To:     Yangxi Xiang <xyangxi5@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:W4YYUHVFhSA5WYXu2xMaAi3nDi/cRyZKAjBIwNKOWQeLtvTRGLm
 nAfanf42/NhcSzXINjafKnMoX2jJn7iXTu2qanfbiB8M/MiB53VX7mfCnv2Cq7/Sc9WcTdv
 mf3QR8C+KfnkADIoeKzHoazw8q6nS73ck/mdfYxsSEYbyxKBJWLgXZQjDBpdKMz63MDsrvN
 iAQueNLKDdf4tfnrdK91g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:S2ML651UZNs=:JB0bUksi94BseWc//b3pT/
 1Donmc8I2C8jttxvU4mp31VR0QYqDLTWul6aAUHcR7wZSHGCJ4zK4jxYa6SEh9XuEV3/ZgaF1
 MHj7vN89h9ii0QtgYoBx8msC0m2a+kPgieAAXvLs6OddakjooQ0EmKjmxS0zTb2Vaq53ho/Xh
 aFB23vCqDJCM6mAx3LZtsfQFdeNbEot41MF4Zdlw04peAm1spHD+14uC8HNDIYi6BMowrY8bN
 CuocNUfrw6v0hd/nHgMl7au/XKPf7Cfkdsoi+U1Q73qMMgvMFaW9NBym2b3HQWRa2kQaR5+Xj
 y7Qjk85EL/Olm3YCw6alFs4q+15VW3gmuYktNTO800jroWZk6NqvTt5jN6x5bgKJoUx3yPnBR
 P4o5N1M3AZFYe6hQbn+QRhOQ8YFEXSdkDYaWvb1JKBNAOSxxolz55CLinw3CLObIWIaynskzC
 TvPWmTlPyap3YZHqPhor6Yr+5/lru6Zv/rQTGENvJAzWxJnNbDcgwtps85ALl/UckJSuuFvdH
 n5n7ci/eLXxI9Sbfe0aPOerohZnJ4Zltm+Cck434gEcccxrMLlU5ghX7oiR946u3pO+Hs5GST
 6XWQWbc6Dk8LtV+EwLETmPlTxO3c1tEaJRZvGB8yR43eyzkcBiX8XEvceznftsleTHk9qjoRi
 1YNJkRclTSWRTn+ccUramh7snu2JAC/K/qofZ97JXdaTmBqOgjPL+w3fcRdLBkKFfWdXtMH/p
 xZpc/xSBqtrPRXecs2QP52wH2QmBu42HaE/SBQ==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 27, 2022 at 8:32 AM Yangxi Xiang <xyangxi5@gmail.com> wrote:
>
> a common calling pattern is strncpy_from_user(buf, user_ptr, sizeof(buf)).
> However a buffer-overflow read occurs in this loop when reading the last
> byte. Fix it by early checking the available bytes.
>
> Signed-off-by: Yangxi Xiang <xyangxi5@gmail.com>
> ---

This function was removed in commit 98b861a30431 ("asm-generic: uaccess:
remove inline strncpy_from_user/strnlen_user"), and the new version in
lib/strncpy_from_user.c does not have the problem

On which architecture and kernel version do you see the problem?

      Arnd
