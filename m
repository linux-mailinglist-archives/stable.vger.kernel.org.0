Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 763A14EC9CB
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 18:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348873AbiC3Qky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 12:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347960AbiC3Qky (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 12:40:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020BF47572
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 09:39:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE7E5B81D7D
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 16:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B529AC340EC;
        Wed, 30 Mar 2022 16:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648658346;
        bh=sDFIkROWEeyML9L1iXfAPoxQT/IRmsLUKW6DmUSvO2w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2Tm4Kf4CaxAY43SBETjlUtn+GczNdGuv+TByuJSbz7TgQBtrZZQwVPQ0yjn4g4ISu
         0Jvx8qabz4XHCFJJ5E/o7PYw/0JtkG8+Nyn40mfYYjPv1Z6hH96rIXRkfGCSPbYpRf
         RtZqiHgUHNjtBWUKlvUwMalC7D+Rokoq/AlKvOIs=
Date:   Wed, 30 Mar 2022 18:39:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     stable <stable@vger.kernel.org>, Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 2/2] skbuff: Extract list pointers to silence compiler
 warnings
Message-ID: <YkSHpzOJSO7GWVvG@kroah.com>
References: <20220329220256.72283-1-tadeusz.struk@linaro.org>
 <20220329220256.72283-2-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220329220256.72283-2-tadeusz.struk@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 29, 2022 at 03:02:56PM -0700, Tadeusz Struk wrote:
> Please apply this to stable 5.10.y, and 5.15.y
> ---8<---
> 
> From: Kees Cook <keescook@chromium.org>
> 
> Upstream commit: 1a2fb220edca ("skbuff: Extract list pointers to silence compiler warnings")
> 
> Under both -Warray-bounds and the object_size sanitizer, the compiler is
> upset about accessing prev/next of sk_buff when the object it thinks it
> is coming from is sk_buff_head. The warning is a false positive due to
> the compiler taking a conservative approach, opting to warn at casting
> time rather than access time.
> 
> However, in support of enabling -Warray-bounds globally (which has
> found many real bugs), arrange things for sk_buff so that the compiler
> can unambiguously see that there is no intention to access anything
> except prev/next.  Introduce and cast to a separate struct sk_buff_list,
> which contains _only_ the first two fields, silencing the warnings:
> 
> In file included from ./include/net/net_namespace.h:39,
>                  from ./include/linux/netdevice.h:37,
>                  from net/core/netpoll.c:17:
> net/core/netpoll.c: In function 'refill_skbs':
> ./include/linux/skbuff.h:2086:9: warning: array subscript 'struct sk_buff[0]' is partly outside array bounds of 'struct sk_buff_head[1]' [-Warray-bounds]
>  2086 |         __skb_insert(newsk, next->prev, next, list);
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> net/core/netpoll.c:49:28: note: while referencing 'skb_pool'
>    49 | static struct sk_buff_head skb_pool;
>       |                            ^~~~~~~~
> 
> This also upsets UBSAN, which throws a runtime object-size-mismatch
> error complaining about skbuff queue helpers, as below, when the kernel
> is built with clang and -fsanitize=undefined flag set:
> 
> UBSAN: object-size-mismatch in ./include/linux/skbuff.h:2023:28
> member access within address ffffc90000cb71c0 with insufficient space
> for an object of type 'struct sk_buff'
> 
> This change results in no executable instruction differences.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Link: https://lore.kernel.org/r/20211207062758.2324338-1-keescook@chromium.org
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> ---
>  include/linux/skbuff.h | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)

Again, this diff is modified from the original.

I'm not going to take either of these now, sorry,

greg k-h
