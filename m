Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52D6513EA3
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 00:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352988AbiD1Wsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 18:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349982AbiD1Wsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 18:48:39 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE7B49278
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 15:45:23 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id x23so146255pff.9
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 15:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AqP7wSbo7WSzSy4l6HYEqupzMjO7gFTkhIq2MzyNb0A=;
        b=JqDgqAkqxRfNNLmqV0twQnowQWIPaTFVuaA6ZtSE2/W9+7fCBmVrEfYajEb2YLBSLl
         FLK4CRbHHZ7Adr96TTRTSNLbqFpTqCm7lDaCsi+ReAeevvlfLijXIIlJHigrlO3hAWxH
         9EpDd9RGsANOfddzRbR+hpqBrPEqHTT7QYWnYEaqkBdZ10YQaukl3uZrWNJqv34AEams
         bj+/Y7gd5kuuqZ9mbAxfsdfhb7PnR7I84PbvfJeEF0ZN22JHRTnofBOZ6YxtLY+84DS8
         wm8xYzPO7IECkoYW9eMr9CEEIgSONOgWiY8dURFPl9tPSea7arRJiDHQU09dGvY3WFnz
         ivIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AqP7wSbo7WSzSy4l6HYEqupzMjO7gFTkhIq2MzyNb0A=;
        b=i18i71OY6dG10cTTqDZLLP6piRKlPbf0M7KDJutXe7MUQex5tXvDCd58FBeRujUblr
         Xfs3BxZFlyPxXxc54s1QpZqdlJlWgdkGf23A8j4bkoQQn6lY29C6FbAv9ElFQf4PtRJH
         vnzHaKz2K6wjlgbid3JIm26nxwwjp3iZSiBVzpgidmbnfoqc3iwDnN877blT1mzIIlFm
         pKTp0+3gVzb50SPMLCStPXBCJKXaCkHNJBy1IW4zXKLuEVZ9yZdTSlijkBtRbO7LGDvQ
         jd7xO4uJ9UhufLhX0eNZW+kQ3jlXwSfmrZ1rEqMVFoDvd3gO8M4cH70NA2S11Nw/Ze5Q
         oOng==
X-Gm-Message-State: AOAM531AH8KSAwNW/ufEt16wFW6R0n6/2aGE4THDds0VJlmk2zU6oAzd
        8Sq0E0trgJiQ7zc7lflRlw44G1l8knCWxA==
X-Google-Smtp-Source: ABdhPJwsExo1O7NKf8dvwXFhJjc/mnTP4ZYbb9E59TysQme5AwpU/tMHJ2sr1oRhM5YRyDB3LjC4pg==
X-Received: by 2002:a05:6a00:190f:b0:50d:8b82:cb90 with SMTP id y15-20020a056a00190f00b0050d8b82cb90mr8179971pfi.65.1651185922372;
        Thu, 28 Apr 2022 15:45:22 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n14-20020a17090a394e00b001d5f22845bdsm11955505pjf.1.2022.04.28.15.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 15:45:21 -0700 (PDT)
Date:   Thu, 28 Apr 2022 22:45:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hugh Dickins <hughd@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Shi <shy828301@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-mm@kvack.org, Sasha Levin <sashal@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH AUTOSEL 13/14] mm/thp: ClearPageDoubleMap in first
 page_add_file_rmap()
Message-ID: <YmsY/n+yXkoEaqqr@google.com>
References: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
 <20220428154222.1230793-13-gregkh@linuxfoundation.org>
 <c2ed1fe1-247e-e644-c367-87d32eb92cf5@google.com>
 <YmrHsVZTEzqIDiKd@kroah.com>
 <bec6e6cf-daa7-d632-7f81-471acba69c9d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bec6e6cf-daa7-d632-7f81-471acba69c9d@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+Sasha and Paolo

On Thu, Apr 28, 2022, Hugh Dickins wrote:
> On Thu, 28 Apr 2022, Greg Kroah-Hartman wrote:
> > On Thu, Apr 28, 2022 at 09:51:58AM -0700, Hugh Dickins wrote:
> > > On Thu, 28 Apr 2022, Greg Kroah-Hartman wrote:
> > > 
> > > > From: Hugh Dickins <hughd@google.com>
> > > > 
> > > > commit bd55b0c2d64e84a75575f548a33a3dfecc135b65 upstream.
> > > > 
> > > > PageDoubleMap is maintained differently for anon and for shmem+file: the
> > > > shmem+file one was never cleared, because a safe place to do so could
> > > > not be found; so it would blight future use of the cached hugepage until
> > > > evicted.
> > > > 
> > > > See https://lore.kernel.org/lkml/1571938066-29031-1-git-send-email-yang.shi@linux.alibaba.com/
> > > > 
> > > > But page_add_file_rmap() does provide a safe place to do so (though later
> > > > than one might wish): allowing testing to return to an initial state
> > > > without a damaging drop_caches.
> > > > 
> > > > Link: https://lkml.kernel.org/r/61c5cf99-a962-9a25-597a-53ab1bd8fbc0@google.com
> > > > Fixes: 9a73f61bdb8a ("thp, mlock: do not mlock PTE-mapped file huge pages")
> > > > Signed-off-by: Hugh Dickins <hughd@google.com>
> > > > Reviewed-by: Yang Shi <shy828301@gmail.com>
> > > > Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > 
> > > NAK.
> > > 
> > > I thought we had a long-standing agreement that AUTOSEL does not try
> > > to add patches from akpm's tree which had not been marked for stable.
> > 
> > True, this was my attempt at saying "hey these all look like they should
> > go to stable trees, why not?"
> 
> Okay, it seems I should have read "AUTOSEL" as "Hey, GregKH here,
> these all look like they should go to stable trees, why not?",
> which would have drawn a friendlier response.

FWIW, Sasha has been using MANUALSEL for the KVM tree to solicit an explicit ACK
from Paolo for these types of patches.  AFAICT, it has been working quite well.
