Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD8F140964
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 12:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgAQL7j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 06:59:39 -0500
Received: from mail-wm1-f43.google.com ([209.85.128.43]:33770 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbgAQL7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 06:59:39 -0500
Received: by mail-wm1-f43.google.com with SMTP id d139so9345971wmd.0;
        Fri, 17 Jan 2020 03:59:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=udlU6SpvxzvjKHENifeUg1Az8MLTSzxnXtnR1+RwbnI=;
        b=RJ1UNoEvmG3Oqy2LAy3L4HjXT2D3EBRlZoMfHXg5zEJKnyZjbd4g0z4Jm7t/Ixg7dy
         f2L/zv2GfX4blABsESuzUKstOf8ecHxINhy2f4h7kKBKVyFF6FIu6QHy0EbUlFWAbHRM
         NBD4NiJ2gmfNfBtMQsEXUGqyug8E3gWRZFbiyaj06VNpaXK4Od0Qdbri84ilXa3rWvdy
         /JfvkIcWefEB7i1PrnCF1rF5jKd0Zm92EMrO1F0tPSCkYv3qH9CpA5EpzOM6p7GSgVR7
         N0/n9jkkIAA0zqPNTmTTDIMfrJU6DyjB81dcItUyv/b+boSmq1O1VbGDsX/GaDp/b/yF
         sKNg==
X-Gm-Message-State: APjAAAVSZ/xU+DNPBM9/J48yR/m0N9SoVsHiGmDhFffE/h/EuqyVu91e
        Mt9ziUKNDH2l61uAtTxMVRU=
X-Google-Smtp-Source: APXvYqwN5WxNfeK4SlgaL8V1bxIdZmgc9Q8OC8cG1RNh4NYAGxptEVaBGdfHAAy+NA3Rdh0s+BxZiA==
X-Received: by 2002:a1c:1d1:: with SMTP id 200mr4248107wmb.181.1579262377136;
        Fri, 17 Jan 2020 03:59:37 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id o129sm9364730wmb.1.2020.01.17.03.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 03:59:36 -0800 (PST)
Date:   Fri, 17 Jan 2020 12:59:35 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Kirill Tkhai <ktkhai@virtuozzo.com>, g@suse.cz,
        kirill.shutemov@linux.intel.com
Cc:     David Rientjes <rientjes@google.com>,
        Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org,
        vdavydov.dev@gmail.com, akpm@linux-foundation.or,
        yang.shi@linux.alibaba.com, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        alexander.duyck@gmail.com, stable@vger.kernel.org
Subject: Re: [Patch v3] mm: thp: grab the lock before manipulation defer list
Message-ID: <20200117115935.GW19428@dhcp22.suse.cz>
References: <20200116013100.7679-1-richardw.yang@linux.intel.com>
 <0bb34c4a-97c7-0b3c-cf43-8af6cf9c4396@virtuozzo.com>
 <alpine.DEB.2.21.2001161357240.109233@chino.kir.corp.google.com>
 <20200117091002.GM19428@dhcp22.suse.cz>
 <b67fe2bb-e7a6-29fe-925e-dd1ae176cc4b@virtuozzo.com>
 <alpine.DEB.2.21.2001170132090.20618@chino.kir.corp.google.com>
 <11ba0af7-c2b2-83f9-ac55-7793cedb8028@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11ba0af7-c2b2-83f9-ac55-7793cedb8028@virtuozzo.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 17-01-20 12:42:05, Kirill Tkhai wrote:
> On 17.01.2020 12:32, David Rientjes wrote:
> > On Fri, 17 Jan 2020, Kirill Tkhai wrote:
> > 
> >>>> I think that's a good point, especially considering that the current code 
> >>>> appears to unconditionally place any compound page on the deferred split 
> >>>> queue of the destination memcg.  The correct list that it should appear 
> >>>> on, I believe, depends on whether the pmd has been split for the process 
> >>>> being moved: note the MC_TARGET_PAGE caveat in 
> >>>> mem_cgroup_move_charge_pte_range() that does not move the charge for 
> >>>> compound pages with split pmds.  So when mem_cgroup_move_account() is 
> >>>> called with compound == true, we're moving the charge of the entire 
> >>>> compound page: why would it appear on that memcg's deferred split queue?
> >>>
> >>> I believe Kirill asked how do we know that the page should be actually
> >>> added to the deferred list just from the list_empty check. In other
> >>> words what if the page hasn't been split at all?
> >>
> >> Yes, I'm talking about this. Function mem_cgroup_move_account() adds every
> >> huge page to the deferred list, while we need to do that only for pages,
> >> which are queued for splitting...
> >>
> > 
> > Yup, and that appears broken before Wei's patch.  Since we only migrate 
> > charges of entire compound pages (we have a mapping pmd, the underlying 
> > page cannot be split), it should not appear on the deferred split queue 
> > for any memcg, right?
> 
> Hm. Can't a huge page be mapped in two tasks:

It can but it will get charged to only of the initially. I haven't
checked the THP code in that aspect but from what I remember subpages
shouldn't refer to different memcgs. Kirill Shutemov?
-- 
Michal Hocko
SUSE Labs
