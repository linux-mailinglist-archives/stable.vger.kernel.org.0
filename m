Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46FA6567AE3
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 01:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiGEXrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 19:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiGEXrP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 19:47:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59759DFA;
        Tue,  5 Jul 2022 16:47:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF82BB817A3;
        Tue,  5 Jul 2022 23:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B8FC341C7;
        Tue,  5 Jul 2022 23:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657064831;
        bh=o6+uEa9oFMJ7TN5lXZ6eXHFu61N/m+3PxNR6KYPiNjE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LZ/XSNiZGUPpls3tn7LlFReeWR1H6ceEEvgQSuy86ficsGImVGGVEI+MkKLLglhhH
         nwn8TLb/sX5SO0/xSuEO92hxS4WR5/BAouAEazVQbnCxEknxgH8FvhIT2MKkpf66Wm
         Gcm3/1Cxc80ZOtNSpTESgImvRkRsj9G7hacIWj08=
Date:   Tue, 5 Jul 2022 16:47:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Muchun Song <songmuchun@bytedance.com>, jgg@ziepe.ca,
        jhubbard@nvidia.com, william.kucharski@oracle.com,
        dan.j.williams@intel.com, jack@suse.cz, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        nvdimm@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: fix missing wake-up event for FSDAX pages
Message-Id: <20220705164710.9541b5cf0e5819193213ea5c@linux-foundation.org>
In-Reply-To: <YsTLgQ45ESpsNEGV@casper.infradead.org>
References: <20220705123532.283-1-songmuchun@bytedance.com>
        <20220705141819.804eb972d43be3434dc70192@linux-foundation.org>
        <YsTLgQ45ESpsNEGV@casper.infradead.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 6 Jul 2022 00:38:41 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> On Tue, Jul 05, 2022 at 02:18:19PM -0700, Andrew Morton wrote:
> > On Tue,  5 Jul 2022 20:35:32 +0800 Muchun Song <songmuchun@bytedance.com> wrote:
> > 
> > > FSDAX page refcounts are 1-based, rather than 0-based: if refcount is
> > > 1, then the page is freed.  The FSDAX pages can be pinned through GUP,
> > > then they will be unpinned via unpin_user_page() using a folio variant
> > > to put the page, however, folio variants did not consider this special
> > > case, the result will be to miss a wakeup event (like the user of
> > > __fuse_dax_break_layouts()).  Since FSDAX pages are only possible get
> > > by GUP users, so fix GUP instead of folio_put() to lower overhead.
> > > 
> > 
> > What are the user visible runtime effects of this bug?
> 
> "missing wake up event" seems pretty obvious to me?  Something goes to
> sleep waiting for a page to become unused, and is never woken.

No, missed wakeups are often obscured by another wakeup coming in
shortly afterwards.

If this wakeup is not one of these, then are there reports from the
softlockup detector?

Do we have reports of processes permanently stuck in D state?

