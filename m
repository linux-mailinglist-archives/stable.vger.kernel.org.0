Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD0D567AB1
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 01:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiGEXjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 19:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiGEXjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 19:39:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3A317079;
        Tue,  5 Jul 2022 16:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7dOROrO9ycYqqFp5LnucNCHf+IZBjlMW0xOCXAdstaI=; b=SH/FIVKv4ze5KjxElB8DD+inAv
        WdgdA14/H/bwLYy5QM/Kru16CyPUMnpZ+eg35afyOs5VvA4c7xWgYmI8Nx9YO12eNeJqwzH45+qTr
        dHJcvlOSkhByWy8WIj0WctzuLSc+wZfi2mhShSWc/U6kDWohGRVQfpjj0irNXCCBFxSkoeTtuNfAR
        sMnsK0WTTuTqdIEOCmlQbyxp8vlUEbcQIjFBTj2Dlz0/ivW7eHjSry8gjEQOw2nKpAPqTRuJ2oJd5
        +2a1PjbuHoa08mVoKksM3iFz7LHK/1/kCuK7wIkfMK0Pw7DRhpA/Z/ik0lh87lWBSpoCu6HGi1i0a
        RJmKoX8g==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8s7t-0010o7-IO; Tue, 05 Jul 2022 23:38:41 +0000
Date:   Wed, 6 Jul 2022 00:38:41 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Muchun Song <songmuchun@bytedance.com>, jgg@ziepe.ca,
        jhubbard@nvidia.com, william.kucharski@oracle.com,
        dan.j.williams@intel.com, jack@suse.cz, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        nvdimm@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: fix missing wake-up event for FSDAX pages
Message-ID: <YsTLgQ45ESpsNEGV@casper.infradead.org>
References: <20220705123532.283-1-songmuchun@bytedance.com>
 <20220705141819.804eb972d43be3434dc70192@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705141819.804eb972d43be3434dc70192@linux-foundation.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 05, 2022 at 02:18:19PM -0700, Andrew Morton wrote:
> On Tue,  5 Jul 2022 20:35:32 +0800 Muchun Song <songmuchun@bytedance.com> wrote:
> 
> > FSDAX page refcounts are 1-based, rather than 0-based: if refcount is
> > 1, then the page is freed.  The FSDAX pages can be pinned through GUP,
> > then they will be unpinned via unpin_user_page() using a folio variant
> > to put the page, however, folio variants did not consider this special
> > case, the result will be to miss a wakeup event (like the user of
> > __fuse_dax_break_layouts()).  Since FSDAX pages are only possible get
> > by GUP users, so fix GUP instead of folio_put() to lower overhead.
> > 
> 
> What are the user visible runtime effects of this bug?

"missing wake up event" seems pretty obvious to me?  Something goes to
sleep waiting for a page to become unused, and is never woken.
