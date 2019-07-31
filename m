Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7D597CE33
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 22:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730220AbfGaUZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 16:25:11 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34426 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730205AbfGaUZL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 16:25:11 -0400
Received: by mail-pf1-f195.google.com with SMTP id b13so32498804pfo.1
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 13:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0pLvL4XoGYF6/S/bO4KhBdgKs6/M0DxlhP6T+btdb0E=;
        b=nhwHsvp/32LnkrUUYeFQVJf6a5XG0VbCeyqdOhNKuGjJPAEI+E8IajZXhfy7iku3Nt
         GXQW8AaA5AJ6NNU8XIXmhoOriXYI/zGZfxRpnj3GAYC0ps7JvrlOec9TzP8ptbdIwQYv
         DKXypv6Fq73h5SZxLpblvCN/RVEvKIWxs0yCY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0pLvL4XoGYF6/S/bO4KhBdgKs6/M0DxlhP6T+btdb0E=;
        b=MkjPquUsblJzIkXm0KFh81espnB0tFkMTZPyEaM6fAEjJO5CTO5qcQ5erURJEMrzEP
         QS5wrFkDJHQwA5w8hF53FGB7bmTzczFsjb11P1VFXgWS6sDjs+LsvL6fJXwz3SCJ3nDV
         88ooBDjCr02S2Lbzh+LK3DjK2hSs3qpS1W82aAC0vjPjVBYiqjFmievvqHz3LcaF0J45
         q4lkNimN3tJdi8wrahCxStZl5UVYA0ZYvjsW6MP3yb4r2Yc1/Z1653PErNGxX9Hm6khc
         4qziVEg/Qh5jFSNxWWaA5HHptSn9QkffcgTWvlaa8arUWlXu2T+3cHhymAo3PhZ0viWS
         e9iw==
X-Gm-Message-State: APjAAAW6ThqKDnlZixsYSytLRIc+FpVa0nXNg5uXncGP92LKahuTvsiG
        84uISNF6ktz/dp0ehnhKfcpmDg==
X-Google-Smtp-Source: APXvYqwwz4QXBj6X4jmRiK5RdWk3VtwUDMP0wQe48ogv57D0i040spqUEUMSR5b2sInVDU1XTItkNg==
X-Received: by 2002:a62:ce8e:: with SMTP id y136mr49994255pfg.29.1564604710841;
        Wed, 31 Jul 2019 13:25:10 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id p23sm74797789pfn.10.2019.07.31.13.25.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 31 Jul 2019 13:25:09 -0700 (PDT)
Date:   Wed, 31 Jul 2019 13:25:08 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Isaac J. Manjarres" <isaacm@codeaurora.org>, crecklin@redhat.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, psodagud@codeaurora.org,
        tsoni@codeaurora.org, eberman@codeaurora.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm/usercopy: Use memory range to be accessed for
 wraparound check
Message-ID: <201907311323.2C991F08@keescook>
References: <1564509253-23287-1-git-send-email-isaacm@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564509253-23287-1-git-send-email-isaacm@codeaurora.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 30, 2019 at 10:54:13AM -0700, Isaac J. Manjarres wrote:
> Currently, when checking to see if accessing n bytes starting at
> address "ptr" will cause a wraparound in the memory addresses,
> the check in check_bogus_address() adds an extra byte, which is
> incorrect, as the range of addresses that will be accessed is
> [ptr, ptr + (n - 1)].
> 
> This can lead to incorrectly detecting a wraparound in the
> memory address, when trying to read 4 KB from memory that is
> mapped to the the last possible page in the virtual address
> space, when in fact, accessing that range of memory would not
> cause a wraparound to occur.
> 
> Use the memory range that will actually be accessed when
> considering if accessing a certain amount of bytes will cause
> the memory address to wrap around.
> 
> Fixes: f5509cc18daa ("mm: Hardened usercopy")
> Co-developed-by: Prasad Sodagudi <psodagud@codeaurora.org>
> Signed-off-by: Prasad Sodagudi <psodagud@codeaurora.org>
> Signed-off-by: Isaac J. Manjarres <isaacm@codeaurora.org>
> Cc: stable@vger.kernel.org
> Reviewed-by: William Kucharski <william.kucharski@oracle.com>
> Acked-by: Kees Cook <keescook@chromium.org>

Ah, thanks for the reminder! (I got surprised by seeing my Ack in this
email -- next time please use "v2" or "RESEND" to jog my memory.) This
got lost last year; my bad.

Andrew, can you take this or should I send it directly to Linus?

-Kees

> ---
>  mm/usercopy.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/usercopy.c b/mm/usercopy.c
> index 2a09796..98e92486 100644
> --- a/mm/usercopy.c
> +++ b/mm/usercopy.c
> @@ -147,7 +147,7 @@ static inline void check_bogus_address(const unsigned long ptr, unsigned long n,
>  				       bool to_user)
>  {
>  	/* Reject if object wraps past end of memory. */
> -	if (ptr + n < ptr)
> +	if (ptr + (n - 1) < ptr)
>  		usercopy_abort("wrapped address", NULL, to_user, 0, ptr + n);
>  
>  	/* Reject if NULL or ZERO-allocation. */
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 

-- 
Kees Cook
