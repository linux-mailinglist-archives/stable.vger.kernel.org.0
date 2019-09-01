Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 761B5A4B2D
	for <lists+stable@lfdr.de>; Sun,  1 Sep 2019 20:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbfIASiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Sep 2019 14:38:06 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:18077 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbfIASiG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Sep 2019 14:38:06 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d6c100e0000>; Sun, 01 Sep 2019 11:38:06 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Sun, 01 Sep 2019 11:38:05 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Sun, 01 Sep 2019 11:38:05 -0700
Received: from [10.2.174.243] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 1 Sep
 2019 18:38:03 +0000
Subject: Re: [PATCH] x86/boot: Fix regression--secure boot info loss from
 bootparam sanitizing
To:     John S Gruber <JohnSGruber@gmail.com>, <john.hubbard@gmail.com>,
        <bp@alien8.de>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        <mingo@redhat.com>, <tglx@linutronix.de>, <x86@kernel.org>,
        <gregkh@linuxfoundation.org>
References: <20190731054627.5627-2-jhubbard@nvidia.com>
 <CAPotdmTa-cAeTVkHkRWj0x27b0ME0X7=YMkfdGkBRoEk5zUw+w@mail.gmail.com>
From:   John Hubbard <jhubbard@nvidia.com>
CC:     <stable@vger.kernel.org>
X-Nvconfidentiality: public
Message-ID: <a07f4712-710e-741a-1706-c4192b9fcd39@nvidia.com>
Date:   Sun, 1 Sep 2019 11:36:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAPotdmTa-cAeTVkHkRWj0x27b0ME0X7=YMkfdGkBRoEk5zUw+w@mail.gmail.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1567363086; bh=6/ZwI9wyaXPEPXf7keN8eUIduZ7oeHJoPXK9is/LJk8=;
        h=X-PGP-Universal:Subject:To:References:From:CC:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=JB+asdglzdndJCdfgDPxUMgjeCA9tL7bomMm5NoD+sCnEw0LTxo3CxNajSk7vvbJV
         PG6Gj875WWVt2ZS1cgwYk7CxqpRvQIz3ehLMFXT52oyVIXVibT9uyAyuea7wlPwKsH
         cjD/Mv8WbixHGKAzQ5+sRMVI9I8Sm0mUVLqe1KSa6/0HYjtpkSAw/JogxiZjsKD7jC
         4445/OU4LH6Ke+Fa8dgttu7OPt/oCCmGdSmqPpNyURW/Icstp6w5PJ9jfZ/6Q+xsD+
         3qfQGyNRA2GLNMIbkE8LOECNzAdfYlLJJx2AzLjybt78RNPVwKM53XfhyJJU2cYWVc
         t+Pn0sFWsTvaQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/1/19 8:38 AM, John S Gruber wrote:
> From: "John S. Gruber" <JohnSGruber@gmail.com>
> 
> commit a90118c445cc ("x86/boot: Save fields explicitly, zero out everything
> else") now zeros the secure boot information passed by the boot loader or
> by the kernel's efi handover mechanism.
> 
> Include boot-params.secure_boot in the preserve field list.
> 
> Signed-off-by: John S. Gruber <JohnSGruber@gmail.com>
> ---
> 
> I noted a change in my computers between running signed 5.3-rc4 and 5.3-rc6
> with signed kernels using the efi handoff protocol with grub. The kernel
> log message "Secure boot enabled" becomes "Secure boot could not be
> determined". The efi_main function in arch/x86/boot/compressed/eboot.c sets
> this field early but it is subsequently zeroed by the above referenced commit
> in the file arch/x86/include/asm/bootparam_utils.h
> 
> Applies to 5.3-rc6.
> 

Hi,

The fix itself looks good, so you can add:

     Reviewed-by: John Hubbard <jhubbard@nvidia.com>

...but note that the commit description should get a few tweaks:

1. Your description above is actually well-suited for the commit log,
so please add that in. Especially the symptoms are desirable to have
on record.

2. This should Cc: stable@vger.kernel.org, because the whole thing
made it into -stable and those kernels need this fix.

3. Also need a Fixes tag:

Fixes: commit a90118c445cc ("x86/boot: Save fields explicitly, zero out everything else")

thanks,
-- 
John Hubbard
NVIDIA

>   arch/x86/include/asm/bootparam_utils.h | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/include/asm/bootparam_utils.h
> b/arch/x86/include/asm/bootparam_utils.h
> index 9e5f3c7..981fe92 100644
> --- a/arch/x86/include/asm/bootparam_utils.h
> +++ b/arch/x86/include/asm/bootparam_utils.h
> @@ -70,6 +70,7 @@ static void sanitize_boot_params(struct boot_params
> *boot_params)
>   			BOOT_PARAM_PRESERVE(eddbuf_entries),
>   			BOOT_PARAM_PRESERVE(edd_mbr_sig_buf_entries),
>   			BOOT_PARAM_PRESERVE(edd_mbr_sig_buffer),
> +			BOOT_PARAM_PRESERVE(secure_boot),
>   			BOOT_PARAM_PRESERVE(hdr),
>   			BOOT_PARAM_PRESERVE(e820_table),
>   			BOOT_PARAM_PRESERVE(eddbuf),
> 
