Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1DF84ABED5
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 14:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235586AbiBGNEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 08:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392184AbiBGMIg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 07:08:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7124BC0401F5;
        Mon,  7 Feb 2022 04:01:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01AC46101B;
        Mon,  7 Feb 2022 12:01:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7478C004E1;
        Mon,  7 Feb 2022 12:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644235271;
        bh=90hkQ7K1qrYLQ3SDyj0Qf41UdZrDKNgtz2K2mFgJLNw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EYxQVYfXFVVc489UFDzEL5infK/iRmiCudXr9ciakULDsHnJr3wGqo9gJ6lxxJVDU
         /Cy5VZuWGeHLbCCeuacskiEoMb8Z5MM7UPRww3bKgylKDJnszYKXYg2OsQgRILUXhF
         X/8lg8wJXOyqeWTi/l+TN3nbUeY5qXJn5CEAxAGI=
Date:   Mon, 7 Feb 2022 13:01:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     stable@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [RFC PATCH for-stable] kbuild: Define
 LINUX_VERSION_{MAJOR,PATCHLEVEL,SUBLEVEL}
Message-ID: <YgEKBAWp+wAWLfFW@kroah.com>
References: <20220207115212.217744-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207115212.217744-1-jiaxun.yang@flygoat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 07, 2022 at 11:52:12AM +0000, Jiaxun Yang wrote:
> Since the SUBLEVEL overflowed LINUX_VERSION, we have no reliable
> way to tell the current SUBLEVEL in source code.

What in-kernel code needs to know the SUBLEVEL?

> This brings significant difficulties for backport works to deal
> with changes in stable releases.

What backport issues?

> Define those macros so we can continue to get proper SUBLEVEL
> in source without breaking stable ABI by refining KERNEL_VERSION
> bit fields.
> 
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
> For some context: https://lore.kernel.org/backports/bb0ae37aa770e016463706d557fec1c5205bc6a9.camel@sipsolutions.net/T/#t
> ---
>  Makefile | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 99d37c23495e..8132f81d94d8 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1142,7 +1142,10 @@ endef
>  define filechk_version.h
>  	(echo \#define LINUX_VERSION_CODE $(shell                         \
>  	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255); \
> -	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';)
> +	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))'; \
> +	echo \#define LINUX_VERSION_MAJOR $(VERSION); \
> +	echo \#define LINUX_VERSION_PATCHLEVEL $(PATCHLEVEL); \
> +	echo \#define LINUX_VERSION_SUBLEVEL $(SUBLEVEL);)

This is already in Makefile, are you sure you just do not need to
backport a specific patch instead of making your own that does the same
thing?

thanks,

greg k-h
