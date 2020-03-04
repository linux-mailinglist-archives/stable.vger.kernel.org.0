Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B04CE179B95
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 23:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388541AbgCDWOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 17:14:38 -0500
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:53266 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388422AbgCDWOi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 17:14:38 -0500
Received: from [192.168.42.210] ([93.22.132.175])
        by mwinf5d06 with ME
        id ANEZ2200C3nCjhH03NEZnp; Wed, 04 Mar 2020 23:14:34 +0100
X-ME-Helo: [192.168.42.210]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 04 Mar 2020 23:14:34 +0100
X-ME-IP: 93.22.132.175
Subject: Re: AW: [PATCH 5.5 110/176] MIPS: VPE: Fix a double free and a memory
 leak in release_vpe()
To:     Walter Harms <wharms@bfs.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
References: <20200303174304.593872177@linuxfoundation.org>
 <20200303174317.555620066@linuxfoundation.org>
 <adf1859b4dcc497285ebbda017ece22d@bfs.de>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <33446ca8-0ace-e081-47fa-ceddf7fe80df@wanadoo.fr>
Date:   Wed, 4 Mar 2020 23:14:30 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <adf1859b4dcc497285ebbda017ece22d@bfs.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 04/03/2020 à 22:28, Walter Harms a écrit :
> ________________________________________
> Von: kernel-janitors-owner@vger.kernel.org <kernel-janitors-owner@vger.kernel.org> im Auftrag von Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Gesendet: Dienstag, 3. März 2020 18:42
> An: linux-kernel@vger.kernel.org
> Cc: Greg Kroah-Hartman; stable@vger.kernel.org; Christophe JAILLET; Paul Burton; ralf@linux-mips.org; linux-mips@vger.kernel.org; kernel-janitors@vger.kernel.org
> Betreff: [PATCH 5.5 110/176] MIPS: VPE: Fix a double free and a memory leak in release_vpe()
>
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>
> commit bef8e2dfceed6daeb6ca3e8d33f9c9d43b926580 upstream.
>
> Pointer on the memory allocated by 'alloc_progmem()' is stored in
> 'v->load_addr'. So this is this memory that should be freed by
> 'release_progmem()'.
>
> 'release_progmem()' is only a call to 'kfree()'.
>
> With the current code, there is both a double free and a memory leak.
> Fix it by passing the correct pointer to 'release_progmem()'.
>
> Fixes: e01402b115ccc ("More AP / SP bits for the 34K, the Malta bits and things. Still wants")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Signed-off-by: Paul Burton <paulburton@kernel.org>
> Cc: ralf@linux-mips.org
> Cc: linux-mips@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: kernel-janitors@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>   arch/mips/kernel/vpe.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/arch/mips/kernel/vpe.c
> +++ b/arch/mips/kernel/vpe.c
> @@ -134,7 +134,7 @@ void release_vpe(struct vpe *v)
>   {
>          list_del(&v->list);
>          if (v->load_addr)
> -               release_progmem(v);
> +               release_progmem(v->load_addr);
>          kfree(v);
>   }
>
>
> since release_progmem() is kfree() it is also possible to drop "if (v->load_addr)"
>
> jm2c
>
> re,
>   wh

Agreed.

My patch had the following comment after the patch description:
---
The 'if (v->load_addr)' looks also redundant, but, well, the code is old
and I feel lazy tonight to send another patch for only that.
---

git log shows nearly no update since end of 2015, so I kept my proposal 
as minimal :)

CJ

