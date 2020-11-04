Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78AF2A5B94
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 02:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730334AbgKDBLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 20:11:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27900 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730273AbgKDBLp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 20:11:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604452304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AYAxNjRS1Y5VJEBPFoYSMpdltV+UvYhl9mJNVdZdbpE=;
        b=aznQ+nR3PMW1f+C1DzEP0ADIl2Ub90D5ILT3HWAcNH19kxp3Y7vk8cI81f78Tp0V1vXusA
        Nhr+O9tZH6KogfCdMKBQ4uw4kBvt9WxeGDgEnwrHvIVbYcav4zWyrAGis/Esbr2WAfeJUV
        9zB6pWVKJ9p+a/lAc20Sh/cOxq0nUGU=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-5eexCRLoMwC-xBqDydXoew-1; Tue, 03 Nov 2020 20:11:42 -0500
X-MC-Unique: 5eexCRLoMwC-xBqDydXoew-1
Received: by mail-pl1-f199.google.com with SMTP id q4so11781848plr.11
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 17:11:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AYAxNjRS1Y5VJEBPFoYSMpdltV+UvYhl9mJNVdZdbpE=;
        b=LH4ig8mVI2s/5Ll1zs1A1K7J9K5JQ57Kxd4FcqmMJt19ax2AVSCTMAKbAMrpQZ9/sm
         lU09e4xX3NvCQGR96RVgNCmf1uIM4/4zHQlRiKaVzTy/WoYiimboYs0f6R0Mflsb+r2Z
         gd2+lZDKcCeZEkVb9dZjCvuKTzn1eqR9CxF0bU2kC8tzKc8RML1uYDYjtj4IQcjlrWQc
         qL0u5C4ixl22WLw3erSgUranTstV6zjsPlFRBTJZBmMPR8ag6EmbeIV7L5JovnudUDtY
         LRq5c07dofa5lwd3r0C76LoqWwUxdLwbm3XKTqHYV1ekDMpufA9rQNTgdPX8naJCKaKd
         WhWA==
X-Gm-Message-State: AOAM530My8/3zUrmG49bMCbSgfxUgcWr1pzFUkQSrVxyEaeYJDRg3DEC
        oKktTjnFVcgiNnBQPul0UAHHPM6vsKmsgk5Dse9by7ATF62vIpkYAaKLLfMlagXs1/uTCwxbVPb
        oCBGOXatd0J/MHMQZ
X-Received: by 2002:a63:7347:: with SMTP id d7mr20014978pgn.63.1604452301753;
        Tue, 03 Nov 2020 17:11:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyxpFMxUi9XiP5r4aFL+JnajpzEAMHAmmzeMKlz0Y0PbIM9eMsx1I6wdXXPSSMhWhLzlvIYCg==
X-Received: by 2002:a63:7347:: with SMTP id d7mr20014962pgn.63.1604452301538;
        Tue, 03 Nov 2020 17:11:41 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t30sm326265pfg.99.2020.11.03.17.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 17:11:41 -0800 (PST)
Date:   Wed, 4 Nov 2020 09:11:30 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Chao Yu <yuchao0@huawei.com>
Cc:     Gao Xiang <hsiangkao@aol.com>, linux-erofs@lists.ozlabs.org,
        Chao Yu <chao@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/4] erofs: fix setting up pcluster for temporary pages
Message-ID: <20201104011130.GA982972@xiangao.remote.csb>
References: <20201022145724.27284-1-hsiangkao.ref@aol.com>
 <20201022145724.27284-1-hsiangkao@aol.com>
 <f1f24a38-97f7-e9cf-03c8-2c95814b98a3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1f24a38-97f7-e9cf-03c8-2c95814b98a3@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 04, 2020 at 09:05:56AM +0800, Chao Yu wrote:
> On 2020/10/22 22:57, Gao Xiang wrote:
> > From: Gao Xiang <hsiangkao@redhat.com>
> > 
> > pcluster should be only set up for all managed pages instead of
> > temporary pages. Since it currently uses page->mapping to identify,
> > the impact is minor for now.
> > 
> > Fixes: 5ddcee1f3a1c ("erofs: get rid of __stagingpage_alloc helper")
> > Cc: <stable@vger.kernel.org> # 5.5+
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> 
> Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks, I've also added a note to the commit message like this,
"
[ Update: Vladimir reported the kernel log becomes polluted
  because PAGE_FLAGS_CHECK_AT_FREE flag(s) set if the page
  allocation debug option is enabled. ]
"
Will apply all of this to -fixes branch.

Thanks,
Gao Xiang

> 
> Thanks,
> 

