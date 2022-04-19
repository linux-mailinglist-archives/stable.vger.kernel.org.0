Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA64C507D13
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 01:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354517AbiDSXLu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 19:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343503AbiDSXLt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 19:11:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8A1393D8;
        Tue, 19 Apr 2022 16:09:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18C03B81B58;
        Tue, 19 Apr 2022 23:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E3BC385A5;
        Tue, 19 Apr 2022 23:08:59 +0000 (UTC)
Message-ID: <4b1acc9c-bb9b-e3c1-aa0e-58bd69374ccf@linux-m68k.org>
Date:   Wed, 20 Apr 2022 09:08:56 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] binfmt_flat; Drop vestigates of coredump support
Content-Language: en-US
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>
Cc:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        kernel test robot <lkp@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <20220418200834.1501454-1-Niklas.Cassel@wdc.com>
 <202204181501.D55C8D2A@keescook>
 <87mtgh17li.fsf_-_@email.froward.int.ebiederm.org>
From:   Greg Ungerer <gerg@linux-m68k.org>
In-Reply-To: <87mtgh17li.fsf_-_@email.froward.int.ebiederm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 20/4/22 00:16, Eric W. Biederman wrote:
> There is the briefest start of coredump support in binfmt_flat.  It is
> actually a pain to maintain as binfmt_flat is not built on most
> architectures so it is easy to overlook.
> 
> Since the support does not do anything remove it.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
> 
> Apologies for hijacking this thread but it looks like we have people who
> are actively using binfmt_flat on it.
> 
> Does anyone have any objections to simply removing what little there
> is of coredump support from binfmt_flat?

No objections from me.

Acked-by: Greg Ungerer <gerg@linux-m68k.org>


> Eric
> 
>   fs/binfmt_flat.c | 22 ----------------------
>   1 file changed, 22 deletions(-)
> 
> diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
> index 626898150011..0ad2c7bbaddd 100644
> --- a/fs/binfmt_flat.c
> +++ b/fs/binfmt_flat.c
> @@ -37,7 +37,6 @@
>   #include <linux/flat.h>
>   #include <linux/uaccess.h>
>   #include <linux/vmalloc.h>
> -#include <linux/coredump.h>
>   
>   #include <asm/byteorder.h>
>   #include <asm/unaligned.h>
> @@ -98,33 +97,12 @@ static int load_flat_shared_library(int id, struct lib_info *p);
>   #endif
>   
>   static int load_flat_binary(struct linux_binprm *);
> -#ifdef CONFIG_COREDUMP
> -static int flat_core_dump(struct coredump_params *cprm);
> -#endif
>   
>   static struct linux_binfmt flat_format = {
>   	.module		= THIS_MODULE,
>   	.load_binary	= load_flat_binary,
> -#ifdef CONFIG_COREDUMP
> -	.core_dump	= flat_core_dump,
> -	.min_coredump	= PAGE_SIZE
> -#endif
>   };
>   
> -/****************************************************************************/
> -/*
> - * Routine writes a core dump image in the current directory.
> - * Currently only a stub-function.
> - */
> -
> -#ifdef CONFIG_COREDUMP
> -static int flat_core_dump(struct coredump_params *cprm)
> -{
> -	pr_warn("Process %s:%d received signr %d and should have core dumped\n",
> -		current->comm, current->pid, cprm->siginfo->si_signo);
> -	return 1;
> -}
> -#endif
>   
>   /****************************************************************************/
>   /*
