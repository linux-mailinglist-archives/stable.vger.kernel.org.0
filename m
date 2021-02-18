Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38A931EDF0
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 19:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhBRSEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 13:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234275AbhBRRZm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 12:25:42 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55106C061574
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 09:25:02 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id h16so1917262qth.11
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 09:25:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S2z0NS3DiwN3dZIAClIRvfeXsAO4LOYJ64TRe3C/7o0=;
        b=fGyGuODawCP34Rupj8caQ3zNuAQl+o4GRLAy2GWjueyzza8Uf/LmKi8FuWrad4kwbK
         3uYRicLrbmcxTjB9fqamZqtICHbE8f8GWteh3d4Pug0/+bI+TT/rPeJ59TO4wx8slR+L
         aCBENovfDMCYkRGkLVHXDb+dKI9c2bXvCCUWWwk8xhTclTv5zXFFB0zjLLuzr0WrLDvr
         zdhFYtzDZSDzQHCYYOyBMrUeW+mxaTtwaxO6Fzwo8haqy4p8XAdaJJtwi4guLhpYQWEL
         JgwQx9Y55aOuBcPCwAC/Wb1RdahPvL0xEUw5OcI0PJKyo5S1JZXEpueWaa/MTNzUTdxP
         XpbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S2z0NS3DiwN3dZIAClIRvfeXsAO4LOYJ64TRe3C/7o0=;
        b=XfiYdZ366u3pWLoF68m2t/Vf4EGIHkUOa2VT5HmfE57RPTYsqQOuq5Df4NtTiqhFwN
         yMxcobOuo1m8IVQypTBAq/mMyIHwniuDFluZgd47RaoKphI6M2vnuIwkShSJ+NTFmYpq
         4DNOTqYTpx8bNcQDt7WDXEZGsR8NbWYTlM91ZZwYkAZ98xSh/RNHYE4th914l9r1zWmy
         HL7cOqgWIPiZwx5VWhXFx25auOJ3ZErpLPk47knhjJIHdWTSmc/BweifeiFnJVQcG01u
         eZehMMRw1oq2ATDydAxmzrzaxT3cxhJnA5f4dpQcxktduavdL0WOYnzgY75/qchHnkfO
         GeqQ==
X-Gm-Message-State: AOAM531SD7a3+MvdtNRFuPMAhsfvlknJIc+j77aQx4sIWZONyYPRHDzZ
        EreeUyBGU+lrA9VjEg9rvs5kXg==
X-Google-Smtp-Source: ABdhPJy9BtEVZOCDpB5CUwEUohd34bx3D9rYmCmzj3soR5Ad2+A7KHFNOLU+Cth69XIxicP/Kv3OAQ==
X-Received: by 2002:ac8:7b4b:: with SMTP id m11mr5287461qtu.208.1613669101624;
        Thu, 18 Feb 2021 09:25:01 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id n4sm4362113qke.30.2021.02.18.09.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 09:25:01 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1lCn2y-00B5ZE-I2; Thu, 18 Feb 2021 13:25:00 -0400
Date:   Thu, 18 Feb 2021 13:25:00 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Zi Yan <ziy@nvidia.com>, Davidlohr Bueso <dbueso@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] hugetlb: fix update_and_free_page contig page struct
 assumption
Message-ID: <20210218172500.GA4718@ziepe.ca>
References: <20210217184926.33567-1-mike.kravetz@oracle.com>
 <20210217110252.185c7f5cd5a87c3f7b0c0144@linux-foundation.org>
 <20210218144554.GS2858050@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218144554.GS2858050@casper.infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 18, 2021 at 02:45:54PM +0000, Matthew Wilcox wrote:
> On Wed, Feb 17, 2021 at 11:02:52AM -0800, Andrew Morton wrote:
> > On Wed, 17 Feb 2021 10:49:25 -0800 Mike Kravetz <mike.kravetz@oracle.com> wrote:
> > > page structs are not guaranteed to be contiguous for gigantic pages.  The
> >
> > June 2014.  That's a long lurk time for a bug.  I wonder if some later
> > commit revealed it.
> 
> I would suggest that gigantic pages have not seen much use.  Certainly
> performance with Intel CPUs on benchmarks that I've been involved with
> showed lower performance with 1GB pages than with 2MB pages until quite
> recently.

I suggested in another thread that maybe it is time to consider
dropping this "feature"

If it has been slightly broken for 7 years it seems a good bet it
isn't actually being used.

The cost to fix GUP to be compatible with this will hurt normal
GUP performance - and again, that nobody has hit this bug in GUP
further suggests the feature isn't used..

Jason 
