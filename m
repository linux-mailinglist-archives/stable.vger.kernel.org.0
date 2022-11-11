Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD6BB625623
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 10:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbiKKJEa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Nov 2022 04:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233410AbiKKJEH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Nov 2022 04:04:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76DBF82C57
        for <stable@vger.kernel.org>; Fri, 11 Nov 2022 01:02:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B39E61EF6
        for <stable@vger.kernel.org>; Fri, 11 Nov 2022 09:02:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24243C433D6;
        Fri, 11 Nov 2022 09:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668157342;
        bh=Z3fwGNac0qEjYoTh2DCQC3JCtTVpO9IyNKzDEPnrODg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LA0CBaWlF0oXmztLG0gcAM0LIqcht0V8M2lXFCBmd3nX/OUqd8IT1wrvdKr+HC0gk
         pTrvscNVBN+4RZZruMcwmZrKLBijSpyYRchgIZu09PQ6WGaiMap6wrt6+F93psrHAZ
         7UVnmVLveiyra/n4Pl1QdDQP47OJnMQQoiDc/XUY=
Date:   Fri, 11 Nov 2022 10:02:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable 6.0.y] m68k: Rework BI_VIRT_RNG_SEED as BI_RNG_SEED
Message-ID: <Y24PnJtUfUBl0ev2@kroah.com>
References: <20221111014440.495724-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221111014440.495724-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 11, 2022 at 02:44:40AM +0100, Jason A. Donenfeld wrote:
> commit dc63a086daee92c63e392e4e7cd7ed61f3693026 upstream.
> 
> This is useful on !virt platforms for kexec, so change things from
> BI_VIRT_RNG_SEED to be BI_RNG_SEED, and simply remove BI_VIRT_RNG_SEED
> because it only ever lasted one release, and nothing is broken by not
> having it. At the same time, keep a comment noting that it's been
> removed, so that ID isn't reused. In addition, we previously documented
> 2-byte alignment, but 4-byte alignment is actually necessary, so update
> that comment.
> 
> Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Fixes: a1ee38ab1a75 ("m68k: virt: Use RNG seed from bootinfo block")
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Link: https://lore.kernel.org/r/20220927130835.1629806-2-Jason@zx2c4.com
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> Greg - this has a "Fixes" tag and has been in Linus' tree for a while,
> and it applies without anything special, but for some reason didn't make
> it to 6.0.y, and I'm not sure why. So sending it to you manually. But
> I'd be curious to learn why the scripts missed this one. -Jason

We do not always take commits with only "Fixes:" tags on it.  If you
know you want this in a stable tree, add the proper cc: stable tag on
the patch.  That's been the documented way for 18+ years now :)

Sometimes when we get bored, we do run scripts that sweep the commit
logs and pick up patches with only "Fixes:" on it, but I've been busy
with other work these past weeks and have not done so, which is why this
was not picked up.

thanks,

greg k-h
