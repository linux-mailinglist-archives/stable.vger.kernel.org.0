Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B8F662DB6
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 18:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjAIRyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 12:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237597AbjAIRwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 12:52:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EA83C387;
        Mon,  9 Jan 2023 09:49:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 706766122F;
        Mon,  9 Jan 2023 17:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1B7C433D2;
        Mon,  9 Jan 2023 17:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673286529;
        bh=D8cQ+OGv0sXy1dauhM+2T07eNZflfR99gYeS8JBaXLE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lX+5Zs8Ym6sOug7E6fmehWpQp2RZClTaoVO4WZsX0ldH1AhYEC+e0zFWr9Iig9d9D
         q+Z+xDe+QkMcHy3OxOTL/pMvLLsdlPqL+84omXePaMcp3xBKj2fcWg1o3+MfJd5t1c
         kchPFA+jZHuMLU3o/Kyh7h1KtwiL665cBe83VavePmZ9HFdMgF1eI7DfNlgHQxaH6v
         EeoS6orRQChY9+X6BdVcjg9ewErF+HNTqjZAgPR1G6jkWHFRcx60+hnUpi6e9QjWWT
         jUTsyuanc7nFHpI8xKspNYYZy1rwmRE6JnS3lVb+ExFubzErkT5h9lpbKoRQul05ye
         KRkquLRB1M//Q==
Date:   Mon, 9 Jan 2023 10:48:47 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        will@kernel.org, catalin.marinas@arm.com, stable@vger.kernel.org,
        Peter Jones <pjones@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] efi: tpm: Avoid READ_ONCE() for accessing the event log
Message-ID: <Y7xTf1SEPTXiCoPM@dev-arch.thelio-3990X>
References: <20230109095948.2471205-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109095948.2471205-1-ardb@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 09, 2023 at 10:59:48AM +0100, Ard Biesheuvel wrote:
> Nathan reports that recent kernels built with LTO will crash when doing
> EFI boot using Fedora's GRUB and SHIM. The culprit turns out to be a
> misaligned load from the TPM event log, which is annotated with
> READ_ONCE(), and under LTO, this gets translated into a LDAR instruction
> which does not tolerate misaligned accesses.
> 
> Interestingly, this does not happen when booting the same kernel
> straight from the UEFI shell, and so the fact that the event log may
> appear misaligned in memory may be caused by a bug in GRUB or SHIM.
> 
> However, using READ_ONCE() to access firmware tables is slightly unusual
> in any case, and here, we only need to ensure that 'event' is not
> dereferenced again after it gets unmapped, so a compiler barrier should
> be sufficient, and works around the reported issue.
> 
> Cc: <stable@vger.kernel.org>
> Cc: Peter Jones <pjones@redhat.com>
> Cc: Jarkko Sakkinen <jarkko@kernel.org>
> Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1782
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Based on the thread, I tested this patch without barrier() and my
machine boots up just fine now with an LTO kernel. Thanks a lot for the
analysis and fix!

Tested-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  include/linux/tpm_eventlog.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/tpm_eventlog.h b/include/linux/tpm_eventlog.h
> index 20c0ff54b7a0d313..0abcc85904cba874 100644
> --- a/include/linux/tpm_eventlog.h
> +++ b/include/linux/tpm_eventlog.h
> @@ -198,8 +198,10 @@ static __always_inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *ev
>  	 * The loop below will unmap these fields if the log is larger than
>  	 * one page, so save them here for reference:
>  	 */
> -	count = READ_ONCE(event->count);
> -	event_type = READ_ONCE(event->event_type);
> +	count = event->count;
> +	event_type = event->event_type;
> +
> +	barrier();
>  
>  	/* Verify that it's the log header */
>  	if (event_header->pcr_idx != 0 ||
> -- 
> 2.39.0
> 
