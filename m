Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE542B7418
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 03:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbgKRCGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 21:06:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgKRCGx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 21:06:53 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20347C061A48;
        Tue, 17 Nov 2020 18:06:53 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id h12so230207pjv.2;
        Tue, 17 Nov 2020 18:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HZKGduzqBReBfRr08X8V7IvE/bDB3pEOMc9tQAotIvE=;
        b=mQSoM3tpBbs+SzuUQGWHjGluu1bhAz1/FEFkGbOZbZUz11uBEsqFbvKtimMU/um87B
         916uaICDWLpwmbwaL+iBpNwswSh4oxWRUDr4iSLIJGbZLWpb5aa/zm2w9mFDIsrWkT+2
         na8sjo0zllRPiibdAXQ3KhdbQkQWfmGb/XK/fSWQWBZiOACmbHLP2A5KhId6nN2EcSwA
         jSaWSPcy6dUuuu+5L2Y9TRiuBtXTek84eWL+9TyLGc/9E3HZtjDljXX19eO2EZEYRYzO
         szcc6AElGtvMPd9pCw49aa4/Sb9bZkPNgqelMw0k4gtb980X4UBx32AtQoFHH8DFilsp
         d9vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HZKGduzqBReBfRr08X8V7IvE/bDB3pEOMc9tQAotIvE=;
        b=QdvY+VN7oS4jzKOAKo+2jUBmWYLfJ9pinpNw270GCHW2kXgbBYWB2VqW7I5Q04dvDn
         B0o7CSOJMvpKQCa9oio1T0NruQyI2kLV4/xR7AhX5xpOGEFm+bCplbIxzWCOTakD1LI+
         mg228MPr6QBWXKiC5oNtE4+PtJ3bTpZPrWG3p9vN2l6Yz6X25yt4JCwUnE/taDocQ1/E
         +XwWLUyULrsR01HRh5/9OXMOHtOJ0fyNf6sSzSLUNOMumfbfTOdmjjPD4vscx01TfKTB
         R9QTAsArFJGvJVtJI7yhtakG4+E649c8dkHsoRikU/s0yJFFpmeTigWNflxa4/Q+7CJs
         ctnQ==
X-Gm-Message-State: AOAM530kyA/2WKeg1kfb2Uw9ATf/RA389g798vnLOzOJq2S9T990M2at
        yGJRVx6o95EVvonuAQqoY14=
X-Google-Smtp-Source: ABdhPJzsOC1ruRnZumF1K8gm+9+QrU+lBpFYmyxlNYeWCcTFjgmk3F/6fFht7pWy24OfEAuO4KUfTg==
X-Received: by 2002:a17:902:b196:b029:d5:a8fd:9a1c with SMTP id s22-20020a170902b196b02900d5a8fd9a1cmr2372153plr.44.1605665212605;
        Tue, 17 Nov 2020 18:06:52 -0800 (PST)
Received: from localhost ([2409:10:2e40:5100:6e29:95ff:fe2d:8f34])
        by smtp.gmail.com with ESMTPSA id s145sm22886088pfs.187.2020.11.17.18.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 18:06:51 -0800 (PST)
Date:   Wed, 18 Nov 2020 11:06:49 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To:     Minchan Kim <minchan@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        sergey.senozhatsky.work@gmail.com, tony@atomide.com,
        linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Harish Sriram <harish@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "mm/vunmap: add cond_resched() in
 vunmap_pmd_range"
Message-ID: <X7SBufr4GftKY9pB@jagdpanzerIV.localdomain>
References: <20201105170249.387069-1-minchan@kernel.org>
 <20201106175933.90e4c8851010c9ce4dd732b6@linux-foundation.org>
 <20201107083939.GA1633068@google.com>
 <20201112200101.GC123036@google.com>
 <20201112144919.5f6b36876f4e59ebb4a99d6d@linux-foundation.org>
 <20201113162529.GA2378542@google.com>
 <20201116175323.GB3805951@google.com>
 <20201117135632.GA27763@infradead.org>
 <20201117202916.GA3856507@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117202916.GA3856507@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On (20/11/17 12:29), Minchan Kim wrote:
> Yub, I remeber the discussion. 
> https://lore.kernel.org/linux-mm/20200416203736.GB50092@google.com/
> 
> I wanted to remove it but 30% gain made me think again before
> deciding to drop it.
> Since it continue to make problems and Linux is approaching to
> deprecate the 32bit machines, I think it would be better to drop it
> rather than inventing weird workaround.
> 
> Ccing Tony since omap2plus have used it by default for just in case.
> 
> From fc1b17a120991fd86b9e1153ab22d0b0bdadd8d0 Mon Sep 17 00:00:00 2001
> From: Minchan Kim <minchan@kernel.org>
> Date: Tue, 17 Nov 2020 11:58:51 -0800
> Subject: [PATCH] mm/zsmalloc.c: drop ZSMALLOC_PGTABLE_MAPPING
> 
> Even though this option showed some amount improvement(e.g., 30%)
> in some arm32 platforms, it has been headache to maintain since it
> have abused APIs[1](e.g., unmap_kernel_range in atomic context).
> 
> Since we are approaching to deprecate 32bit machines and already made
> the config option available for only builtin build since v5.8, lastly
> it has been not default option in zsmalloc, it's time to drop the
> option for better maintainance.
> 
> [1] http://lore.kernel.org/linux-mm/20201105170249.387069-1-minchan@kernel.org
> 
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: <stable@vger.kernel.org>
> Fixes: e47110e90584 ("mm/vunmap: add cond_resched() in vunmap_pmd_range")
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Looks good to me.

Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

	-ss
