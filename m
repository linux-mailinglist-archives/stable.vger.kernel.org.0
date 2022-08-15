Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4E6594840
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244921AbiHOX3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343956AbiHOX0K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:26:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8521747B9B;
        Mon, 15 Aug 2022 13:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UeErxgbLsIOnl1kKr0gd1MbfngQnOPyfN93GP4+152g=; b=KwI+w1Wmmgs2RIYXYUmn/oWg3t
        HZubBothMQce3fFWX8GXOWkWDc7Vc6TNeF2nZPtru/dO1woNE1bvTZ/mViIZ5PRbpuGvu3FQdRsOv
        y5/3PvKxKUrOGiCTFPJPz17iDysP5xjxIdBnh9MpOyVYGWhe1vLxH2BYaeDLuZIohrSvqUpHtwKMV
        V+DLtqiLsKQZJquaiKbQVPDOy+R8Xygz5EKfDS7FQiG4MM4dTUldAe5o7QG2RUBg2a9ptovyvzov/
        JTxIrcqbNiLAAiQZlG9FFLt+oi234Ibx1AU4Xh1YFLCSGwrHTfwIbj7c/lTZu55Clddn0Dm7hkw6k
        /0WcpsTQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oNgLt-006383-RC; Mon, 15 Aug 2022 20:06:21 +0000
Date:   Mon, 15 Aug 2022 21:06:21 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Uladzislau Rezki <urezki@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.19 0246/1157] usercopy: use unsigned long instead of
 uintptr_t
Message-ID: <YvqnPRmBDgUwKpzg@casper.infradead.org>
References: <20220815180439.416659447@linuxfoundation.org>
 <20220815180449.423777119@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815180449.423777119@linuxfoundation.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 15, 2022 at 07:53:22PM +0200, Greg Kroah-Hartman wrote:
> From: Jason A. Donenfeld <Jason@zx2c4.com>
> 
> [ Upstream commit 170b2c350cfcb6f74074e44dd9f916787546db0d ]
> 
> A recent commit factored out a series of annoying (unsigned long) casts
> into a single variable declaration, but made the pointer type a
> `uintptr_t` rather than the usual `unsigned long`. This patch changes it
> to be the integer type more typically used by the kernel to represent
> addresses.
> 
> Fixes: 35fb9ae4aa2e ("usercopy: Cast pointer to an integer once")

Not sure why this needs to be backported?

> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Uladzislau Rezki <urezki@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Joe Perches <joe@perches.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Link: https://lore.kernel.org/r/20220616143617.449094-1-Jason@zx2c4.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  mm/usercopy.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/usercopy.c b/mm/usercopy.c
> index 4e1da708699b..c1ee15a98633 100644
> --- a/mm/usercopy.c
> +++ b/mm/usercopy.c
> @@ -161,7 +161,7 @@ static inline void check_bogus_address(const unsigned long ptr, unsigned long n,
>  static inline void check_heap_object(const void *ptr, unsigned long n,
>  				     bool to_user)
>  {
> -	uintptr_t addr = (uintptr_t)ptr;
> +	unsigned long addr = (unsigned long)ptr;
>  	unsigned long offset;
>  	struct folio *folio;
>  
> -- 
> 2.35.1
> 
> 
> 
