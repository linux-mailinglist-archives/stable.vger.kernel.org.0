Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3EC1676173
	for <lists+stable@lfdr.de>; Sat, 21 Jan 2023 00:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjATXWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 18:22:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjATXWs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 18:22:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C3A4A1FF;
        Fri, 20 Jan 2023 15:22:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC98F620DD;
        Fri, 20 Jan 2023 23:22:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBF0C433D2;
        Fri, 20 Jan 2023 23:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674256966;
        bh=83cPcQUs7BSJFn4vO+wZXpuOZAFI49/x5VAKkojA3S4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oYi7F9B7JZZ7V3zQ3g0DG0hXSafUSpEg4Ga/ZUMJYz7f/gJN/g8U34TLKi4kPoXWN
         02cffmL9+8d7855C2SjoAHXKVlH8axIORbxzoWhWNkVc9TVBKfbFHquvaUEf1pLLTO
         ZgeVI9D1eK0PJ/Ft9olEQMk1sKjmS/aVwcmMlvIDShgKCT5AQ3trhhNELg9QX0L0Q0
         XtB2Ds6z3qIxdDk7rkrOqL1qheiUVm8uVRWVoSWQkS5ZPiWEkwJXhG2clcWqZe2xm5
         TePwrExpmz+knSkoR0X2y1e1WZcQPvFGGKSCt+C7oeqqpiyfnT6x8OonNCw8o/QRhf
         w9Wl4JJOLPy8Q==
Date:   Fri, 20 Jan 2023 23:22:43 +0000
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        will@kernel.org, catalin.marinas@arm.com, stable@vger.kernel.org,
        Peter Jones <pjones@redhat.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH] efi: tpm: Avoid READ_ONCE() for accessing the event log
Message-ID: <Y8siQ8l1OJqDweuw@kernel.org>
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

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
