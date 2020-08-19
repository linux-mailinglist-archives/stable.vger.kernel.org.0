Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3893824A79A
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 22:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgHSUP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 16:15:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49338 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726435AbgHSUPZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 16:15:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597868124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6wZSRsOZbW0ppoxwbf389BsXiaVqGjFLolCHa9KVfRI=;
        b=YXxWdcY4HFERidCUvivy2lAFiT9sXrCtM0CK/AmL6kUoEWhaG+fIW4x0YTqvfVAYBzQklc
        I2Embfj6ifM2Q14ueEhocZGy3f4hZj2HwTUbfF5HcbhHUSrnAzFaKmBv7gLIYJkJg86X52
        JzjR4gxWQOcdUSJasVNzKl9Tlo6g25I=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-BXEPkRQiNu-TeoYnFbjzCg-1; Wed, 19 Aug 2020 16:15:22 -0400
X-MC-Unique: BXEPkRQiNu-TeoYnFbjzCg-1
Received: by mail-pj1-f72.google.com with SMTP id mu14so2071773pjb.7
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 13:15:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6wZSRsOZbW0ppoxwbf389BsXiaVqGjFLolCHa9KVfRI=;
        b=P2hxow14M/sD/IR/qpQRwUlmtI1Kzlg9YtyLPv26CG7dKD89VVczXxvpfwmaP3bn0m
         LyF0fl5UDQJndYZ5v+pK8WtM0ciFN9LZM80Y/ov6Mp+bB5wtqJzM/iCfxmGnVLRzcMeq
         8QvSqlIVfjGyeOJG9sYmINi69w4FN5jk2IceG+Vb2XVFoDpYX+19UOTKfLDR0c1r/FTi
         xVs9Cy7EnPhBeQw6Yu6dqIyPnhdCa2pZWgoYDp2RvMJilYYOFQnRQqXUstWFVdCQ3Q6K
         CzQNja4roO99fPHRnwyqjs7Ou98M7oOnPHGSwokg2yomzZUjV91KFNK3k+1B9jSUkrN5
         k3ng==
X-Gm-Message-State: AOAM530xAScIaiWNWVRC2uF8UCG07QQxhIji94nvhDxqoZ6/nqguChYL
        fTvSp6JtNmbFPmW3iqDR6ghBsan0CSk/dAAAV9SNX37egKh8PaaEXihhQzHFPd4dJfrdoqezKfW
        RsXvD5mok6pjRPxoK
X-Received: by 2002:a17:90a:fa06:: with SMTP id cm6mr5515128pjb.129.1597868121452;
        Wed, 19 Aug 2020 13:15:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZ6K3xi/zuEXaLDp+AhVXh18fIyTkt9TT32R+RhUbJpOr/tX/cuBKSRunO6DGE9U7OgqK+kw==
X-Received: by 2002:a17:90a:fa06:: with SMTP id cm6mr5515108pjb.129.1597868121185;
        Wed, 19 Aug 2020 13:15:21 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s125sm56651pfc.63.2020.08.19.13.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 13:15:20 -0700 (PDT)
Date:   Thu, 20 Aug 2020 04:15:09 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rafael Aquini <aquini@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] mm, THP, swap: fix allocating cluster for swapfile by
 mistake
Message-ID: <20200819201509.GA26216@xiangao.remote.csb>
References: <20200819195613.24269-1-hsiangkao@redhat.com>
 <20200819130506.eea076dd618644cd7ff875b6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819130506.eea076dd618644cd7ff875b6@linux-foundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andrew,

On Wed, Aug 19, 2020 at 01:05:06PM -0700, Andrew Morton wrote:
> On Thu, 20 Aug 2020 03:56:13 +0800 Gao Xiang <hsiangkao@redhat.com> wrote:
> 
> > SWP_FS doesn't mean the device is file-backed swap device,
> > which just means each writeback request should go through fs
> > by DIO. Or it'll just use extents added by .swap_activate(),
> > but it also works as file-backed swap device.
> 
> This is very hard to understand :(

Thanks for your reply...

The related logic is in __swap_writepage() and setup_swap_extents(),
and also see e.g generic_swapfile_activate() or iomap_swapfile_activate()...

I will also talk with "Huang, Ying" in person if no response here.

> 
> > So in order to achieve the goal of the original patch,
> > SWP_BLKDEV should be used instead.
> > 
> > FS corruption can be observed with SSD device + XFS +
> > fragmented swapfile due to CONFIG_THP_SWAP=y.
> > 
> > Fixes: f0eea189e8e9 ("mm, THP, swap: Don't allocate huge cluster for file backed swap device")
> > Fixes: 38d8b4e6bdc8 ("mm, THP, swap: delay splitting THP during swap out")
> 
> Why do you think it has taken three years to discover this?

I'm not sure if the Redhat BZ is available for public, it can be reproduced
since rhel 8
https://bugzilla.redhat.com/show_bug.cgi?id=1855474

It seems hard to believe, but I think just because rare user uses the SSD device +
THP + file-backed swap device combination... maybe I'm wrong here, but my test
shows as it is.

Thanks,
Gao Xiang

> 
> 
> 

