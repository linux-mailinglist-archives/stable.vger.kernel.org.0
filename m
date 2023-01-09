Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55ABD66297A
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 16:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236470AbjAIPLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 10:11:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234146AbjAIPL1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 10:11:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197F525C5;
        Mon,  9 Jan 2023 07:11:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A902561184;
        Mon,  9 Jan 2023 15:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7380BC433EF;
        Mon,  9 Jan 2023 15:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673277061;
        bh=odY6QjAbOvpE7fHaT+Q/JFKRR8E2t90LcaafBvzc4W0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mw5vM2quubu22s1JORyeWyqPGh+IFo4df8FnVD/XVuM8TLGCIEtEg1uCfjTh2i3U5
         Bh5uotDxycU8iB52xJvp2faVd4CA8ije0kWNxCuIdA6ZnBfxFjsUqxBrNAZMKwcJyO
         bJVetnpOW/JOGsv9T0gFfiolE3NLJKgeUV2qKezr3oJzMe3wCuTISpnqBeyVyKIQpo
         nNElhF3/fGT5kCW7p1GfADdvVj2WOG7arQkzt6ezno4PkjudnK+qE/saeLk0NRymuG
         VhUzuZ8kOwILOHwbecS+oJLnfpRPg35TrEusfOX4+PrTgqUGpXf/zmVdCKf/uLCz+Y
         hJ2iwjIWGTRZg==
Date:   Mon, 9 Jan 2023 15:10:55 +0000
From:   Will Deacon <will@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        catalin.marinas@arm.com, stable@vger.kernel.org,
        Peter Jones <pjones@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH] efi: tpm: Avoid READ_ONCE() for accessing the event log
Message-ID: <20230109151054.GA7817@willie-the-truck>
References: <20230109095948.2471205-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109095948.2471205-1-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
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

Interesting, that's a funny change in behaviour. READ_ONCE() of an unaligned
address is pretty sketchy, but if this ends up tripping lots of folks up
then I suppose we could use a plain load and a DMB LD as an alternative.
It's likely to be more expensive in the LDAPR case, though.

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

It would be handy to have a comment here, but when I started thinking about
what that would say, it occurred to me that the unmap operation should
already have a barrier inside it due to the TLB invalidation, so I'm not
sure why this is needed at all.

Will
