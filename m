Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51C1158DCE4
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 19:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245156AbiHIRNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 13:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245225AbiHIRM7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 13:12:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0F524BFB
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 10:12:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 223FB60F64
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 17:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8E3C433C1;
        Tue,  9 Aug 2022 17:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660065177;
        bh=RRQd5DnR/jfIumdGwshHWO7SVRUG01mE4P24qcdJquE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uSQeBb3ig/wVm4wHJYmDg9Q9maJCNA2wdilhVlYcP+ZASj8a1P4o/E/vSQaUjVCoG
         ABYs1F1XJ8fZI2do4BwrB76/guCypXOBw2S829PnrZTFtUrTRvgalM6VfJqr5ZC0gG
         hT3Mu4/AtTvZVYMlyjFLa2jF1E8j0VIheU0siweQ=
Date:   Tue, 9 Aug 2022 19:12:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michael Bestas <mkbestas@gmail.com>
Cc:     stable@vger.kernel.org, Hsin-Yi Wang <hsinyi@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH] arm64: map FDT as RW for early_init_dt_scan()
Message-ID: <YvKVlhUZ2I1omy5S@kroah.com>
References: <20220809145624.1819905-1-mkbestas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809145624.1819905-1-mkbestas@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 09, 2022 at 05:56:24PM +0300, Michael Bestas wrote:
> From: Hsin-Yi Wang <hsinyi@chromium.org>
> 
> commit e112b032a72c78f15d0c803c5dc6be444c2e6c66 upstream.
> 
> Currently in arm64, FDT is mapped to RO before it's passed to
> early_init_dt_scan(). However, there might be some codes
> (eg. commit "fdt: add support for rng-seed") that need to modify FDT
> during init. Map FDT to RO after early fixups are done.
> 
> Cc: stable@vger.kernel.org # 4.9+
> Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
> Reviewed-by: Stephen Boyd <swboyd@chromium.org>
> Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> [mkbestas: fixed trivial conflicts for 4.9 backport]
> Signed-off-by: Michael Bestas <mkbestas@gmail.com>
> ---
>  arch/arm64/include/asm/mmu.h |  2 +-
>  arch/arm64/kernel/kaslr.c    |  5 +----
>  arch/arm64/kernel/setup.c    |  9 ++++++++-
>  arch/arm64/mm/mmu.c          | 15 +--------------
>  4 files changed, 11 insertions(+), 20 deletions(-)

What about 4.14.y and newer?

thanks,

greg k-h
