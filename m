Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F9E4C7D23
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 23:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbiB1WPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 17:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbiB1WPt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 17:15:49 -0500
Received: from matoro.tk (unknown [IPv6:2600:1700:4b10:9d80::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B0EE1B74;
        Mon, 28 Feb 2022 14:14:46 -0800 (PST)
DKIM-Signature: a=rsa-sha256; bh=CMg65jXpaFZltUQYgNoVUODmgfV4a5Gt/jgOwLpN2Vk=;
 c=relaxed/relaxed; d=matoro.tk;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:In-Reply-To:Message-Id:Message-Id:References:References:Autocrypt:Openpgp;
 i=@matoro.tk; s=20220111215046; t=1646086466; v=1; x=1646518466;
 b=liCwhzLM5gcBk9AbRejqNqqD03KZZjvsbftjT52rBX+PyrAJWiCo0hlshB3hxd8NANeQVI4A
 KsG/n++GPEZcsWueUArKoi6tgLgbTt/G+1dlldQkow2gkTIetZjX6dYInMravLdk5Kqg5uQjCHo
 y2wQLkaLEqLYxr4q0h1IG1RVwOmRV/Psn0BnJQekN8/VUILqebObj32oAMawLxij3MDZdh07jA7
 7+EQ7Roj3ZNECHml9j8VErF+h0Ns/v//HiUoGn3GRQu/GVGPVxdt4o7jeodJjQ/LKFZWIgeb/4y
 q+I98cGOqpJa0ZOZT8w1zTU2o2SWft3lxpNUhmWFkzgQ4GcFN0OrDc+KW8OTZD48lnC+1GZyD0n
 z0zjonAnVjmxiychDM41eK5O1awo4cilKOosIrPUiZafcJDZAjPRVkmj0fbgcPx6dsM/0/iZIyj
 z3y7twdwch0hg73Gh7ZkXBIIYhq+vaV0X7/qsQSVywp3ZWiPYsJ5r18p+TbEkOq/CHjnnepoPux
 Fp7PfuqEE9RKIIN510H0kPblNbd7aAXfDB3NvqqL1EQC5ipfWpAXdJ+T5jhtZYcxrjGWl4v1EKO
 nrDF/NGjXsM7QANPbbDxYAf70VhbgY8AhE9ch0LuKvXTQ54M9Rgbogx6wFw0X6HR6QGm96WdjHP
 Bu2xll2bPis=
Received: by matoro.tk (envelope-sender
 <matoro_mailinglist_kernel@matoro.tk>) with ESMTPS id 516b5765; Mon, 28 Feb
 2022 17:14:26 -0500
MIME-Version: 1.0
Date:   Mon, 28 Feb 2022 17:14:26 -0500
From:   matoro <matoro_mailinglist_kernel@matoro.tk>
To:     Kees Cook <keescook@chromium.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Biederman <ebiederm@xmission.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        stable@vger.kernel.org,
        =?UTF-8?Q?Magnus_Gro=C3=9F?= <magnus.gross@rwth-aachen.de>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        regressions@lists.linux.dev, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH 5.16 v2] binfmt_elf: Avoid total_mapping_size for ET_EXEC
In-Reply-To: <20220228205518.1265798-1-keescook@chromium.org>
References: <20220228205518.1265798-1-keescook@chromium.org>
Message-ID: <ce8af9c13bcea9230c7689f3c1e0e2cd@matoro.tk>
X-Sender: matoro_mailinglist_kernel@matoro.tk
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-02-28 15:55, Kees Cook wrote:
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
>   Type Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   
> ...
> ...
>   LOAD 0x000000 0x4000000000000000 0x4000000000000000 0x00b5a0 0x00b5a0 
> ...
>   LOAD 0x00b5a0 0x600000000000b5a0 0x600000000000b5a0 0x0005ac 0x000710 
> ...
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
> problems with ET_EXEC and MAP_FIXED_NOREPLACE: overlaps. This problem 
> is
> with holes. Future work could restore full coverage if 
> load_elf_binary()
> were to perform mappings in a separate phase from the loading (where
> it could resolve both overlaps and holes).
> 
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Eric Biederman <ebiederm@xmission.com>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Reported-by: matoro <matoro_mailinglist_kernel@matoro.tk>
> Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Fixes: 5f501d555653 ("binfmt_elf: reintroduce using 
> MAP_FIXED_NOREPLACE")
> Link:
> https://lore.kernel.org/r/a3edd529-c42d-3b09-135c-7e98a15b150f@leemhuis.info
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
> @@ -1135,14 +1135,25 @@ static int load_elf_binary(struct linux_binprm 
> *bprm)
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

This does the trick!  Thank you so much!!
