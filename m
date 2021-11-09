Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D150244B1D4
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 18:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239874AbhKIRUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 12:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239433AbhKIRUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 12:20:05 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8D8C061766
        for <stable@vger.kernel.org>; Tue,  9 Nov 2021 09:17:16 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id p18so22054777plf.13
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 09:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=90sXlU1lQK9Mv8Sz1Pt9KnDVPcr15fT4vQgBIBLOsdY=;
        b=TlZhoYnziXpLUxFsEQ1mTBynyM7etKcuh/5AWZm6cM1WA1Jh/f1xiNi2D9S9adPyW2
         1VK7KfZBSVRULpmSHKd7wJNlihIkn26Zyeb+SjNHG0iBMlfgEThgo1T/eFHUP7qxt/JL
         cpqqajPlfzjQHX+Ytm3IRpcAJ3DKr1OX+XSCM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=90sXlU1lQK9Mv8Sz1Pt9KnDVPcr15fT4vQgBIBLOsdY=;
        b=U9fPU8ms1yiE+sm+BzTDyvcAbAqI1+XQrcIWBWDeEjITvGMSyzb657+S033REKVGjI
         ikgqlOEOZpaudDbilmwZr/2sQd8LmyC0ml9+CV15BgNl/o6p8is8w6wIQ3F1I5Eb79nm
         Imh08wvLuWM1d3XiSkB/HJ70B8g/t/wTcauqAYQBG5b83v20EdnZbIXc5J4TEO5Oc4pa
         a8sWDcrb2Ck6JhqCn6so40SFEu7Qzj/6PavJulIyIJiK2EkzrrTE/0oX8b2Q4TahAYWf
         aQuhgLV6udsC+6tBwzHpihxgMVNpoDq9llPbiiXvY9YHlQi0mpMukppJQIluRNKIMbPB
         qBJg==
X-Gm-Message-State: AOAM531ByZTf4rjDLyr5lo3VhBHEKSeTAnon8uk6A9FrkXKQ9E7Szs5c
        0i44m03WODZR9SRe7siZeyPpxB2m0IYswA==
X-Google-Smtp-Source: ABdhPJwpgkyrJmn1FLYF19VxwgKPh2GVNmY4LJ1P0P2cED9BgxwbrHQHpr6VFvt4fD8OX6w6v2CBrw==
X-Received: by 2002:a17:902:bd01:b0:140:4094:c70a with SMTP id p1-20020a170902bd0100b001404094c70amr8701452pls.70.1636478236253;
        Tue, 09 Nov 2021 09:17:16 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id e14sm11008006pfv.18.2021.11.09.09.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 09:17:16 -0800 (PST)
Date:   Tue, 9 Nov 2021 09:17:15 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        stable@vger.kernel.org, Sid Hayn <sidhayn@gmail.com>
Subject: Re: [PATCH] mac80211: fix radiotap header generation
Message-ID: <202111090915.F881B406B@keescook>
References: <20211109100203.c61007433ed6.I1dade57aba7de9c4f48d68249adbae62636fd98c@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109100203.c61007433ed6.I1dade57aba7de9c4f48d68249adbae62636fd98c@changeid>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 09, 2021 at 10:02:04AM +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In commit 8c89f7b3d3f2 ("mac80211: Use flex-array for radiotap header
> bitmap") we accidentally pointed the position to the wrong place, so
> we overwrite a present bitmap, and thus cause all kinds of trouble.
> 
> To see the issue, note that the previous code read:
> 
>   pos = (void *)(it_present + 1);
> 
> The requirement now is that we need to calculate pos via it_optional,
> to not trigger the compiler hardening checks, as:
> 
>   pos = (void *)&rthdr->it_optional[...];
> 
> Rewriting the original expression, we get (obviously, since that just
> adds "+ x - x" terms):
> 
>   pos = (void *)(it_present + 1 + rthdr->it_optional - rthdr->it_optional)
> 
> and moving the "+ rthdr->it_optional" outside to be used as an array:
> 
>   pos = (void *)&rthdr->it_optional[it_present + 1 - rthdr->it_optional];
> 
> The original is off by one, fix it.
> 
> Cc: stable@vger.kernel.org
> Fixes: 8c89f7b3d3f2 ("mac80211: Use flex-array for radiotap header bitmap")
> Reported-by: Sid Hayn <sidhayn@gmail.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Argh! Thank you for the fix and sorry for the trouble the earlier patch
created!

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  net/mac80211/rx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index fc5c608d02e2..3562730ea0f8 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -364,7 +364,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
>  	 * the compiler to think we have walked past the end of the
>  	 * struct member.
>  	 */
> -	pos = (void *)&rthdr->it_optional[it_present - rthdr->it_optional];
> +	pos = (void *)&rthdr->it_optional[it_present + 1 - rthdr->it_optional];
>  
>  	/* the order of the following fields is important */
>  
> -- 
> 2.31.1
> 

-- 
Kees Cook
