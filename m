Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84CD82272A3
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 01:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgGTXQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 19:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbgGTXQO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 19:16:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAFE6208E4;
        Mon, 20 Jul 2020 23:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595286974;
        bh=qn5ImIArU+1HeITNc4gt1jj04T1eJdhUcXyemQaZ9zs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wJgArWmSlPuVivt2wShIUZEM5HH922U1b3M/Nn9baMRmfs0ukwTdz0TCJvNeCQh6E
         89kbI7ym0PHfy7lgBxSAyp1ggb4BDrYdwwQ8wrBpx63RsIN6YI7g1bN8XL2q2wtN9r
         KCo+2ge4lgy1J4nTAhc1amHVmMUW7YZ0YQqlaxbk=
Date:   Mon, 20 Jul 2020 16:16:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     js1304@gmail.com
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kernel-team@lge.com, Vlastimil Babka <vbabka@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Roman Gushchin <guro@fb.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Michal Hocko <mhocko@suse.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm/page_alloc: fix non cma alloc context
Message-Id: <20200720161613.15cddfdc2247377347f5471f@linux-foundation.org>
In-Reply-To: <1595220978-9890-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1595220978-9890-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Jul 2020 13:56:15 +0900 js1304@gmail.com wrote:

> Currently, preventing cma area in page allocation is implemented by using
> current_gfp_context(). However, there are two problems of this
> implementation.
> 
> First, this doesn't work for allocation fastpath. In the fastpath,
> original gfp_mask is used since current_gfp_context() is introduced in
> order to control reclaim and it is on slowpath.
> Second, clearing __GFP_MOVABLE has a side effect to exclude the memory
> on the ZONE_MOVABLE for allocation target.
> 
> To fix these problems, this patch changes the implementation to exclude
> cma area in page allocation. Main point of this change is using the
> alloc_flags. alloc_flags is mainly used to control allocation so it fits
> for excluding cma area in allocation.

What are the end user visible runtime effects of this change?

This is pretty much essential information when proposing a -stable
backport.

