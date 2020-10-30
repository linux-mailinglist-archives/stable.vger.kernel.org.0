Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74FB82A0D2B
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 19:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgJ3SND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 14:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgJ3SNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 14:13:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B27C0613D5;
        Fri, 30 Oct 2020 11:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=m8D81kklIjOy7BvetEpdxNnGltgLU0sCcywzvVcT1hA=; b=crzvGERlf5EcYfWKpM3cyPxDmE
        SAozR2s9RBQuRy96mRAYuBOrsj+W1qYpMTYjkDYEmmT3L+oiS8Dho6f1kHFzddDA/snR2kjsDkzkA
        LxOUrdaCbBc5FECvupoxpdAZHL52BTQ437eQJWvAS57TItQZ5MMk4uPnFQs2aiisxoivVquL+LHZ8
        LuDWiB87FO7PpT8NuLpB+9OO25vM6nQ9sD/onj3bx7BW0Ef2SOHqn1GH/BSW2mvdxc6nA7wxgGnIV
        lwyhBl+fyc1ar7gtz2m7dNd3VevGzDc57v+tSg4TQXm1XYk1vjx5mg1kHXs7LU6wLeKpMHsdfA/xh
        zKJzHS9g==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kYYtK-00052F-5N; Fri, 30 Oct 2020 18:12:46 +0000
Date:   Fri, 30 Oct 2020 18:12:46 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Zi Yan <ziy@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Yang Shi <shy828301@gmail.com>, Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Rik van Riel <riel@surriel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/compaction: count pages and stop correctly
 during page isolation.
Message-ID: <20201030181246.GM27442@casper.infradead.org>
References: <20201030155716.3614401-1-zi.yan@sent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030155716.3614401-1-zi.yan@sent.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 30, 2020 at 11:57:15AM -0400, Zi Yan wrote:
> In isolate_migratepages_block, when cc->alloc_contig is true, we are
> able to isolate compound pages, nr_migratepages and nr_isolated did not
> count compound pages correctly, causing us to isolate more pages than we
> thought. Use thp_nr_pages to count pages. Otherwise, we might be trapped
               ^^^^^^^^^^^^
Maybe replace that sentence with "Count compound pages as the number of
base pages they contain"?

