Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CACE24A7D2
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 22:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgHSUoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 16:44:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59944 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726707AbgHSUoW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 16:44:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597869861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7OkDYQ96IKkBn1skd4NdLteik3rTLwITzQe2j/YDT2U=;
        b=g1TSVA+CK1/b2E/E63GHG31u92GF1YVCThiZeuNViYGU0nRZwAitoyCY17Pw0ITOz5N6o5
        n6CYKuij+GTFW/tTmnfojI1iJipq7W+RFzA7IPC20rDNB8vLcqVta8fwiKatgwllBNzadm
        5T8TrRglcLF+5QPSzuchvXw0sFNxATg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-HXE_-mByMEmpw9K4m0mpYQ-1; Wed, 19 Aug 2020 16:44:17 -0400
X-MC-Unique: HXE_-mByMEmpw9K4m0mpYQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67D91425E1;
        Wed, 19 Aug 2020 20:44:16 +0000 (UTC)
Received: from optiplex-lnx (unknown [10.3.128.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AA7AB747B0;
        Wed, 19 Aug 2020 20:44:08 +0000 (UTC)
Date:   Wed, 19 Aug 2020 16:44:05 -0400
From:   Rafael Aquini <aquini@redhat.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Gao Xiang <hsiangkao@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] mm, THP, swap: fix allocating cluster for swapfile by
 mistake
Message-ID: <20200819204405.GB2096425@optiplex-lnx>
References: <20200819195613.24269-1-hsiangkao@redhat.com>
 <20200819130506.eea076dd618644cd7ff875b6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819130506.eea076dd618644cd7ff875b6@linux-foundation.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 19, 2020 at 01:05:06PM -0700, Andrew Morton wrote:
> On Thu, 20 Aug 2020 03:56:13 +0800 Gao Xiang <hsiangkao@redhat.com> wrote:
> 
> > SWP_FS doesn't mean the device is file-backed swap device,
> > which just means each writeback request should go through fs
> > by DIO. Or it'll just use extents added by .swap_activate(),
> > but it also works as file-backed swap device.
> 
> This is very hard to understand :(
> 

I'll work with Gao to rephrase that message. Sorry!


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
>

My bet here is that it's rare to go for a swapfile on non-rotational
devices, and even rarer to create the swapfile when the filesystem is
already fragmented. 
 
RHEL-8, v4.18-based, is starting to see more adpters among Red Hat's
customer base, thus the report now. We are also working on a secondary 
issue related to CONFIG_THP_SWAP, as well, where the deferred THP split
registered shriker goes for a NULL pointer dereference in case the
swap device is backed by a rotational drive.

-- Rafael

