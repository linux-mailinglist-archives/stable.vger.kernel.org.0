Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44544C8BC0
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 13:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbiCAMhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 07:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232437AbiCAMhR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 07:37:17 -0500
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 983B697BBF;
        Tue,  1 Mar 2022 04:36:36 -0800 (PST)
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.94)
          with esmtps (TLS1.2)
          tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1nP1jk-003IcG-9v; Tue, 01 Mar 2022 13:36:16 +0100
Received: from suse-laptop.physik.fu-berlin.de ([160.45.32.140])
          by inpost2.zedat.fu-berlin.de (Exim 4.94)
          with esmtpsa (TLS1.2)
          tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1nP1jk-001HI7-3q; Tue, 01 Mar 2022 13:36:16 +0100
Message-ID: <49182d0d-708b-4029-da5f-bc18603440a6@physik.fu-berlin.de>
Date:   Tue, 1 Mar 2022 13:36:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 5.16 v2] binfmt_elf: Avoid total_mapping_size for ET_EXEC
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>,
        matoro <matoro_mailinglist_kernel@matoro.tk>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Biederman <ebiederm@xmission.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org,
        =?UTF-8?Q?Magnus_Gro=c3=9f?= <magnus.gross@rwth-aachen.de>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        regressions@lists.linux.dev, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20220228205518.1265798-1-keescook@chromium.org>
From:   John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
In-Reply-To: <20220228205518.1265798-1-keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 160.45.32.140
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 2/28/22 21:55, Kees Cook wrote:
> Partially revert commit 5f501d555653 ("binfmt_elf: reintroduce using
> MAP_FIXED_NOREPLACE").
> 
> At least ia64 has ET_EXEC PT_LOAD segments that are not virtual-address
> contiguous (but _are_ file-offset contiguous). This would result in
> giant mapping attempts to cover the entire span, including the virtual
> address range hole. Disable total_mapping_size for ET_EXEC, which
> reduces the MAP_FIXED_NOREPLACE coverage to only the first PT_LOAD:
> 
> $ readelf -lW /usr/bin/gcc
> ...
> Program Headers:
>   Type Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   ...
> ...
>   LOAD 0x000000 0x4000000000000000 0x4000000000000000 0x00b5a0 0x00b5a0 ...
>   LOAD 0x00b5a0 0x600000000000b5a0 0x600000000000b5a0 0x0005ac 0x000710 ...
> ...
>        ^^^^^^^^ ^^^^^^^^^^^^^^^^^^                    ^^^^^^^^ ^^^^^^^^
> 
> File offset range     : 0x000000-0x00bb4c
> 			0x00bb4c bytes
> 
> Virtual address range : 0x4000000000000000-0x600000000000bcb0
> 			0x200000000000bcb0 bytes
> 
> Ironically, this is the reverse of the problem that originally caused
> problems with ET_EXEC and MAP_FIXED_NOREPLACE: overlaps. This problem is
> with holes. Future work could restore full coverage if load_elf_binary()
> were to perform mappings in a separate phase from the loading (where
> it could resolve both overlaps and holes).
> 
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Eric Biederman <ebiederm@xmission.com>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Reported-by: matoro <matoro_mailinglist_kernel@matoro.tk>
> Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Fixes: 5f501d555653 ("binfmt_elf: reintroduce using MAP_FIXED_NOREPLACE")
> Link: https://lore.kernel.org/r/a3edd529-c42d-3b09-135c-7e98a15b150f@leemhuis.info
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> Here's the v5.16 backport.
> ---
>  fs/binfmt_elf.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index f8c7f26f1fbb..911a9e7044f4 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -1135,14 +1135,25 @@ static int load_elf_binary(struct linux_binprm *bprm)
>  			 * is then page aligned.
>  			 */
>  			load_bias = ELF_PAGESTART(load_bias - vaddr);
> -		}
>  
> -		/*
> -		 * Calculate the entire size of the ELF mapping (total_size).
> -		 * (Note that load_addr_set is set to true later once the
> -		 * initial mapping is performed.)
> -		 */
> -		if (!load_addr_set) {
> +			/*
> +			 * Calculate the entire size of the ELF mapping
> +			 * (total_size), used for the initial mapping,
> +			 * due to first_pt_load which is set to false later
> +			 * once the initial mapping is performed.
> +			 *
> +			 * Note that this is only sensible when the LOAD
> +			 * segments are contiguous (or overlapping). If
> +			 * used for LOADs that are far apart, this would
> +			 * cause the holes between LOADs to be mapped,
> +			 * running the risk of having the mapping fail,
> +			 * as it would be larger than the ELF file itself.
> +			 *
> +			 * As a result, only ET_DYN does this, since
> +			 * some ET_EXEC (e.g. ia64) may have virtual
> +			 * memory holes between LOADs.
> +			 *
> +			 */
>  			total_size = total_mapping_size(elf_phdata,
>  							elf_ex->e_phnum);
>  			if (!total_size) {

I can confirm that this patch fixes the issue for me.

Tested-By: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>

Thanks,
Adrian

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer - glaubitz@debian.org
`. `'   Freie Universitaet Berlin - glaubitz@physik.fu-berlin.de
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

