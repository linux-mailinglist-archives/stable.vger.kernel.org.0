Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255683F7EF0
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 01:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbhHYXSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 19:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbhHYXSW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 19:18:22 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20ED3C061757;
        Wed, 25 Aug 2021 16:17:36 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id j4-20020a17090a734400b0018f6dd1ec97so906716pjs.3;
        Wed, 25 Aug 2021 16:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HHA4dIqDyaRjsKrnG7msKRzMkOmDWIdi+lx15oC+hnY=;
        b=u53eiPwI4SZX4G1LTTj5mZCu3Zl0AK0XhynL+hMzMjNY/svqjeirm1+N6itwrdCGfT
         60BW8cG0grgspqqvF0yPGVSGrl0dDSH5wa/pdWkPwVhVWRMZvWYspQNlDJsSiVejj8EZ
         u0KMRPOjE7z1+WjNWWmZinwH+HRlG53DiUzm59nCWLYSareoFLP6T3mv8Xc2miTCgwhA
         AhjJt1+SRiQfKNM5vg6XTMTOK3Y4IQQejAzQi1Z2pzY1mllsZ59e6TlWqHBpv7OnRvwo
         KC7yhYautjr/1n0pL1zc0C8CQnD0QxXBrL/9yQ1Xp+xChg6Ln0AgRpbOp5h/dGfAKfuy
         MEVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=HHA4dIqDyaRjsKrnG7msKRzMkOmDWIdi+lx15oC+hnY=;
        b=d/BuLGE2An+rXPDkQOSGRUro0TQRFSR7R+ExzDwWVTn91fXu1Cerix93vW6i/sYRi8
         2ePNc3wowYjPimfZopp6GG8R8FudIVz+OYIS9Cr2Kcg78f5nLGS2AOTqjOjEV9OXQwhz
         UN/btmwTXJIWqAkbAU6DRHszzgjqpIoaEYyvrp6VdWzp6GocGHl32J42UqjS4tGJPzOQ
         LOIMrSCbm+8rIaz5FAoNllCaAP0iceiAwHIUZ7AjeBBie+sYor+8vT5sHRTV9mG0ugyy
         4CFoNhiY0bYFT+gHD/WLekbRT+3LbqCH3yPldJRXUdOaMAo+vdZv98kkSBl6CZX6w732
         wh8A==
X-Gm-Message-State: AOAM531Bothwgpy1WE16CYcLSUCWmQo7PPEqUjTqGkPV9bmFDn8NJub7
        f5zzouTdiymQ4hgP2TZhVlM=
X-Google-Smtp-Source: ABdhPJxT3qO3YSJ7a9BGhRAk+eoIFxHo9jpHxEMYeUSUnYscmOhUHreFAXYwbGPgWdDX/wMrRqG2nw==
X-Received: by 2002:a17:902:82c6:b0:136:59b0:ed17 with SMTP id u6-20020a17090282c600b0013659b0ed17mr905954plz.61.1629933455556;
        Wed, 25 Aug 2021 16:17:35 -0700 (PDT)
Received: from google.com ([2620:15c:211:201:87f7:83a2:3b32:4366])
        by smtp.gmail.com with ESMTPSA id f10sm989244pgm.77.2021.08.25.16.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 16:17:34 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Wed, 25 Aug 2021 16:17:32 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     cgoldswo@codeaurora.org, david@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [patch 1/2] mm/memory_hotplug: fix potential permanent lru cache
 disable
Message-ID: <YSbPjPykMcGIVM6b@google.com>
References: <20210825121725.0b4f7ca217e22d9750bc6a6d@linux-foundation.org>
 <20210825191755.q1BM2fgnb%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825191755.q1BM2fgnb%akpm@linux-foundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 25, 2021 at 12:17:55PM -0700, Andrew Morton wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> Subject: mm/memory_hotplug: fix potential permanent lru cache disable
> 
> If offline_pages failed after lru_cache_disable(), it forgot to do
> lru_cache_enable() in error path.  So we would have lru cache disabled
> permanently in this case.
> 
> Link: https://lkml.kernel.org/r/20210821094246.10149-3-linmiaohe@huawei.com
> Fixes: d479960e44f2 ("mm: disable LRU pagevec during the migration temporarily")
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Oscar Salvador <osalvador@suse.de>
> Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
> Cc: Chris Goldsworthy <cgoldswo@codeaurora.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Minchan Kim <minchan@kernel.org>

Thanks for catching.
