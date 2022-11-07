Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1DF561F773
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 16:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbiKGPT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 10:19:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbiKGPT6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 10:19:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1014F75
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 07:19:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9EA0B812A1
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 15:19:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0318C433D7;
        Mon,  7 Nov 2022 15:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667834395;
        bh=dOVqCh2NvAcx9RndH2qcTm8nLqUSg+UNNOFPW2kHV2U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rwP22XZ3vGShkX0UJFeEKG+obPEwPOs1WmXL+O6TwOK3IKET++VJO3bLBT/la+xQx
         aiUI7VIF4utCOHjUINLmzgOJpPfPE3f+ZyFnHddEo1c69T6r3DN4IhH8q+Qr/anRJ1
         eBKdWIZkks1qS3aZ5Z6taRRQcsaF46ldect6yNNg=
Date:   Mon, 7 Nov 2022 16:19:52 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.15 2/2] provide arch_test_bit_acquire for architectures
 that define test_bit
Message-ID: <Y2kiGNpHW8pYBVk6@kroah.com>
References: <alpine.LRH.2.21.2210270841040.22202@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.2210270841040.22202@file01.intranet.prod.int.rdu2.redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 08:41:45AM -0400, Mikulas Patocka wrote:
> commit d6ffe6067a54972564552ea45d320fb98db1ac5e upstream.
> 
> Some architectures define their own arch_test_bit and they also need
> arch_test_bit_acquire, otherwise they won't compile.  We also clean up
> the code by using the generic test_bit if that is equivalent to the
> arch-specific version.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
> Fixes: 8238b4579866 ("wait_on_bit: add an acquire memory barrier")
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> ---
>  arch/alpha/include/asm/bitops.h   |    7 +++++++
>  arch/h8300/include/asm/bitops.h   |    3 ++-
>  arch/hexagon/include/asm/bitops.h |   15 +++++++++++++++
>  arch/ia64/include/asm/bitops.h    |    7 +++++++
>  arch/m68k/include/asm/bitops.h    |    6 ++++++
>  arch/s390/include/asm/bitops.h    |    7 +++++++
>  arch/sh/include/asm/bitops-op32.h |    7 +++++++
>  7 files changed, 51 insertions(+), 1 deletion(-)

This is _very_ different from the upstream change that you are trying to
backport here.

Are you sure it is correct?  You are adding real functions for these
arches, while the original backport was _REMOVING_ them and having the
arch code call the generic functions.

So why is this the same?

confused,

greg k-h
