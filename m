Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66BFDE1BBF
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 15:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390750AbfJWNFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 09:05:52 -0400
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:50458 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390642AbfJWNFv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 09:05:51 -0400
Received: from mxbackcorp1o.mail.yandex.net (mxbackcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::301])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 0897E2E15C8;
        Wed, 23 Oct 2019 16:05:48 +0300 (MSK)
Received: from iva8-b53eb3f76dc7.qloud-c.yandex.net (iva8-b53eb3f76dc7.qloud-c.yandex.net [2a02:6b8:c0c:2ca1:0:640:b53e:b3f7])
        by mxbackcorp1o.mail.yandex.net (nwsmtp/Yandex) with ESMTP id CMEAkgWXLY-5ll4G81u;
        Wed, 23 Oct 2019 16:05:47 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1571835947; bh=kJuDEoi2DnAZHHcr2TKjwcZ45kR0BazMsfLIWVC/fKw=;
        h=In-Reply-To:Message-ID:Date:References:To:From:Subject:Cc;
        b=gKsN9ChSZUXTNXJVimiIvzGt1vtfImTBEHX2tgVfaG/SbXwzTAXcSs0vjXAqCy6bX
         KQePOZ6K/6SvFKakG+KOTu84oRsR0WuH1v6wJwx2XtccdE0BipE2P8SSOy9MkHkH2T
         C+/MVh3Y1vaawFNdUrmT5IqKUF0t4PiPp+pc+JSo=
Authentication-Results: mxbackcorp1o.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-red.dhcp.yndx.net (dynamic-red.dhcp.yndx.net [2a02:6b8:0:40c:3d43:d63f:7907:141a])
        by iva8-b53eb3f76dc7.qloud-c.yandex.net (nwsmtp/Yandex) with ESMTPSA id PM1IhkX4dm-5lW0x5l0;
        Wed, 23 Oct 2019 16:05:47 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Subject: Re: [PATCH 4.4 1/2] x86/vdso: Remove direct HPET mapping into
 userspace
From:   Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>
References: <157183247628.2324.16440279839073827980.stgit@buzz>
Message-ID: <00665546-4ad7-758c-d205-02f2fdca7e6e@yandex-team.ru>
Date:   Wed, 23 Oct 2019 16:05:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <157183247628.2324.16440279839073827980.stgit@buzz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23/10/2019 15.07, Konstantin Khlebnikov wrote:
> commit 1ed95e52d902035e39a715ff3a314a893a96e5b7 upstream.
> 
> Commit d96d87834d5b870402a4a5b565706a4869ebc020 in v4.4.190 which is
> backport of upstream commit 1ed95e52d902035e39a715ff3a314a893a96e5b7
> removed only HPET access from vdso but leaved HPET mapped in "vvar".
> So userspace still could read HPET directly and confuse hardware.
> 
> This patch removes mapping HPET page into userspace.
> 
> Fixes: d96d87834d5b ("x86/vdso: Remove direct HPET access through the vDSO") # v4.4.190
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Link: https://lore.kernel.org/lkml/6fd42b2b-e29a-1fd6-03d1-e9da9192e6c5@yandex-team.ru/
> ---
>   arch/x86/entry/vdso/vma.c |   14 --------------
>   1 file changed, 14 deletions(-)
> 
> diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
> index 6b46648588d8..cc0a3c16a95d 100644
> --- a/arch/x86/entry/vdso/vma.c
> +++ b/arch/x86/entry/vdso/vma.c
> @@ -18,7 +18,6 @@
>   #include <asm/vdso.h>
>   #include <asm/vvar.h>
>   #include <asm/page.h>
> -#include <asm/hpet.h>
>   #include <asm/desc.h>
>   #include <asm/cpufeature.h>
>   
> @@ -159,19 +158,6 @@ static int map_vdso(const struct vdso_image *image, bool calculate_addr)
>   	if (ret)
>   		goto up_fail;
>   
> -#ifdef CONFIG_HPET_TIMER
> -	if (hpet_address && image->sym_hpet_page) {

Probably this patch is not required.
It seems after removing symbol "hpet_page" from vdso code
image->sym_hpet_page always is NULL and this branch never executed.

> -		ret = io_remap_pfn_range(vma,
> -			text_start + image->sym_hpet_page,
> -			hpet_address >> PAGE_SHIFT,
> -			PAGE_SIZE,
> -			pgprot_noncached(PAGE_READONLY));
> -
> -		if (ret)
> -			goto up_fail;
> -	}
> -#endif
> -
>   	pvti = pvclock_pvti_cpu0_va();
>   	if (pvti && image->sym_pvclock_page) {
>   		ret = remap_pfn_range(vma,
> 
