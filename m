Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAF25A93BA
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 11:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiIAJ6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 05:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbiIAJ6C (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 05:58:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412BC13778F
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 02:58:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF4B2B8255E
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 09:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A717C433D6;
        Thu,  1 Sep 2022 09:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662026278;
        bh=kV341kEud1SdNlHVGRW8mPXcJpeuxbGPwHt+lNvqVnw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vp49PUrcgMhygoTTfL2HZ2aSPx9jp5xO98QU1pcylidRcjETcNNtgEvcgL7F4ZoG0
         CIUGtUPs55H1qXQJFUAsdVjJpffnCH/b81ZZA9oz3tOVl7tH2F96CjSShiJKyr/XJS
         8HMzsbGXChaLveqTJutzTTPB9f4XKZO/Kd7s18Jo=
Date:   Thu, 1 Sep 2022 11:57:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michael Bestas <mkbestas@gmail.com>
Cc:     stable@vger.kernel.org, Hsin-Yi Wang <hsinyi@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH] arm64: map FDT as RW for early_init_dt_scan()
Message-ID: <YxCCI2c6l8OdA4GV@kroah.com>
References: <20220831203200.1684696-1-mkbestas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831203200.1684696-1-mkbestas@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 31, 2022 at 11:32:00PM +0300, Michael Bestas wrote:
> From: Hsin-Yi Wang <hsinyi@chromium.org>
> 
> commit e112b032a72c78f15d0c803c5dc6be444c2e6c66 upstream.
> 
> Currently in arm64, FDT is mapped to RO before it's passed to
> early_init_dt_scan(). However, there might be some codes
> (eg. commit "fdt: add support for rng-seed") that need to modify FDT
> during init. Map FDT to RO after early fixups are done.
> 
> Cc: stable@vger.kernel.org # 4.14
> Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
> Reviewed-by: Stephen Boyd <swboyd@chromium.org>
> Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> [mkbestas: fixed trivial conflicts for 4.14 backport]
> Signed-off-by: Michael Bestas <mkbestas@gmail.com>
> ---
>  arch/arm64/include/asm/mmu.h |  2 +-
>  arch/arm64/kernel/kaslr.c    |  5 +----
>  arch/arm64/kernel/setup.c    |  9 ++++++++-
>  arch/arm64/mm/mmu.c          | 15 +--------------
>  4 files changed, 11 insertions(+), 20 deletions(-)
> 

Both now queued up, thanks.

greg k-h
