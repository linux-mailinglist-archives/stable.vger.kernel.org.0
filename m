Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047193FFFFD
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 14:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349118AbhICMtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 08:49:51 -0400
Received: from mta-mtl-004.bell.net ([209.71.208.14]:34168 "EHLO
        cmx-mtlrgo002.bell.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234262AbhICMtu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 08:49:50 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Sep 2021 08:49:50 EDT
X-RG-CM-BuS: 0
X-RG-CM-SC: 0
X-RG-CM: Clean
X-Originating-IP: [70.52.221.220]
X-RG-Env-Sender: dave.anglin@bell.net
X-RG-Rigid: 60C8945904817A2C
X-CM-Envelope: MS4xfCR83qePRnfzRLqjnEy/RdFL6MH22ulLOCWysgCdTg6ssfpnEp+hlff4ObS/8MUJGyRT8begx65qwTMGnhp3ocMwvwn6Fr0ALJrczNyyyGEpn30h6WIU
 q4y4vYgQ2tHWMrVAwjrZfoeIM3Wib32WlET5Xzl5plBKtsnTaC+wRO5IJwNG/QxaGFnnWm9QJAK4JeQUyHqffxKNPlK8C9M9OKQC1rSCUZjf6x9w+7Ya2TTx
 Wq5EFYT96f+LarNszroNVhGpoWdxX7NhTuX6oI4LnpHoJ63l8Ck5pzbTuB0REShqFP+PNCHOsuV4fTOApA3ZhQDnS8gTcjmac4jy+kj0C5/kl4KRHgxBJV7o
 phE6LFAXTUb/ssJSbOJMix2EjEtj6TMk5E7yNENezRNtGMIJy3Y=
X-CM-Analysis: v=2.4 cv=ENdlb3VC c=1 sm=1 tr=0 ts=61321831
 a=YO5NLpPX/y/Fbmk87HoZTg==:117 a=YO5NLpPX/y/Fbmk87HoZTg==:17
 a=IkcTkHD0fZMA:10 a=VwQbUJbxAAAA:8 a=FBHGMhGWAAAA:8 a=mDV3o1hIAAAA:8
 a=HU3oopfZfLd2ybqOLLQA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=9gvnlMMaQFpL9xblJ6ne:22 a=_FVE-zBwftR9WsbkzFJk:22
Received: from [192.168.2.49] (70.52.221.220) by cmx-mtlrgo002.bell.net (5.8.716.03) (authenticated as dave.anglin@bell.net)
        id 60C8945904817A2C; Fri, 3 Sep 2021 08:42:25 -0400
Subject: Re: [PATCH] parisc: Fix unaligned-access crash in bootloader
To:     Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Arnd Bergmann <arnd@kernel.org>, stable@vger.kernel.org
References: <20210903080045.1048500-1-deller@gmx.de>
From:   John David Anglin <dave.anglin@bell.net>
Message-ID: <ce34beb2-1399-2c8f-8e76-8d7e15ce1b71@bell.net>
Date:   Fri, 3 Sep 2021 08:42:26 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210903080045.1048500-1-deller@gmx.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This worked for me on c8000.

Regards,
Dave

On 2021-09-03 4:00 a.m., Helge Deller wrote:
> Kernel v5.14 has various changes to optimize unaligned memory accesses,
> e.g. commit 0652035a5794 ("asm-generic: unaligned: remove byteshift helpers").
>
> Those changes triggered an unalignment-exception and thus crashed the
> bootloader on parisc because the unaligned "output_len" variable now suddenly
> was read word-wise while it was read byte-wise in the past.
>
> Fix this issue by declaring the external output_len variable as char which then
> forces the compiler to generate byte-accesses.
>
> Signed-off-by: Helge Deller <deller@gmx.de>
> Cc: Arnd Bergmann <arnd@kernel.org>
> Cc: John David Anglin <dave.anglin@bell.net>
> Bug: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=102162
> Fixes: 8c031ba63f8f ("parisc: Unbreak bootloader due to gcc-7 optimizations")
> Fixes: 0652035a5794 ("asm-generic: unaligned: remove byteshift helpers")
> Cc: <stable@vger.kernel.org> # v5.14+
> ---
>  arch/parisc/boot/compressed/misc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/parisc/boot/compressed/misc.c b/arch/parisc/boot/compressed/misc.c
> index 2d395998f524..7ee49f5881d1 100644
> --- a/arch/parisc/boot/compressed/misc.c
> +++ b/arch/parisc/boot/compressed/misc.c
> @@ -26,7 +26,7 @@
>  extern char input_data[];
>  extern int input_len;
>  /* output_len is inserted by the linker possibly at an unaligned address */
> -extern __le32 output_len __aligned(1);
> +extern char output_len;
>  extern char _text, _end;
>  extern char _bss, _ebss;
>  extern char _startcode_end;
> --
> 2.31.1
>


-- 
John David Anglin  dave.anglin@bell.net

