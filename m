Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C898132E5B
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 19:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbgAGS0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 13:26:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:34140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728519AbgAGS0j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 13:26:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 378CB206F0;
        Tue,  7 Jan 2020 18:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578421598;
        bh=1u8pj7Qw0AQoNvxZ80zo7WkZ+ykeQKwOkuqIfoY82BI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qAUFCrY0VsgbJsWkl1Ty/fCBqJOnyXxaLaGMFEQAjMBxvtd1+0K//ZkxRuFCl5jFg
         530EHb0+8VYvKLWD+P83krZ6+TZltwhDvzlA7dEYXvsKmEKOWI46y+lWzfxm300iIJ
         HuuEgXWGWhOiBYU7MbqoZCHc7SmDn8bva79/QyqY=
Date:   Tue, 7 Jan 2020 19:26:36 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>, hch@lst.de,
        Sasha Levin <sashal@kernel.org>, m.szyprowski@samsung.com,
        linux- stable <stable@vger.kernel.org>,
        iommu@lists.linux-foundation.org,
        open list <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        lkft-triage@lists.linaro.org
Subject: Re: dma-direct: don't check swiotlb=force in dma_direct_map_resource
Message-ID: <20200107182636.GA2021584@kroah.com>
References: <CA+G9fYvMX4gMi6hmTmukzgr1xPsoJsj0WTm=AS3hC5Mq-dLvsQ@mail.gmail.com>
 <2c401e83-99d2-925f-66fe-fffe04415e1a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c401e83-99d2-925f-66fe-fffe04415e1a@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 07, 2020 at 06:18:28PM +0000, Robin Murphy wrote:
> On 07/01/2020 5:38 pm, Naresh Kamboju wrote:
> > Following build error on stable-rc 5.4.9-rc1 for arm architecture.
> > 
> > dma/direct.c: In function 'dma_direct_possible':
> > dma/direct.c:329:3: error: too many arguments to function 'dma_capable'
> >     dma_capable(dev, dma_addr, size, true);
> >     ^~~~~~~~~~~
> 
> Not sure that $SUBJECT comes into it at all, but by the look of it I guess
> "dma-direct: exclude dma_direct_map_resource from the min_low_pfn check"
> implicitly depends on 130c1ccbf553 ("dma-direct: unify the dma_capable
> definitions") too.

Ugh, good catch.  I'll drop these patches, they don't look ok for stable
at this point in time.

thanks,

greg k-h
