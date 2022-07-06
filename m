Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32641567C40
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 05:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbiGFDBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 23:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbiGFDBG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 23:01:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962B71EC4A;
        Tue,  5 Jul 2022 20:00:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3037761A1B;
        Wed,  6 Jul 2022 03:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30997C341C7;
        Wed,  6 Jul 2022 03:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657076443;
        bh=p9zi6uyM9qZDm3W0u/jsISQwFAYeuS6nldtEVEqNG/E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rt/h9LdUOjMjJYbJ2H8AHVZ59vIHrgzVmYFUT5T9rfYDXGF2TXl6GJtUTSbGD+Xsv
         R7Twty8/1D88fxTyrvcgCU4W2qvrjUYDAGMI5sGnHaVX/xfY88uNktnLe2dyLI/cqk
         okhBcnw6gUg1JOHo8MX6rjp0Vjo+rk76AfiFT6k4=
Date:   Tue, 5 Jul 2022 20:00:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     Matthew Wilcox <willy@infradead.org>, jgg@ziepe.ca,
        jhubbard@nvidia.com, william.kucharski@oracle.com,
        dan.j.williams@intel.com, jack@suse.cz, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        nvdimm@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: fix missing wake-up event for FSDAX pages
Message-Id: <20220705200042.26ddd5e2e106df4e65adcc74@linux-foundation.org>
In-Reply-To: <YsT3xFSLJonnA2XC@FVFYT0MHHV2J.usts.net>
References: <20220705123532.283-1-songmuchun@bytedance.com>
        <20220705141819.804eb972d43be3434dc70192@linux-foundation.org>
        <YsTLgQ45ESpsNEGV@casper.infradead.org>
        <20220705164710.9541b5cf0e5819193213ea5c@linux-foundation.org>
        <YsT3xFSLJonnA2XC@FVFYT0MHHV2J.usts.net>
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

On Wed, 6 Jul 2022 10:47:32 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> > If this wakeup is not one of these, then are there reports from the
> > softlockup detector?
> > 
> > Do we have reports of processes permanently stuck in D state?
> >
> 
> No. The task is in an TASK_INTERRUPTIBLE state (see __fuse_dax_break_layouts). 
> The hung task reporter only reports D task (TASK_UNINTERRUPTIBLE).

Thanks, I updated the changelog a bit.

: FSDAX page refcounts are 1-based, rather than 0-based: if refcount is
: 1, then the page is freed.  The FSDAX pages can be pinned through GUP,
: then they will be unpinned via unpin_user_page() using a folio variant
: to put the page, however, folio variants did not consider this special
: case, the result will be to miss a wakeup event (like the user of
: __fuse_dax_break_layouts()).  This results in a task being permanently
: stuck in TASK_INTERRUPTIBLE state.
: 
: Since FSDAX pages are only possibly obtained by GUP users, so fix GUP
: instead of folio_put() to lower overhead.

I believe these details are helpful for -stable maintainers who are
wondering why they were sent stuff.  Also for maintainers of
downstreeam older kernels who are scratching heads over some user bug
report, trying to find a patch which might fix it - for this they want
to see a description of the user-visible effects, for matching with
that bug report.
