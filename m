Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05FAEB9BDF
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 03:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730762AbfIUBiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 21:38:25 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18799 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730608AbfIUBiY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 21:38:24 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d857f160000>; Fri, 20 Sep 2019 18:38:30 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 20 Sep 2019 18:38:24 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 20 Sep 2019 18:38:24 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 21 Sep
 2019 01:38:23 +0000
Received: from [10.110.48.28] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 21 Sep
 2019 01:38:23 +0000
Subject: Re: [PATCH] x86/boot: v4.4 stable and v4.9 stable boot failure due to
 dropped patch line
To:     John S Gruber <johnsgruber@gmail.com>, <stable@vger.kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        x86-ml <x86@kernel.org>
References: <20190731054627.5627-2-jhubbard@nvidia.com>
 <1569028015-15344-1-git-send-email-JohnSGruber@gmail.com>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <6c0cf9d6-852e-aea2-6bde-a5f5068ea236@nvidia.com>
Date:   Fri, 20 Sep 2019 18:38:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1569028015-15344-1-git-send-email-JohnSGruber@gmail.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1569029910; bh=w2B3UnWUZO6V52LdFCCMbJYua8i+bml7cjf7utGiZcE=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=WKKnsSDwWsJCPbxMoXuEDFLcAA97DAxPqf4j07RU7cn5PsHWqXlg6QbAWIuEwylYN
         8fycEO4KxNlhb9zzv2MzhHs7rzQ8GReDvPv3kYgSnLDsvsEEOYAHFBIroIbNQCBKib
         p+Z+t1VRouXcxybjDt9++eFO63xg+lKhv5istxjFl06VfQTzu3xnVcI8IxhMWeY7wt
         e9SSHPYEIV9w7KVUZWtcAPCrU47oqpsUYZzZb8deaz7tJQV2ZPDsvWz2cKoItgqgGY
         GOaSSxFuFARNt8DhrdDYkpyLscLDkfIPCeF+ZD+REYw3Snf4ewVueHa1AD5SJ42rbw
         Lv20aUxXIf63g==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/20/19 6:06 PM, John S Gruber wrote:
> This regards upstream commit a90118c445cc ("x86/boot: Save fields
> explicitly, zero out everything else") application to linux-stable.
> 
> Its corresponding commits to the stable 4.4 and 4.9 trees didn't apply
> correctly, probably due to a field name change (e820_table had been named
> e820_map before 4.10).
> 
> On my desktop I'm unable to boot a signed kernel due to these commits.
> 
> Add e820_map (to replace e820_table) to the preserved fields so that the
> E820 memory regions in boot_params can be accessed by the kernel after
> boot_params has been sanitized.
> 
> Signed-off-by: John S Gruber <JohnSGruber@gmail.com>
> Fixes: 41664b97f46e ("x86/boot: Save fields explicitly, zero out everything else")
> Fixes: 4e478cb2ccdd ("x86/boot: Save fields explicitly, zero out everything else")
> Link: https://lore.kernel.org/lkml/20190731054627.5627-2-jhubbard@nvidia.com/
> ---
> 
> I tested stable 4.14.145, 4.19.74, and 5.2.16 successfully under the same
> circumstances. Only 4.4 and 4.9 are affected by this dropped line.
> 
>  arch/x86/include/asm/bootparam_utils.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/include/asm/bootparam_utils.h b/arch/x86/include/asm/bootparam_utils.h
> index 0232b5a..588d8fb 100644
> --- a/arch/x86/include/asm/bootparam_utils.h
> +++ b/arch/x86/include/asm/bootparam_utils.h
> @@ -71,6 +71,7 @@ static void sanitize_boot_params(struct boot_params *boot_params)
>  			BOOT_PARAM_PRESERVE(edd_mbr_sig_buf_entries),
>  			BOOT_PARAM_PRESERVE(edd_mbr_sig_buffer),
>  			BOOT_PARAM_PRESERVE(hdr),
> +			BOOT_PARAM_PRESERVE(e820_map),
>  			BOOT_PARAM_PRESERVE(eddbuf),
>  		};
>  
> 

Reviewed-by: John Hubbard <jhubbard@nvidia.com>

Thanks for getting -stable figured out and fixed--this has not been smooth sailing!


thanks,
-- 
John Hubbard
NVIDIA
