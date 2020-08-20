Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580A624B90E
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730721AbgHTLh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730849AbgHTLfD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 07:35:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E88C061385;
        Thu, 20 Aug 2020 04:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=t84+Z949JCHOIrLVWyab10y1aUar8zezYlYXe5c2wbk=; b=Vah+zRC10NBMvc8xBtg+tjZiTo
        FG7tUUZHI4+gor8Ux3uZza/5rQmRIf34CLhjWtUc4glJBovY5Zt8tMIGwnOKg026bwsrH9lojI7bL
        E2pXK2kM1ZFDkhxnJx44Kyexr0FfrbS+K7Ic7AF3qsysKTCBWa9tiIRJMbzNOvApL0RROg2bxNoiN
        6l383zlJUyuwUumLjB0w/Xi3RreLD+9ipEDkwtIPtksBVSBgUyyKSjP/UK9C5QsuGrs9rETzxjkXA
        bQzIO195RJBmwBnXAb4ZRT4fRC0sG82WYMpiMOZx0aoZqJ1SqMeFV4vEG9SCc8Nl39JQVEhWdA03e
        DTE5yHTQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k8iqG-0002He-GO; Thu, 20 Aug 2020 11:34:48 +0000
Date:   Thu, 20 Aug 2020 12:34:48 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Rafael Aquini <aquini@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] mm, THP, swap: fix allocating cluster for swapfile by
 mistake
Message-ID: <20200820113448.GM17456@casper.infradead.org>
References: <20200820045323.7809-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820045323.7809-1-hsiangkao@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 12:53:23PM +0800, Gao Xiang wrote:
> SWP_FS is used to make swap_{read,write}page() go through
> the filesystem, and it's only used for swap files over
> NFS. So, !SWP_FS means non NFS for now, it could be either
> file backed or device backed. Something similar goes with
> legacy SWP_FILE.
> 
> So in order to achieve the goal of the original patch,
> SWP_BLKDEV should be used instead.

This is clearly confusing.  I think we need to rename SWP_FS to SWP_FS_OPS.

More generally, the swap code seems insane.  I appreciate that it's an
inherited design from over twenty-five years ago, and nobody wants to
touch it, but it's crazy that it cares about how the filesystem has
mapped file blocks to disk blocks.  I understand that the filesystem
has to know not to allocate memory in order to free memory, but this
is already something filesystems have to understand.  It's also useful
for filesystems to know that this is data which has no meaning after a
power cycle (so it doesn't need to be journalled or snapshotted or ...),
but again, that's useful functionality which we could stand to present
to userspace anyway.

I suppose the tricky thing about it is that working on the swap code is
not as sexy as working on a filesystem, and doing the swap code right
is essentially writing a filesystem, so everybody who's capable already
has something better to do.

Anyway, Gao, please can you submit a follow-on patch to rename SWP_FS?
