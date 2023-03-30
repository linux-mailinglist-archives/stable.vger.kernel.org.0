Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 211BC6D0905
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 17:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbjC3PDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 11:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbjC3PDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 11:03:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4152983F3;
        Thu, 30 Mar 2023 08:03:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5CFEB828F5;
        Thu, 30 Mar 2023 15:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1CFC433EF;
        Thu, 30 Mar 2023 15:03:25 +0000 (UTC)
Date:   Thu, 30 Mar 2023 11:03:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     Eric Biederman <ebiederm@xmission.com>,
        Baoquan He <bhe@redhat.com>, Philipp Rudo <prudo@redhat.com>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>,
        Simon Horman <horms@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v5 1/2] kexec: Support purgatories with .text.hot
 sections
Message-ID: <20230330110323.7963e3c6@gandalf.local.home>
In-Reply-To: <20230321-kexec_clang16-v5-1-5563bf7c4173@chromium.org>
References: <20230321-kexec_clang16-v5-0-5563bf7c4173@chromium.org>
        <20230321-kexec_clang16-v5-1-5563bf7c4173@chromium.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 30 Mar 2023 11:44:47 +0200
Ricardo Ribalda <ribalda@chromium.org> wrote:

> Clang16 links the purgatory text in two sections:
> 
>   [ 1] .text             PROGBITS         0000000000000000  00000040
>        00000000000011a1  0000000000000000  AX       0     0     16
>   [ 2] .rela.text        RELA             0000000000000000  00003498
>        0000000000000648  0000000000000018   I      24     1     8
>   ...
>   [17] .text.hot.        PROGBITS         0000000000000000  00003220
>        000000000000020b  0000000000000000  AX       0     0     1
>   [18] .rela.text.hot.   RELA             0000000000000000  00004428
>        0000000000000078  0000000000000018   I      24    17     8
> 
> And both of them have their range [sh_addr ... sh_addr+sh_size] on the
> area pointed by `e_entry`.
> 
> This causes that image->start is calculated twice, once for .text and
> another time for .text.hot. The second calculation leaves image->start
> in a random location.
> 
> Because of this, the system crashes immediately after:
> 
> kexec_core: Starting new kernel
> 
> Cc: stable@vger.kernel.org
> Fixes: 930457057abe ("kernel/kexec_file.c: split up __kexec_load_puragory")
> Reviewed-by: Ross Zwisler <zwisler@google.com>
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> ---
>  kernel/kexec_file.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
> index f1a0e4e3fb5c..c7a0e51a6d87 100644
> --- a/kernel/kexec_file.c
> +++ b/kernel/kexec_file.c
> @@ -901,10 +901,22 @@ static int kexec_purgatory_setup_sechdrs(struct purgatory_info *pi,
>  		}
>  
>  		offset = ALIGN(offset, align);
> +
> +		/*
> +		 * Check if the segment contains the entry point, if so,
> +		 * calculate the value of image->start based on it.
> +		 * If the compiler has produced more than one .text section
> +		 * (Eg: .text.hot), they are generally after the main .text
> +		 * section, and they shall not be used to calculate
> +		 * image->start. So do not re-calculate image->start if it
> +		 * is not set to the initial value, and warn the user so they
> +		 * have a chance to fix their purgatory's linker script.
> +		 */
>  		if (sechdrs[i].sh_flags & SHF_EXECINSTR &&
>  		    pi->ehdr->e_entry >= sechdrs[i].sh_addr &&
>  		    pi->ehdr->e_entry < (sechdrs[i].sh_addr
> -					 + sechdrs[i].sh_size)) {
> +					 + sechdrs[i].sh_size) &&
> +		    !WARN_ON(kbuf->image->start != pi->ehdr->e_entry)) {
>  			kbuf->image->start -= sechdrs[i].sh_addr;
>  			kbuf->image->start += kbuf->mem + offset;
>  		}
> 

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Thanks Ricardo!

-- Steve
