Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27BF1D4669
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 19:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbfJKRQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 13:16:56 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40291 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728437AbfJKRQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 13:16:56 -0400
Received: by mail-pf1-f196.google.com with SMTP id x127so6461209pfb.7
        for <stable@vger.kernel.org>; Fri, 11 Oct 2019 10:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mBriml3iAfauQRKfpDbQ5vaiaD735vODzhiE9KF4g38=;
        b=Ub4xqxEXKetk/JV1WBUC4NL36KIS0kftpqOkawvxIYToHs/vjFe/4YqmK1OFX4mwVo
         5WZGZt2rLF7WoEv9/rKk1L2lAypfxdkDNZURmCUjqBjrGvaf52hFZtm5/mc/Gpr24Pgw
         RhprVxdJwYCDhjbCwracqpkAlx4SYSzsTFq0uOo8Mja/+E6CKL3VmuakLFVdm+41vozu
         3e5tO9+Mrv5hI/8so5sl5ibpgYP8qMaVPtxkyWu4DChlDYcfK35HC8Gf00Rx895FuPSu
         pzyx+lMVujTDx3QDdp0PDixeN3TbKkTqELkl1fY2VXxOXdVnm/4W91qsA2QUz7mI+cOI
         oE9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mBriml3iAfauQRKfpDbQ5vaiaD735vODzhiE9KF4g38=;
        b=UzRqNEgFl6NuyK7sD3yq8n1Q+18yNLR2J5N5IWIMugWI2BHkXxGOUny0Pg10DD5u2+
         794k0yjOlEjsdw3w9l4lHd8bYQBdKcoPjRLZ5f0Oot9OtbHLu5gu+l2Lf/GuB4boyA+O
         dAg5Fx3XRY+kgTaQ2gdC6Y5BkrAMwVk30YTL75qr/kgSk0SpkY7Ne+3PGkZ4XkpEfamj
         6UWtP8Gjr8etSNlChUyaNrG3h2/REjCgHVJ8DqVOQz6JdQfxC6aXdVn9mOqoJwT2mqGj
         LckQa00TwBpphlKIYxsPr5xKNVZZPM0zmzTMiBhvb/lS3jp7uyGewXo9RncqoOKj8pAw
         YEyA==
X-Gm-Message-State: APjAAAX9I9lyfDBdkDmm6IUVyBmzQn+fpZRCv6f903LZcwcevHmDKAoV
        tp9QrLQKeKlBoRv+elE52ysiaQ==
X-Google-Smtp-Source: APXvYqw5pokzdLc2n6Op+HT2ZfXwi+YPWVWQFGtUwfC3RFA+PjDKcolG6VaPUhE98V4ZPamoeTyVTw==
X-Received: by 2002:a62:870c:: with SMTP id i12mr17524206pfe.247.1570814215586;
        Fri, 11 Oct 2019 10:16:55 -0700 (PDT)
Received: from minitux (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id w134sm9658594pfd.4.2019.10.11.10.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 10:16:54 -0700 (PDT)
Date:   Fri, 11 Oct 2019 10:16:52 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] ath10k: Correct error check of dma_map_single()
Message-ID: <20191011171652.GF571@minitux>
References: <20191010162653.141303-1-bjorn.andersson@linaro.org>
 <20191011115732.044BF60BE8@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011115732.044BF60BE8@smtp.codeaurora.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 11 Oct 04:57 PDT 2019, Kalle Valo wrote:

> Bjorn Andersson <bjorn.andersson@linaro.org> wrote:
> 
> > The return value of dma_map_single() should be checked for errors using
> > dma_mapping_error(), rather than testing for NULL. Correct this.
> > 
> > Fixes: 1807da49733e ("ath10k: wmi: add management tx by reference support over wmi")
> > Cc: stable@vger.kernel.org
> > Reported-by: Niklas Cassel <niklas.cassel@linaro.org>
> > Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> 
> Did this fix any real bug? Or is this just something found during code review?
> 

CONFIG_DMA_API_DEBUG screamed at us for calling dma_unmap_single()
without ever having called dma_mapping_error() on the return value.

But Govind just pointed out to me that I hastily missed the fact that
this code path leaks the dequeued skb. So I'll respin the patch to fix
both issues at once.

Regards,
Bjorn

> -- 
> https://patchwork.kernel.org/patch/11183923/
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
> 
> 
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
