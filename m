Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBDB3F9E40
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 19:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238071AbhH0Rrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 13:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhH0Rrr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 13:47:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44CE2C061757;
        Fri, 27 Aug 2021 10:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=svL56QiGuEqf74xWCkOR06NnNiaAxd4UTs5cmuB+uic=; b=PT+RxIeEjsZlkUc1VjNjOaOMiF
        bZc/XQ7l9FKq6rVIFXSEbJGKnq/ZCw/6tcc7EpK+3fs6wfmcsx5+UVa/C7UK/Cg2imNvGtEFi956B
        glG5v0qAWJ2VOwyF7cwesHoezvHmUg7FOQqXiw/xoW76HlrRC1ypjm0V4+x+XhySc8AJdPv+SammD
        UxOsNMxA/aG3bjansIeQLlSizbEdDvl7IoRiZCv7Px29LgzgZw6ZFt/rL4Kr2A6wyCmQrXmkH1414
        M+NFYJIjyzVOudLlpNWzTW9qaimcwDkjR0WQwCQ9WRW98S0ZbkST8FYBGVUXreaLz4+BSgTHpbo8d
        qPjOWg2A==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJfvD-00EozX-1t; Fri, 27 Aug 2021 17:45:54 +0000
Date:   Fri, 27 Aug 2021 18:45:43 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Li Zhijian <lizhijian@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, akpm@linux-foundation.org,
        jglisse@redhat.com, yishaih@nvidia.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/hmm: bypass devmap pte when all pfn requested flags
 are fulfilled
Message-ID: <YSkkx6Tci3n+qN54@infradead.org>
References: <20210827144500.2148-1-lizhijian@cn.fujitsu.com>
 <20210827162852.GL1200268@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827162852.GL1200268@ziepe.ca>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 27, 2021 at 01:28:52PM -0300, Jason Gunthorpe wrote:
> > +	/*
> > +	 * just bypass devmap pte such as DAX page when all pfn requested
> > +	 * flags(pfn_req_flags) are fulfilled.
> > +	 */
> > +	if (pte_devmap(pte))
> > +		goto out;
> 
> I liked your ealier version better where this was added to the
> pte_special test - logically this is about disambiguating the
> pte_special and the devmap case as they are different things.

Yes, I think that is much more logical.  Also please capitalize the
first word in multi-line comments.
